abstract class Formatter {
  static String formatBytes(num? bytes, {int decimals = 1}) {
    if (bytes == null || bytes <= 0) return "0 B";

    if (bytes < 1024) return "${bytes.toInt()} B";
    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(decimals)} KB";
    }
    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(decimals)} MB";
    }
    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(decimals)} GB";
  }

  static String formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return "--:--";

    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
