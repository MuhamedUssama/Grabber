// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get paste => 'تم لصق الرابط';

  @override
  String get url => 'ضع الرابط هنا';

  @override
  String get appName => 'Grabber';

  @override
  String get browse => 'تصفح';

  @override
  String get getInfo => 'تفاصيل الفيديو';

  @override
  String get folderSelected => 'تم تحديد المجلد بنجاح';

  @override
  String get noFolderSelected => 'لم يتم تحديد أي مجلد';

  @override
  String get somethingWentWorng => 'حدث خطأ ما';

  @override
  String get downloadAudio => 'تحميل المقطع الصوتي';

  @override
  String get downloadVideo => 'تحميل الفيديو';

  @override
  String get downloadVideoWithoutAudio => 'تحميل الفيديو بدون صوت';
}
