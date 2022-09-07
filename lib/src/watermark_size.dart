class WatermarkSize {
  final double width;
  final double height;

  const WatermarkSize(this.width, this.height);

  factory WatermarkSize.symmertric(double width) {
    return WatermarkSize(width, -1);
  }

  @override
  String toString() {
    return 'scale=$width:$height, ';
  }
}
