class TrimVideo {
  final Duration start;
  final Duration end;
  Duration get duration => end - start;
  TrimVideo({required this.start, required this.end});
}
