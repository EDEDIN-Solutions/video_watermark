import 'dart:io';

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

  /// Callback trggred when the video convertion completed.
  ///
  /// Return value on successful conversion will be `path of converted video` else will be `null`.
  final ValueSetter<String?>? onSave;

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
    this.onSave,
  });

  /// To save the generated video with the parameters
  Future<void> saveVideo() async {
    String? outputPath = savePath ??
        await getApplicationDocumentsDirectory()
            .then((value) => value.path + '/');

    int time = DateTime.now().millisecond;
    String trimmedVideo =
        '$outputPath${'trimmed_$time'}.${outputFormat.toString().split(".").last}';

    String? outputVideo =
        '$outputPath${videoFileName ?? 'videowatermark_$time'}.${outputFormat.toString().split(".").last}';
    if (videoTrim != null) {
      await _trimVideo(trimmedVideo, (tempVideoSave) {
        if (tempVideoSave) {
          if (watermark != null) {
            _addWatermark(trimmedVideo, outputVideo, (outputVideoSave) {
              if (outputVideoSave) {
                File(trimmedVideo).delete();
                onSave?.call(outputVideo);
              }
            });
          } else {
            onSave?.call(trimmedVideo);
          }
        }
      });
    } else {
      _addWatermark(sourceVideoPath, outputVideo, (outputVideoSave) {
        if (outputVideoSave) {
          onSave?.call(outputVideo);
        }
      });
    }
  }

  Future<void> _addWatermark(
    String sourceVideo,
    String outputVideo,
    ValueSetter<bool> onDone,
  ) async {
    String command = '-i $sourceVideo ${watermark!.toCommand()} $outputVideo';
    await _runFFmpegCommand(command, onDone);
  }

  Future<void> _trimVideo(
    String outputVideo,
    ValueSetter<bool> onDone,
  ) async {
    String command =
        ' -ss ${videoTrim!.start} -i $sourceVideoPath -t ${videoTrim!.duration} -avoid_negative_ts make_zero $outputVideo';

    await _runFFmpegCommand(command, onDone);
  }

  Future<void> _runFFmpegCommand(
      String command, ValueSetter<bool> onDone) async {
    await FFmpegKit.executeAsync(command, (session) async {
      ReturnCode? returnCode = await session.getReturnCode();

      SessionState sessionState = await session.getState();

      debugPrint("Video conversion $sessionState");

      if (ReturnCode.isSuccess(returnCode)) {
        onDone.call(true);
      } else {
        debugPrint("Video save failed");
        onSave?.call(null);
        onDone.call(false);
      }
    }, (log) {
      print("Log ---- ${log.getMessage()}");
    });
  }
}
