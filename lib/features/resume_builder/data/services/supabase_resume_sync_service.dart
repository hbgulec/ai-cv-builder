import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/supabase_bootstrap.dart';
import '../datasources/resume_local_datasource.dart';
import '../../domain/entities/resume_entity.dart';

class SupabaseResumeSyncService {
  SupabaseResumeSyncService({
    ResumeLocalDatasource? localDatasource,
    Uuid? uuid,
  })  : _localDatasource = localDatasource ?? ResumeLocalDatasource(),
        _uuid = uuid ?? const Uuid();

  final ResumeLocalDatasource _localDatasource;
  final Uuid _uuid;

  bool get isConfigured => SupabaseBootstrap.isInitialized;

  Future<List<ResumeEntity>> loadResumes() async {
    final localResumes = await _localDatasource.getAllResumes();
    if (!isConfigured) {
      return _sortByUpdatedAt(localResumes);
    }

    try {
      final user = await _ensureUser();
      final response = await Supabase.instance.client
          .from('resumes')
          .select()
          .eq('user_id', user.id)
          .order('updated_at', ascending: false);

      final remoteResumes = (response as List<dynamic>)
          .map(_resumeFromRow)
          .toList(growable: false);
      final mergedById = {
        for (final resume in remoteResumes) resume.id: resume,
      };

      for (final localResume in localResumes.where((item) => !item.isSynced)) {
        final syncedResume = await _upsert(user, localResume);
        mergedById[syncedResume.id] = syncedResume;
      }

      final merged = _sortByUpdatedAt(mergedById.values.toList());
      await _localDatasource.replaceAll(merged);
      return merged;
    } catch (_) {
      return _sortByUpdatedAt(localResumes);
    }
  }

  Future<ResumeEntity> saveResume(ResumeEntity resume) async {
    final pendingResume = resume.copyWith(isSynced: false);
    await _localDatasource.saveResume(pendingResume);
    if (!isConfigured) {
      return pendingResume;
    }

    try {
      final user = await _ensureUser();
      final syncedResume = await _upsert(user, pendingResume);
      await _localDatasource.saveResume(syncedResume);
      return syncedResume;
    } catch (_) {
      return pendingResume;
    }
  }

  Future<void> deleteResume(String resumeId) async {
    await _localDatasource.deleteResume(resumeId);
    if (!isConfigured || !_isUuid(resumeId)) {
      return;
    }

    try {
      final user = await _ensureUser();
      await Supabase.instance.client
          .from('resumes')
          .delete()
          .eq('id', resumeId)
          .eq('user_id', user.id);
    } catch (_) {
      // The local deletion is retained; a later sync can reconcile it.
    }
  }

  Future<User> _ensureUser() async {
    final auth = Supabase.instance.client.auth;
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      return currentUser;
    }

    final response = await auth.signInAnonymously();
    final user = response.user;
    if (user == null) {
      throw const AuthException('Anonymous sign-in did not return a user.');
    }
    return user;
  }

  Future<ResumeEntity> _upsert(User user, ResumeEntity resume) async {
    final validResume = _isUuid(resume.id)
        ? resume
        : resume.copyWith(id: _uuid.v4(), createdAt: DateTime.now());
    final ownedResume = validResume.copyWith(
      userId: user.id,
      isSynced: true,
      updatedAt: DateTime.now(),
    );
    final document = ownedResume.toJson();

    await Supabase.instance.client.from('resumes').upsert(
      {
        'id': ownedResume.id,
        'user_id': user.id,
        'title':
            ownedResume.title.isEmpty ? 'Untitled Resume' : ownedResume.title,
        'template_id': ownedResume.templateId,
        'content_language': ownedResume.contentLanguage,
        'document': document,
        'schema_version': ownedResume.schemaVersion,
      },
      onConflict: 'id',
    );
    return ownedResume;
  }

  ResumeEntity _resumeFromRow(dynamic row) {
    final values = Map<String, dynamic>.from(row as Map);
    final document = Map<String, dynamic>.from(values['document'] as Map);
    return ResumeEntity.fromJson(document).copyWith(
      id: values['id'] as String,
      userId: values['user_id'] as String,
      isSynced: true,
    );
  }

  List<ResumeEntity> _sortByUpdatedAt(List<ResumeEntity> resumes) {
    final sorted = List<ResumeEntity>.from(resumes);
    sorted.sort((first, second) => second.updatedAt.compareTo(first.updatedAt));
    return sorted;
  }

  bool _isUuid(String value) {
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(value);
  }
}

final supabaseResumeSyncServiceProvider =
    Provider<SupabaseResumeSyncService>((ref) {
  return SupabaseResumeSyncService();
});
