import 'package:flutter/cupertino.dart';

class WatermarkAlignment {
  final int w;
  final int h;
  EdgeInsets padding = const EdgeInsets.all(0);
  WatermarkAlignment(this.w, this.h);

  static WatermarkAlignment center = WatermarkAlignment(2, 2);

  static WatermarkAlignment topCenter = WatermarkAlignment(2, 0);

  static WatermarkAlignment bottomCenter = WatermarkAlignment(2, 1);

  static WatermarkAlignment leftCenter = WatermarkAlignment(0, 2);

  static WatermarkAlignment rightCenter = WatermarkAlignment(1, 2);

  static WatermarkAlignment bottomLeft = WatermarkAlignment(0, 1);

  static WatermarkAlignment botomRight = WatermarkAlignment(1, 1);

  static WatermarkAlignment topRight = WatermarkAlignment(1, 0);

  static WatermarkAlignment topLeft = WatermarkAlignment(0, 0);

  @override
  String toString() {
    String w = '0';
    String h = '0';

    if (this.w != 0) {
      w = '((W-w)/${this.w})+${padding.left}-${padding.right}';
    }
    if (this.h != 0) {
      h = '((H-h)/${this.h})+${padding.top}-${padding.bottom}';
    }

    return "$w:$h";
  }
}
