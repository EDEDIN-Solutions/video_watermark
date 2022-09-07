import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:flutter/cupertino.dart';
import 'output_format.dart';
import 'trim_video.dart';
import 'watermark.dart';
import 'package:path_provider/path_provider.dart';

class VideoWatermark {
  final String sourceVideoPath;
  final String? videoFileName;
  final Watermark? watermark;
  final OutputFormat? outputFormat;
  final String? savePath;
  final TrimVideo? trimVideo;

  const VideoWatermark({
    required this.sourceVideoPath,
    this.videoFileName,
    this.watermark,
    this.outputFormat = OutputFormat.mp4,
    this.savePath,
    this.trimVideo,
  });
  Future<void> saveVideo({required ValueSetter<String?> onSave}) async {
    String command = '';
    String? outputPath = '';
    if (trimVideo != null) {
      command +=
          ' -ss ${trimVideo!.start} -i "$sourceVideoPath" -t ${trimVideo!.duration} -avoid_negative_ts make_zero ';
    } else {
      command += '-i $sourceVideoPath ';
    }

    outputPath = savePath ??
        await getApplicationDocumentsDirectory()
            .then((value) => value.path + '/');

    String? outputVideo =
        '$outputPath${videoFileName ?? DateTime.now().millisecond}.${outputFormat.toString().split(".").last}';

    if (watermark != null) {
      command += '$watermark ';
    }

    command += outputVideo;

    print(command);

    await FFmpegKit.executeAsync(command, (session) async {
      debugPrint(await session.getOutput());

      ReturnCode? returnCode = await session.getReturnCode();

      SessionState sessionState = await session.getState();

      debugPrint("Video conversion $sessionState");

      if (ReturnCode.isSuccess(returnCode)) {
        debugPrint("Video saved in $outputVideo");
        onSave.call(outputVideo);
      } else {
        debugPrint("Video save failed");
        onSave.call(null);
      }
    });
  }
}
