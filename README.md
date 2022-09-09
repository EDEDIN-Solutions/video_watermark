
# Video Watermark

Simple and fast Flutter package to add images as overlay in the video.




## Features

- Add logo in video
- Alter logo in many parameters 
- Simple video trim
- Cross platform


## Usage

Just initiate `VideoWatermark` instance


```dart
VideoWatermark videoWatermark = VideoWatermark(
    sourceVideoPath: videoPath,
    watermark: Watermark( imagePath: imagePath),
    onSave: (path){
        // Get the output file path
    },
);
```

To generate video with watermark.

```dart
videoWatermark.generateVideo();
```

Also you can trim video in simple way.

```dart
VideoWatermark videoWatermark = VideoWatermark(
    sourceVideoPath: videoPath,
    videoTrim: VideoTrim(start: startTime, end: endTime)
    onSave: (path){
        // Get the output file path
    },
);
```

You can decide the watermark location, size and opacity in video with `WatermarkAlignment` & `WatermarkSize`.

```dart
Watermark watermark = Watermark(
    imagePath: imagePath!,
    watermarkAlignment: WatermarkAlignment.topCenter,
    watermarkSize: WatermarkSize(150,200),
    opacity: 0.8   //0.0 - 1.0
);
```