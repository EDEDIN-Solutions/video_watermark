import 'watermark_size.dart';
import 'watermark_alignment.dart';

class Watermark {
  /// Path of the image added in the video as watermark.
  final String imagePath;

  /// Height and width of the watermark image,
  WatermarkSize? watermarkSize;

  /// Position of the watermark image in the video
  WatermarkAlignment? watermarkAlignment;

  /// Opacity of the watermark image varies between 0.0 - 1.0.
  ///
  /// Default value: `1.0`.
  double opacity;

  /// Characteristics of the watermark image.
  ///
  /// Required parameter [imagePath].
  Watermark({
    required this.imagePath,
    this.watermarkSize,
    this.opacity = 1.0,
    this.watermarkAlignment,
  });

  String toCommand() {
    return '-i $imagePath -filter_complex "[1:v]${(watermarkSize ?? WatermarkSize.symmertric(100)).toCommand()}format=argb,geq=r=\'r(X,Y)\':a=\'$opacity*alpha(X,Y)\'[i];[0:v][i]overlay=${(watermarkAlignment ?? WatermarkAlignment.center).toCommand()}[o]" -map "[o]" -map "0:a"';
  }
}
