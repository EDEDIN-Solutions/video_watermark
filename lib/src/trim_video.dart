class VideoTrim {
  /// Duration where the trim part starts.
  ///
  /// Usage:
  ///
  /// When Start time is 30 seconds then
  /// ```dart
  /// Duration(seconds:20)
  /// ```
  final Duration start;

  /// Duration where the trim part ends.
  ///
  /// Usage:
  ///
  /// When End time is 1 minute 2 seconds then
  /// ```dart
  /// Duration(minutes:1,seconds:20)
  /// ```
  final Duration end;

  Duration get duration => end - start;

  /// To specify the part of the video to be trimmed.
  ///
  /// Required [start] and [end] time to identify the trim part.
  ///
  /// Start time should be less than the end time to trim the video
  VideoTrim({required this.start, required this.end})
      : assert(end > start,
            "Start time - $start should be less than the end time - $end to trim the video ${end < start}");
}
