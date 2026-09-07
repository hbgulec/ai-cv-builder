import 'resume_entity.dart';

/// An immutable snapshot created each time a resume is saved to the cloud.
class ResumeVersion {
  const ResumeVersion({
    required this.id,
    required this.resumeId,
    required this.createdAt,
    required this.resume,
  });

  final String id;
  final String resumeId;
  final DateTime createdAt;
  final ResumeEntity resume;

  factory ResumeVersion.fromRow(Map<String, dynamic> row) {
    final document = Map<String, dynamic>.from(row['document'] as Map);
    return ResumeVersion(
      id: row['id'] as String,
      resumeId: row['resume_id'] as String,
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      resume: ResumeEntity.fromJson(document),
    );
  }
}
