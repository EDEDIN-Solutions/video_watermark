import 'watermark_alignment.dart';

class Watermark {
  final String imagePath;
  double width;
  double height;
  bool lockAspectRatio;
  WatermarkAlignment? watermarkAlignment;
  double opacity;
  Watermark({
    required this.imagePath,
    this.height = 0,
    this.width = 100,
    this.opacity = 1.0,
    this.lockAspectRatio = true,
    this.watermarkAlignment,
  });

  @override
  String toString() {
    String watermark = '';
    watermark += '-i $imagePath -filter_complex "[1:v]';
    if (lockAspectRatio) {
      if (height != 0) {
        watermark += 'scale=-1:$height,';
      } else if (width != 0) {
        watermark += 'scale=$width:-1,';
      }
    } else {
      watermark += 'scale=$width:$height,';
    }

    watermark +=
        'format=argb,geq=r=\'r(X,Y)\':a=\'$opacity*alpha(X,Y)\'[i];[0:v][i]overlay=${watermarkAlignment ?? WatermarkAlignment.center}[o]" -map "[o]" -map "0:a"';
    return watermark;
  }
}
