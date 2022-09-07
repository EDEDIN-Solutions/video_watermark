class VideoTrim {
  final Duration start;
  final Duration end;
  Duration get duration => end - start;
  VideoTrim({required this.start, required this.end})
      : assert(end < start,
            "Start time should be less than the end time to trim the video");
}
