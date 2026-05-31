abstract class EndPoints {
  static const String baseUrl = 'http://127.0.0.1:8080/';

  static const String getInfo = 'api/info';
  static const String downloadAudio = 'api/download/audio';
  static const String downloadVideo = 'api/download/video';
  static const String downloadSubtitle = 'api/download/subtitle';
  static const String getTaskStatus = 'api/tasks/{taskId}';
  static const String cancelTask = 'api/tasks/{taskId}/cancel';
}
