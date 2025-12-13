class TaskStatus {
  final String taskId;
  // 'pending', 'processing', 'completed', 'failed', 'cancelled'
  final String status;
  final double progress;
  final String? resultPath;
  final String? error;

  TaskStatus({
    required this.taskId,
    required this.status,
    required this.progress,
    this.resultPath,
    this.error,
  });

  TaskStatus copyWith({
    String? taskId,
    String? status,
    double? progress,
    String? resultPath,
    String? error,
  }) {
    return TaskStatus(
      taskId: taskId ?? this.taskId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      resultPath: resultPath ?? this.resultPath,
      error: error ?? this.error,
    );
  }
}
