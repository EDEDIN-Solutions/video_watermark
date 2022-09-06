import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_watermark/video_watermark.dart';

void main() {
  runApp(const MyApp());
}

double width = 0;
double height = 0;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      width = constraints.maxWidth;
      height = constraints.maxHeight;
      return MaterialApp(
        title: 'Video Watermark Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<WatermarkAlignment> alignmentList = [
  WatermarkAlignment.center,
  WatermarkAlignment.topCenter,
  WatermarkAlignment.bottomCenter,
  WatermarkAlignment.leftCenter,
  WatermarkAlignment.rightCenter,
  WatermarkAlignment.topLeft,
  WatermarkAlignment.topRight,
  WatermarkAlignment.bottomLeft,
  WatermarkAlignment.botomRight,
];

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController videoPlayerController;

  late final ScrollController scrollController;

  WatermarkAlignment? watermarkAlignment;

  double opacity = 1.0;

  late final List<TextEditingController> paddingControllers;

  String? videoFile;
  String? imageFile;
  bool loading = false;

  @override
  void initState() {
    scrollController = ScrollController();
    paddingControllers = List.generate(4, (index) => TextEditingController());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    videoPlayerController.dispose();
    for (var item in paddingControllers) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> options = [
      {
        "title": "Watermark in video",
        "ontap": () {
          generateVideo();
        },
      },
      {
        "title": "Watermark Alignment",
        "ontap": () {
          generateVideo();
        },
      },
      {
        "title": "Watermark padding",
        "ontap": () {
          for (var element in paddingControllers) {
            if (element.text.isEmpty) {
              element.text = "0";
            }
          }

          if (watermarkAlignment != null) {
            watermarkAlignment!.padding = EdgeInsets.only(
              left: int.parse(paddingControllers[0].text).toDouble(),
              right: int.parse(paddingControllers[1].text).toDouble(),
              top: int.parse(paddingControllers[2].text).toDouble(),
              bottom: int.parse(paddingControllers[3].text).toDouble(),
            );
          }

          generateVideo();
        },
      },
      {
        "title": "Watermark opacity",
      },
      {
        "title": "Trim",
      },
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Video Watermark Demo"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : videoFile == null || imageFile == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          FilePicker.platform.pickFiles().then((value) async {
                            setState(() {
                              loading = true;
                            });
                            if (value?.paths[0] != null) {
                              videoPlayerController =
                                  VideoPlayerController.file(
                                      File(value!.paths[0]!));
                              await videoPlayerController.initialize();
                              setState(() {
                                videoFile = value.paths[0];
                                loading = false;
                              });
                            }
                          });
                        },
                        child: const Text("Select Video"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ImagePicker()
                              .pickImage(source: ImageSource.gallery)
                              .then((value) async {
                            if (value?.path != null) {
                              setState(() {
                                imageFile = value!.path;
                              });
                            }
                          });
                        },
                        child: const Text("Select Watermark"),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: VideoPlayer(videoPlayerController),
                    ),
                    SizedBox(
                      height: height * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              scrollController.animateTo(
                                scrollController.position.pixels - width,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          IconButton(
                            onPressed: () {
                              scrollController.animateTo(
                                scrollController.position.pixels + width,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.ease,
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        itemCount: options.length,
                        itemBuilder: ((context, index) {
                          return SizedBox(
                            width: width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (index == 1 || index == 2)
                                  DropdownButton<WatermarkAlignment>(
                                    value: watermarkAlignment,
                                    hint: const Text("Select Alignment"),
                                    items: List.generate(
                                      alignmentList.length,
                                      (index) => DropdownMenuItem(
                                        child: Text(
                                          alignmentList[index].toText(),
                                        ),
                                        value: alignmentList[index],
                                      ),
                                    ),
                                    onChanged: (alignment) {
                                      setState(() {
                                        watermarkAlignment = alignment;
                                      });
                                    },
                                  ),
                                if (index == 2)
                                  SizedBox(
                                    // height: height * 0.05,
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        for (var i = 0;
                                            i < paddingControllers.length;
                                            i++)
                                          SizedBox(
                                            width: width * 0.2,
                                            child: TextField(
                                              controller: paddingControllers[i],
                                              decoration: InputDecoration(
                                                label: Text(i == 0
                                                    ? "Left"
                                                    : i == 1
                                                        ? "Right"
                                                        : i == 2
                                                            ? "Top"
                                                            : "Bottom"),
                                                counterText: "",
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 3,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ElevatedButton(
                                  onPressed: options[index]["ontap"],
                                  child: Text(
                                    options[index]["title"],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
    );
  }

  Future<void> generateVideo() async {
    setState(() {
      loading = true;
    });
    VideoWatermark videoWatermark = VideoWatermark(
      sourceVideoPath: videoFile!,
      videoFileName: "Output${DateTime.now().millisecond}",
      watermark: Watermark(
        imagePath: imageFile!,
        watermarkAlignment: watermarkAlignment,
        opacity: opacity,
      ),
    );

    await videoWatermark.saveVideo(
      onSave: (value) {
        if (value != null) {
          videoPlayerController = VideoPlayerController.file(File(value))
            ..initialize().then((value) {
              setState(() {
                loading = false;
              });
            });
        } else {
          setState(() {
            loading = false;
          });
        }
      },
    );
  }
}
