// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'AI CV Builder';

  @override
  String get atsOptimizedSub => 'ATS Uyumlu Özgeçmişler';

  @override
  String get dashboardTitle => 'Özgeçmişlerim';

  @override
  String get createNewCv => 'Yeni CV';

  @override
  String aiCreditsRemaining(Object count) {
    return '$count AI Kredisi Kaldı';
  }

  @override
  String stepProgress(Object current, Object total) {
    return 'Adım $current / $total';
  }

  @override
  String get enhanceWithAi => 'AI ile Geliştir';

  @override
  String get generatingAiSummary => 'Profesyonel özet oluşturuluyor...';

  @override
  String get aiDiffOriginal => 'Orijinal Metin';

  @override
  String get aiDiffSuggested => 'AI Tarafından İyileştirilen';

  @override
  String get applySuggestion => 'Öneriyi Uygula';

  @override
  String get cancel => 'İptal';

  @override
  String get atsScoreLabel => 'ATS Uyum Puanı';

  @override
  String get exportPdf => 'PDF Dışa Aktar';

  @override
  String get offlineWarning =>
      'Şu anda çevrimdışısınız. Yapay zeka özellikleri internet bağlantısı gerektirir.';

  @override
  String get paywallTitle => 'AI CV Builder Pro\'ya Yükselt';

  @override
  String get heroBadge => '⚡ YAPAY ZEKA DESTEKLİ';

  @override
  String get heroTitle => 'İş Kazandıran Bir Özgeçmiş Oluşturun';

  @override
  String get heroSubtitle =>
      '6 ATS uyumlu şablon arasından seçim yapın, AI ile maddeleri geliştirin ve kasma olmadan basıma hazır PDF\'ler indirin.';

  @override
  String get yourResumes => 'Özgeçmişleriniz';

  @override
  String resumesSavedCount(Object count) {
    return '$count kayıtlı';
  }

  @override
  String get noResumesYet => 'Henüz bir özgeçmiş oluşturulmadı';

  @override
  String get createFirstResume => 'İlk Özgeçmişinizi Oluşturun';

  @override
  String get edit => 'Düzenle';

  @override
  String get downloadPdf => 'PDF İndir';

  @override
  String get view => 'Görüntüle';

  @override
  String get delete => 'Sil';

  @override
  String get headerStep => 'İletişim Bilgileri';

  @override
  String get summaryStep => 'Özet';

  @override
  String get experienceStep => 'Deneyim';

  @override
  String get educationStep => 'Eğitim';

  @override
  String get skillsStep => 'Yetenekler';

  @override
  String get projectsStep => 'Projeler';

  @override
  String get photoStep => 'Fotoğraf';

  @override
  String get previous => 'Önceki';

  @override
  String get nextStep => 'Sonraki Adım';

  @override
  String get viewTemplatesFinish => 'Şablonları Gör & Tamamla';

  @override
  String get personalInfo => 'Kişisel Bilgiler';

  @override
  String get cvTitleLabel => 'CV Adı / İsmi';

  @override
  String get cvTitleHint => 'Örn: Kıdemli Yazılım Mühendisi CV';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get professionalTitle => 'Profesyonel Unvan';

  @override
  String get email => 'E-posta Adresi';

  @override
  String get phone => 'Telefon Numarası';

  @override
  String get location => 'Şehir, Ülke';

  @override
  String get autoSavedLocally => 'Yerel olarak otomatik kaydedildi';

  @override
  String get summary => 'Profesyonel Özet';

  @override
  String get summaryHint =>
      'Kariyerinizdeki önemli noktaları ve başarıları özetleyin...';

  @override
  String get workExperience => 'İş Deneyimi';

  @override
  String get newExperience => 'Yeni Deneyim';

  @override
  String get jobTitle => 'İş Pozisyonu';

  @override
  String get jobTitleHint => 'Örn: Kıdemli Yazılım Mühendisi';

  @override
  String get company => 'Şirket / Kuruluş';

  @override
  String get companyHint => 'Örn: ABC Teknoloji';

  @override
  String get locationHint => 'Örn: İstanbul, Türkiye';

  @override
  String get startDate => 'Başlangıç Tarihi';

  @override
  String get endDate => 'Bitiş Tarihi';

  @override
  String get currentlyWorkHere => 'Halen burada çalışıyorum';

  @override
  String get bulletPointsLabel =>
      'Başarılar / Sorumluluklar (Her satıra bir madde)';

  @override
  String get bulletPointsHint =>
      'Örn: Yüksek performanslı Flutter uygulamaları geliştirdim.';

  @override
  String get addExperience => 'İş Deneyimi Ekle';

  @override
  String get education => 'Eğitim';

  @override
  String get newEducation => 'Yeni Eğitim';

  @override
  String get degree => 'Derece / Bölüm';

  @override
  String get degreeHint => 'Örn: Bilgisayar Mühendisliği Lisans';

  @override
  String get institution => 'Okul / Üniversite';

  @override
  String get institutionHint => 'Örn: İstanbul Teknik Üniversitesi';

  @override
  String get gpaOptional => 'GPA (Opsiyonel)';

  @override
  String get gpaHint => 'Örn: 3.5/4.0';

  @override
  String get addEducation => 'Eğitim Ekle';

  @override
  String get currentlyStudyHere => 'Halen eğitim görüyorum';

  @override
  String get skillsCompetencies => 'Yetenekler & Yetkinlikler';

  @override
  String get skillHint => 'Yetenek ekleyin (Örn: Flutter, Dart, Riverpod)...';

  @override
  String get addSkill => 'Ekle';

  @override
  String get skills => 'Yetenekler & Teknolojiler';

  @override
  String get projects => 'Projeler';

  @override
  String get addProject => 'Proje Ekle';

  @override
  String get newProject => 'Yeni Proje';

  @override
  String get noProjectsYet =>
      'Henüz proje eklenmedi.\n\'+\' butonuna basarak yeni bir proje ekleyebilirsiniz.';

  @override
  String get projectTitle => 'Proje Başlığı';

  @override
  String get projectTitleHint => 'Örn: AI CV Builder Mobil Uygulaması';

  @override
  String get projectUrl => 'Proje Linki / GitHub (Opsiyonel)';

  @override
  String get projectUrlHint => 'Örn: https://github.com/...';

  @override
  String get technologiesUsed => 'Kullanılan Teknolojiler (Virgülle ayırın)';

  @override
  String get technologiesHint => 'Örn: Flutter, Dart, Riverpod';

  @override
  String get projectDescription => 'Proje Açıklaması & Detayları';

  @override
  String get projectDescHint =>
      'Projede yaptıklarınızı ve başarılarınızı maddeler halinde yazabilirsiniz...';

  @override
  String get profilePhotoOptional => 'Profil Fotoğrafı (Opsiyonel)';

  @override
  String get photoDisclaimer =>
      'Fotoğraflı CV şablonları seçildiğinde bu fotoğraf kullanılacaktır.';

  @override
  String get changePhoto => 'Fotoğrafı Değiştir';

  @override
  String get uploadPhoto => 'Fotoğraf Yükle';

  @override
  String get removePhoto => 'Kaldır';

  @override
  String get selectDesign => 'Tasarım Seçin';

  @override
  String get standardizedTemplates =>
      'Standartlaştırılmış Global CV Şablonları';

  @override
  String get selectedDesign => 'Seçili Tasarım';

  @override
  String get saveAndPdf => 'PDF İndir & Kaydet';

  @override
  String get saveOnly => 'Sadece Kaydet';

  @override
  String get cvSavedDownloading => 'CV Kaydedildi, PDF indiriliyor...';

  @override
  String get cvSavedSuccess => 'CV Başarıyla Kaydedildi!';

  @override
  String get aiModalTitle => 'AI Madde İyileştirmesi';

  @override
  String get aiModalSub =>
      'Özgeçmişinize uygulamadan önce AI önerilerini inceleyin';

  @override
  String get original => 'ORİJİNAL';

  @override
  String get aiSuggestion => 'AI ÖNERİSİ';

  @override
  String get keepOriginal => 'Orijinali Koru';

  @override
  String get acceptAiSuggestion => 'AI Önerisini Kabul Et';

  @override
  String get language => 'Dil';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Türkçe';

  @override
  String get editYourResumes => 'Düzenle';

  @override
  String get done => 'Tamam';

  @override
  String get deleteResumeTitle => 'CV\'yi Sil';

  @override
  String get deleteResumeMessage =>
      'Bu CV\'yi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get confirmDelete => 'Sil';

  @override
  String get proRequired => 'Pro\'ya Yükselt';

  @override
  String get proRequiredMessage =>
      'Ücretsiz kullanıcılar en fazla 3 CV kaydedebilir. Sınırsız CV kaydetmek ve premium şablonların kilidini açmak için AI CV Builder Pro\'ya yükseltin.';

  @override
  String get upgradeToPro => 'Pro\'ya Yükselt';

  @override
  String get maybeLater => 'Daha Sonra';

  @override
  String get duplicate => 'Çoğalt';

  @override
  String get resumeDuplicated => 'CV başarıyla çoğaltıldı!';

  @override
  String get copySuffix => 'Kopyası';
}
