import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'output_format.dart';
import 'trim_video.dart';
import 'watermark.dart';

class VideoWatermark {
  /// Source video to be added with watermark or trimmed.
  final String sourceVideoPath;

  ///Name of the ouput video file without video format.
  ///
  ///Default filename: videowatermark_(current time in millisecond)
  final String? videoFileName;

  /// The characteristics of watermark image that to be added in the video.
  final Watermark? watermark;

  /// Video format for the output (converted) video
  ///
  /// Available formats
  /// .mp4,
  /// .mkv,
  /// .mov,
  /// .flv,
  /// .avi,
  /// .wmv,
  /// .gif.
  /// Deafult format: `.mp4`
  final OutputFormat? outputFormat;

  /// Path where the output video to be saved.
  ///
  /// The default path will be Application Documents Directory
  final String? savePath;

  /// For specifying the start and end time of the video to be trimmed.
  final VideoTrim? videoTrim;

  /// The parameters of watermark and trim with the save function.
  ///
  /// Required paramater [sourceVideoPath] path of the video to be converted.
  const VideoWatermark({
    required this.sourceVideoPath,
    this.videoFileName,
    this.watermark,
    this.outputFormat = OutputFormat.mp4,
    this.savePath,
    this.videoTrim,
  });

  /// To save the generated video with the parameters
  Future<void> saveVideo({
    /// Callback function returns generated file with path as String.
    ValueSetter<String?>? onSave,
  }) async {
    String command = '-i $sourceVideoPath ';
    String? outputPath = '';
    if (videoTrim != null) {
      command =
          ' -ss ${videoTrim!.start} $command-t ${videoTrim!.duration} -avoid_negative_ts make_zero ';
    }

    outputPath = savePath ??
        await getApplicationDocumentsDirectory()
            .then((value) => value.path + '/');

    String? outputVideo =
        '$outputPath${videoFileName ?? 'videowatermark_${DateTime.now().millisecond}'}.${outputFormat.toString().split(".").last}';

    if (watermark != null) {
      command += '$watermark ';
    }

    command += outputVideo;

    await FFmpegKit.executeAsync(command, (session) async {
      debugPrint(await session.getOutput());

      ReturnCode? returnCode = await session.getReturnCode();

      SessionState sessionState = await session.getState();

      debugPrint("Video conversion $sessionState");

      if (ReturnCode.isSuccess(returnCode)) {
        debugPrint("Video saved in $outputVideo");
        onSave?.call(outputVideo);
      } else {
        debugPrint("Video save failed");
        onSave?.call(null);
      }
    });
  }
}
