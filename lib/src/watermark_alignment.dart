import 'package:flutter/material.dart';

class WatermarkAlignment {
  final int w;
  final int h;
  final int i;
  EdgeInsets padding = const EdgeInsets.all(0);
  WatermarkAlignment._(this.w, this.h, this.i);

  static WatermarkAlignment center = WatermarkAlignment._(2, 2, 0);

  static WatermarkAlignment topCenter = WatermarkAlignment._(2, 0, 1);

  static WatermarkAlignment bottomCenter = WatermarkAlignment._(2, 1, 2);

  static WatermarkAlignment leftCenter = WatermarkAlignment._(0, 2, 3);

  static WatermarkAlignment rightCenter = WatermarkAlignment._(1, 2, 4);

  static WatermarkAlignment topRight = WatermarkAlignment._(1, 0, 5);

  static WatermarkAlignment topLeft = WatermarkAlignment._(0, 0, 6);

  static WatermarkAlignment bottomLeft = WatermarkAlignment._(0, 1, 7);

  static WatermarkAlignment botomRight = WatermarkAlignment._(1, 1, 8);

  String toText() {
    return {
      0: "Center",
      1: "Top Center",
      2: "Bottom Center",
      3: "Left Center",
      4: "Right Center",
      5: "Top Right",
      6: "Top Left",
      7: "Bottom Left",
      8: "Botom Right",
    }[i]!;
  }

  @override
  String toString() {
    String w = '0';
    String h = '0';

    if (this.w != 0) {
      w = '((W-w)/${this.w})';
    }
    if (this.h != 0) {
      h = '((H-h)/${this.h})';
    }

    return '$w+${padding.left}-${padding.right}:$h+${padding.top}-${padding.bottom}';
  }
}
