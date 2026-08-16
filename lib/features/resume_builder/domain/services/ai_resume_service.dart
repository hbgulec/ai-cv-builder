import '../../domain/entities/resume_entity.dart';

/// Abstract service for AI-assisted resume enhancements
abstract class AiResumeService {
  /// Rewrites a single job experience bullet point to be action-oriented and quantifiable
  Future<String> enhanceBulletPoint({
    required String originalText,
    required String jobTitle,
    required String targetIndustry,
  });

  /// Generates a professional summary tailored to target job title and skills
  Future<String> generateProfessionalSummary({
    required HeaderInfo header,
    required List<WorkExperience> experiences,
    required List<Skill> skills,
    required String targetJobTitle,
  });

  /// Analyzes ATS compatibility score and suggests missing key terms
  Future<Map<String, dynamic>> analyzeAtsScore({
    required ResumeEntity resume,
    required String jobDescription,
  });
}

/// Mock AI Resume Service implementation (providing instant feedback & fallback)
class MockAiResumeServiceImpl implements AiResumeService {
  @override
  Future<String> enhanceBulletPoint({
    required String originalText,
    required String jobTitle,
    required String targetIndustry,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return 'Spearheaded $originalText, resulting in a 35% reduction in latency and improving overall system throughput.';
  }

  @override
  Future<String> generateProfessionalSummary({
    required HeaderInfo header,
    required List<WorkExperience> experiences,
    required List<Skill> skills,
    required String targetJobTitle,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final topSkills = skills.take(4).map((s) => s.name).join(', ');
    return 'Results-oriented $targetJobTitle with proven expertise in $topSkills. Demonstrated history of delivering high-impact software solutions across fast-paced environments.';
  }

  @override
  Future<Map<String, dynamic>> analyzeAtsScore({
    required ResumeEntity resume,
    required String jobDescription,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return {
      'score': 88,
      'grade': 'A',
      'matchedKeywords': ['Flutter', 'Clean Architecture', 'State Management', 'REST API'],
      'missingKeywords': ['CI/CD Pipelines', 'GraphQL'],
      'suggestions': [
        'Add quantifiable metrics to your latest work experience bullet points.',
        'Include CI/CD deployment tools under your core skills section.',
      ],
    };
  }
}
