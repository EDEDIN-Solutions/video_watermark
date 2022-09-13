import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class WatermarkSource {
  String? _path;

  WatermarkSource.file(String path) {
    _path = path;
  }

  WatermarkSource.asset(String path) {
    ByteData byteData;
    String appDocDir;
    File file;
    rootBundle.load(path).then((value) {
      byteData = value;
      getApplicationDocumentsDirectory().then((value) {
        appDocDir = value.path;
        File('$appDocDir/$path').create(recursive: true).then((value) {
          file = value;
          file
              .writeAsBytes(byteData.buffer
                  .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))
              .then(
            (value) {
              _path = file.path;
            },
          );
        });
      });
    });
  }

  @override
  String toString() {
    return _path ?? "null";
  }
}
