
# Video Watermark

Simple Flutter package to add image as overlay in the video along with video trim option.




## Features

- Add logo in video
- Alter logo in various parameters 
- Simple way to trim video
- Add image from various source
- Cross platform


## Usage

Just initiate `VideoWatermark` instance


```dart
VideoWatermark videoWatermark = VideoWatermark(
    sourceVideoPath: videoPath,
    watermark: Watermark(image: WatermarkSource.file(imagepath)),
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
    image: WatermarkSource.file(imagepath),
    watermarkAlignment: WatermarkAlignment.topCenter,
    watermarkSize: WatermarkSize(150,200),
    opacity: 0.8   //0.0 - 1.0
);
```

Yau can include watermark images from two sources `File`, `Asset` and `Network`.

```dart
WatermarkSource.file(imagepath)
```

```dart
WatermarkSource.asset(assetpath)
```

```dart
WatermarkSource.network(imageUrl)
```