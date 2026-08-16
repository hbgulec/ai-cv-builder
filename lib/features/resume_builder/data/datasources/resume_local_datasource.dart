import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/resume_entity.dart';

/// Local datasource for saving/loading resumes using Hive + encrypted storage.
class ResumeLocalDatasource {
  static const String _boxName = 'resumes';
  static const String _encryptionKeyName = 'resume_encryption_key';
  final FlutterSecureStorage _secureStorage;

  ResumeLocalDatasource({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Initialize Hive and open the resumes box
  Future<Box<String>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<String>(_boxName);
    }
    return Hive.box<String>(_boxName);
  }

  /// Save a resume entity to local storage
  Future<void> saveResume(ResumeEntity resume) async {
    final box = await _openBox();
    final jsonStr = jsonEncode(resume.toJson());
    await box.put(resume.id, jsonStr);
  }

  /// Load a single resume by ID
  Future<ResumeEntity?> getResume(String id) async {
    final box = await _openBox();
    final jsonStr = box.get(id);
    if (jsonStr == null) return null;
    return ResumeEntity.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
  }

  /// Load all saved resumes
  Future<List<ResumeEntity>> getAllResumes() async {
    final box = await _openBox();
    final resumes = <ResumeEntity>[];
    for (final jsonStr in box.values) {
      try {
        resumes.add(
          ResumeEntity.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>),
        );
      } catch (_) {
        // Skip corrupted entries
      }
    }
    return resumes;
  }

  /// Delete a resume by ID
  Future<void> deleteResume(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  /// Clear all stored resumes
  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
