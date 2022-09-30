import 'dart:io';
import 'package:flutter/services.dart'
    show ByteData, NetworkAssetBundle, rootBundle;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

enum WatermarkSourceEnum { file, asset, network }

/// Add images from various sources in video as overlay using [WatermarkSource].
class WatermarkSource {
  String _path = '';
  WatermarkSourceEnum? _source;

  /// To add image from local storage with file's path
  WatermarkSource.file(String path) {
    _path = path;
    _source = WatermarkSourceEnum.file;
  }

  /// To add image from assets with asset's path.
  WatermarkSource.asset(String path) {
    _path = path;
    _source = WatermarkSourceEnum.asset;
  }

  /// To add image from network with image url.
  WatermarkSource.network(String url) {
    _path = url;
    _source = WatermarkSourceEnum.network;
  }

  Future<String> toCommand() async {
    if (_path.isNotEmpty) {
      try {
        if (_source != WatermarkSourceEnum.file) {
          ByteData byteData;
          String appDocDir;
          File file;
          byteData = _source == WatermarkSourceEnum.asset
              ? await rootBundle.load(_path)
              : await NetworkAssetBundle(Uri.parse(_path)).load("");
          appDocDir = await getApplicationDocumentsDirectory()
              .then((value) => value.path);
          file = await File('$appDocDir/$_path').create(recursive: true);
          _path = await file
              .writeAsBytes(byteData.buffer
                  .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes))
              .then((value) => value.path);
        }
      } catch (e) {
        throw ("Unable to fetch image from the mentioned source.");
      }
      return _path;
    } else {
      throw ("Add Image source using WatermarkSource");
    }
  }
}
