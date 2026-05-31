# خطة تشغيل تطبيق Grabber على نظام macOS

توضح هذه الوثيقة الخطوات والحلول البرمجية والإعدادات اللازمة لتشغيل تطبيق **Grabber** بالكامل وبشكل صحيح على بيئة **macOS**، مع دعم تشغيل الـ Backend المدمج.

---

## 1. الملف التنفيذي للـ Backend (ملف السيرفر)
### المشكلة:
الكود الحالي في ملف [backend_service.dart](file:///Users/mohamedosama/Documents/Flutter/FlutterProjects/Grabber/lib/core/utils/backend_service.dart) يبحث عن ملف تنفيذي ثابت باسم `server.exe` لتشغيله:
```dart
final serverExe = File(p.join(backendDir.path, 'server.exe'));
```
الملفات بامتداد `.exe` مخصصة لويندوز فقط ولا يمكن تشغيلها على نظام macOS.

### الحل:
1. توفير نسخة Unix executable من الـ Backend متوافقة ومبنية لنظام macOS (سواء لمعالجات Intel أو Apple Silicon مثل M1/M2/M3) وتسميتها `server` وتضمينها داخل أرشيف `assets/backend.zip` بجوار `server.exe`.
2. تحديث الكود في Flutter لكي يختار اسم الملف التنفيذي ديناميكيًا بناءً على نظام التشغيل الحالي:
```dart
final binaryName = Platform.isWindows ? 'server.exe' : 'server';
final serverExe = File(p.join(backendDir.path, binaryName));
```

---

## 2. صلاحيات التشغيل للملف التنفيذي (Execution Permissions)
### المشكلة:
عند فك ضغط ملفات الـ zip على أنظمة Unix (مثل macOS و Linux)، لا تحتفظ الملفات التنفيذية بصلاحية التشغيل تلقائيًا. وإذا حاولت تشغيلها مباشرة، سيعطيك نظام التشغيل خطأ: `Permission denied`.

### الحل:
بعد فك ضغط الملفات وقبل البدء في تشغيل السيرفر، يجب إعطاء صلاحية التشغيل للملف التنفيذي ولملفات `ffmpeg` و `ffprobe` (إذا كانت مدمجة في مجلد `bin`) باستخدام الأمر `chmod +x` برمجياً:
```dart
if (Platform.isMacOS || Platform.isLinux) {
  await Process.run('chmod', ['+x', serverExe.path]);

  final ffmpegFile = File(p.join(backendDir.path, 'bin', 'ffmpeg'));
  final ffprobeFile = File(p.join(backendDir.path, 'bin', 'ffprobe'));
  if (await ffmpegFile.exists()) {
    await Process.run('chmod', ['+x', ffmpegFile.path]);
  }
  if (await ffprobeFile.exists()) {
    await Process.run('chmod', ['+x', ffprobeFile.path]);
  }
}
```

---

## 3. إيقاف العمليات القديمة على macOS (Process Management)
### المشكلة:
دالة إيقاف السيرفر القديم `_killExistingProcesses` مهيأة فقط لنظام ويندوز باستخدام `taskkill`:
```dart
if (Platform.isWindows) {
  await Process.run('taskkill', ['/F', '/IM', 'server.exe']);
}
```
على macOS، إذا أغلقت التطبيق وأعدت تشغيله، قد يظل السيرفر القديم يعمل في الخلفية ويحجز الـ Port، مما يمنع السيرفر الجديد من البدء.

### الحل:
إضافة كود مخصص لنظام macOS لإنهاء العمليات القديمة (باستخدام `pkill` مع خيار `-x` للمطابقة الدقيقة للاسم فقط وتجنب إنهاء عمليات التطبيق نفسه):
```dart
if (Platform.isMacOS) {
  try {
    await Process.run('pkill', ['-x', 'server']);
    if (kDebugMode) print("💀 Killed old server instances on macOS.");
  } catch (e) {
    if (kDebugMode) print("❌ Error killing server on macOS: $e");
  }
}
```

---

## 4. صلاحيات الحماية والشبكة في macOS (App Sandbox & Entitlements)
### المشكلة:
تطبيقات macOS في Flutter تعمل بشكل افتراضي داخل بيئة معزولة (App Sandbox). هذه البيئة **تمنع تشغيل أي ملف تنفيذي خارجي (Subprocess)** تم فك ضغطه ديناميكيًا في مسار خارجي خارج حزمة التطبيق (مثل مجلد Application Support)، وسيظهر خطأ:
`ProcessException: Operation not permitted`.

### الحل:
للسماح للبرنامج بتشغيل ملف الـ Backend التنفيذي (`server`) بشكل صحيح، **يجب إيقاف تفعيل بيئة الـ App Sandbox** بجعل قيمتها `false` في ملفات الـ Entitlements.

#### أ. ملف [DebugProfile.entitlements](file:///Users/mohamedosama/Documents/Flutter/FlutterProjects/Grabber/macos/Runner/DebugProfile.entitlements):
```xml
<key>com.apple.security.app-sandbox</key>
<false/>
<key>com.apple.security.network.client</key>
<true/>
<!-- للسماح للمستخدم باختيار مجلد لحفظ الملفات وقراءتها أثناء التطوير -->
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
```

#### ب. ملف [Release.entitlements](file:///Users/mohamedosama/Documents/Flutter/FlutterProjects/Grabber/macos/Runner/Release.entitlements):
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<false/>
	<!-- للسماح للتطبيق بالاتصال بالسيرفر المحلي والإنترنت لطلب البيانات -->
	<key>com.apple.security.network.client</key>
	<true/>
	<!-- للسماح للسيرفر المحلي بالعمل واستقبال اتصالات من التطبيق -->
	<key>com.apple.security.network.server</key>
	<true/>
	<!-- للسماح للمستخدم باختيار مجلد لحفظ الفيديوهات والملفات المحملة وقراءتها -->
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
</dict>
</plist>
```
