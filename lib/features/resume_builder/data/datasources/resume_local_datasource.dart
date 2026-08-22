import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

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

  /// Opens an encrypted local cache; the AES key stays in secure storage.
  Future<Box<String>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      final key = await _getEncryptionKey();
      return Hive.openBox<String>(
        _boxName,
        encryptionCipher: HiveAesCipher(key),
      );
    }
    return Hive.box<String>(_boxName);
  }

  Future<Uint8List> _getEncryptionKey() async {
    final storedKey = await _secureStorage.read(key: _encryptionKeyName);
    if (storedKey != null) {
      return Uint8List.fromList(base64Decode(storedKey));
    }

    final key = Uint8List.fromList(
      List<int>.generate(32, (_) => Random.secure().nextInt(256)),
    );
    await _secureStorage.write(
      key: _encryptionKeyName,
      value: base64Encode(key),
    );
    return key;
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

  /// Replaces the cache after a successful remote sync.
  Future<void> replaceAll(List<ResumeEntity> resumes) async {
    final box = await _openBox();
    final entries = <String, String>{
      for (final resume in resumes) resume.id: jsonEncode(resume.toJson()),
    };
    await box.clear();
    await box.putAll(entries);
  }

  /// Clear all stored resumes
  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
