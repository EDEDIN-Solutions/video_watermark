import 'package:flutter/material.dart' show EdgeInsets;

/// Position of the watermark image in the video.
class WatermarkAlignment {
  final int w;
  final int h;
  final int i;

  /// Offset from the all four sides with alignment specified.
  ///
  /// Default value is `EdgeInsets.all(0)`
  ///
  /// Sample usage:
  ///
  /// ```dart
  /// WatermarkAlignment.center.padding = const EdgeInsets.all(10);
  /// ```
  EdgeInsets padding = const EdgeInsets.all(0);

  WatermarkAlignment._(this.w, this.h, this.i);

  /// Aligns the watermark image in the center of the video.
  static WatermarkAlignment center = WatermarkAlignment._(2, 2, 0);

  /// Aligns the watermark image in the top center of the video.
  static WatermarkAlignment topCenter = WatermarkAlignment._(2, 0, 1);

  /// Aligns the watermark image in the bottom center of the video.
  static WatermarkAlignment bottomCenter = WatermarkAlignment._(2, 1, 2);

  /// Aligns the watermark image in the left center of the video.
  static WatermarkAlignment leftCenter = WatermarkAlignment._(0, 2, 3);

  /// Aligns the watermark image in the right center of the video.
  static WatermarkAlignment rightCenter = WatermarkAlignment._(1, 2, 4);

  /// Aligns the watermark image in the top right corner of the video.
  static WatermarkAlignment topRight = WatermarkAlignment._(1, 0, 5);

  /// Aligns the watermark image in the top left corner of the video.
  static WatermarkAlignment topLeft = WatermarkAlignment._(0, 0, 6);

  /// Aligns the watermark image in the bottom left corner of the video.
  static WatermarkAlignment bottomLeft = WatermarkAlignment._(0, 1, 7);

  /// Aligns the watermark image in the bottom right corner of the video.
  static WatermarkAlignment botomRight = WatermarkAlignment._(1, 1, 8);

  @override
  String toString() {
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

  String toCommand() {
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
