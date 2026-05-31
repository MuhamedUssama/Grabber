class TaskStatus {
  final String taskId;
  final String title;
  final String url;
  // 'pending', 'processing', 'completed', 'failed', 'cancelled'
  final String status;
  final double progress;
  final String? resultPath;
  final String? error;
  final int? totalSize;
  final double? speed;
  final int? eta;
  final String? thumbnailUrl;

  const TaskStatus({
    required this.taskId,
    required this.title,
    required this.url,
    required this.status,
    required this.progress,
    this.resultPath,
    this.error,
    this.totalSize,
    this.speed,
    this.eta,
    this.thumbnailUrl,
  });

  TaskStatus copyWith({
    String? taskId,
    String? title,
    String? url,
    String? status,
    double? progress,
    String? resultPath,
    String? error,
    int? totalSize,
    double? speed,
    int? eta,
    String? thumbnailUrl,
  }) {
    return TaskStatus(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      url: url ?? this.url,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      resultPath: resultPath ?? this.resultPath,
      error: error ?? this.error,
      totalSize: totalSize ?? this.totalSize,
      speed: speed ?? this.speed,
      eta: eta ?? this.eta,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
