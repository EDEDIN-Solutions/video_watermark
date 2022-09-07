import 'package:video_watermark/src/watermark_size.dart';

import 'watermark_alignment.dart';

class Watermark {
  final String imagePath;

  WatermarkSize? watermarkSize;

  WatermarkAlignment? watermarkAlignment;

  double opacity;

  Watermark({
    required this.imagePath,
    this.watermarkSize,
    this.opacity = 1.0,
    this.watermarkAlignment,
  });

  @override
  String toString() {
    return '-i $imagePath -filter_complex "[1:v]${watermarkSize ?? WatermarkSize.symmertric(100)}format=argb,geq=r=\'r(X,Y)\':a=\'$opacity*alpha(X,Y)\'[i];[0:v][i]overlay=${watermarkAlignment ?? WatermarkAlignment.center}[o]" -map "[o]" -map "0:a"';
  }
}
