import '../../../resume_builder/domain/entities/resume_entity.dart';

/// Evaluates a [ResumeEntity] and calculates an objective ATS Match Score (0 to 100).
class AtsScoreCalculator {
  static int calculateScore(ResumeEntity resume) {
    int score = 0;

    // 1. Header Information (Max 20 pts)
    final h = resume.header;
    if (h.fullName.trim().isNotEmpty) score += 5;
    if (h.professionalTitle != null && h.professionalTitle!.trim().isNotEmpty) score += 5;
    if (h.email != null && h.email!.trim().isNotEmpty && h.email!.contains('@')) score += 4;
    if (h.phone != null && h.phone!.trim().isNotEmpty) score += 3;
    if (h.location != null && h.location!.trim().isNotEmpty) score += 3;

    // 2. Summary Section (Max 15 pts)
    final summary = resume.summary.trim();
    if (summary.isNotEmpty) {
      score += 5;
      if (summary.length >= 80) score += 5; // Detailed summary
      if (summary.length >= 150) score += 5; // Professional comprehensive summary
    }

    // 3. Work Experience (Max 35 pts)
    if (resume.workExperiences.isNotEmpty) {
      score += 10;
      int bulletPointsCount = 0;
      for (final exp in resume.workExperiences) {
        if (exp.jobTitle.isNotEmpty && exp.company.isNotEmpty) {
          score += 2;
        }
        bulletPointsCount += exp.bulletPoints.length;
      }
      if (bulletPointsCount >= 2) score += 5;
      if (bulletPointsCount >= 4) score += 5;
      if (bulletPointsCount >= 6) score += 5;
    }

    // 4. Education (Max 15 pts)
    if (resume.educationList.isNotEmpty) {
      score += 10;
      final edu = resume.educationList.first;
      if (edu.degree.isNotEmpty && edu.institution.isNotEmpty) {
        score += 5;
      }
    }

    // 5. Skills Section (Max 15 pts)
    final skillCount = resume.skills.length;
    if (skillCount > 0) score += 5;
    if (skillCount >= 3) score += 5;
    if (skillCount >= 5) score += 5;

    // Ensure score stays in range [0, 100]
    return score.clamp(0, 100);
  }
}
