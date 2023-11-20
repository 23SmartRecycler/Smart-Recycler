import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


enum Options { none, imagev8, frame, tesseract, vision }

late List<CameraDescription> cameras;

class Detection extends StatefulWidget {
  const Detection({super.key});

  @override
  State<Detection> createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return MyApp(id:0);
  }
}


class MyApp extends StatefulWidget {
  final int id;
  const MyApp({Key? key,required this.id}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterVision vision;
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeTesseractModel();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task(option),
      floatingActionButton: SpeedDial(
        //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.black12, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
        Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        buttonSize: const Size(56.0, 56.0),
        children: [
          SpeedDialChild(
            //speed dial child
            child: const Icon(Icons.recycling),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: '쓰레기 분류',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.frame;
              });
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: '오염 인식',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                option = Options.frame;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget task(Options option) {
    if (option == Options.frame||widget.id==1) {
      return YoloClassify(vision: vision);
    }
    if (option == Options.imagev8||widget.id==0) {
      return YoloPollution(vision: vision);
    }
    if (option == Options.tesseract) {
      return TesseractImage(vision: vision);
    }
    return const Center(child: Text("Choose Task"));
  }
}

class YoloClassify extends StatefulWidget {
  final FlutterVision vision;
  const YoloClassify({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloClassify> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloClassify> {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  width: 5, color: Colors.white, style: BorderStyle.solid),
            ),
            child: isDetecting
                ? IconButton(
              onPressed: () async {
                stopDetection();
              },
              icon: const Icon(
                Icons.stop,
                color: Colors.red,
              ),
              iconSize: 50,
            )
                : IconButton(
              onPressed: () async {
                await startDetection();
              },
              icon: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
              iconSize: 50,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/label_class.txt',
        modelPath: 'assets/class_detection_model.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);
    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      print("${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%");
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}


class YoloPollution extends StatefulWidget {
  final FlutterVision vision;
  const YoloPollution({Key? key, required this.vision}) : super(key: key);

  @override
  State<YoloPollution> createState() => _YoloImageV8State();
}

class _YoloImageV8State extends State<YoloPollution> {
  late CameraController controller;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  ImagePicker imagePicker = new ImagePicker();
  GlobalKey<ScaffoldState> gKey = GlobalKey<ScaffoldState>();
  GlobalKey scr = new GlobalKey();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        if (!mounted) {
          return;
        }
        setState(() {

          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }


  @override
  void dispose() async {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),

        ...displayBoxesAroundRecognizedObjects(size),

        Positioned(
          bottom: 75,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 5, color: Colors.white, style: BorderStyle.solid),
                ),
                child: isDetecting
                    ? IconButton(
                  onPressed: () async {
                    stopDetection();
                  },
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.red,
                  ),
                  iconSize: 50,
                )
                    : IconButton(
                  onPressed: () async {
                    await startDetection();
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 50,
                ),
              ),
              TextButton(onPressed: () async{
                capture();
              }, child: Text("Capture")),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/new_float32_N.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {

    setState(() {
      isDetecting = true;
    });

    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });

  }

  Future<void> stopDetection() async {
    if(isDetecting){
      setState(() {
        isDetecting = false;
        yoloResults.clear();
      });
    }
  }

  void capture() async {
    if(isDetecting){
      if(yoloResults.isNotEmpty){

        print(yoloResults);
        // final RenderRepaintBoundary boundary = scr.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        // final ui.Image image = await boundary.toImage();
        // final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        // final Uint8List pngBytes = byteData!.buffer.asUint8List();
        // print(pngBytes);
      }
      else print("yoloResult is Empty");
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);
    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      print("${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%");
      return Positioned(
          left: result["box"][0] * factorX,
          top: result["box"][1] * factorY,
          width: (result["box"][2] - result["box"][0]) * factorX,
          height: (result["box"][3] - result["box"][1]) * factorY,
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: Colors.pink, width: 2.0),
              ),
              child: Text(
                "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  background: Paint()..color = colorPick,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
      );
    }).toList();
  }
}


class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;

  PolygonPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(129, 255, 2, 124)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]['x']!, points[0]['y']!);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i]['x']!, points[i]['y']!);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TesseractImage extends StatefulWidget {
  final FlutterVision vision;
  const TesseractImage({Key? key, required this.vision}) : super(key: key);

  @override
  State<TesseractImage> createState() => _TesseractImageState();
}

class _TesseractImageState extends State<TesseractImage> {
  late List<Map<String, dynamic>> tesseractResults = [];
  File? imageFile;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadTesseractModel().then((value) {
      setState(() {
        isLoaded = true;
        tesseractResults = [];
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            imageFile != null ? Image.file(imageFile!) : const SizedBox(),
            tesseractResults.isEmpty
                ? const SizedBox()
                : Align(child: Text(tesseractResults[0]["text"])),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: pickImage,
                  child: const Text("Pick an image"),
                ),
                ElevatedButton(
                  onPressed: tesseractOnImage,
                  child: const Text("Get Text"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadTesseractModel() async {
    await widget.vision.loadTesseractModel(
      args: {
        'psm': '11',
        'oem': '1',
        'preserve_interword_spaces': '1',
      },
      language: 'spa',
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  tesseractOnImage() async {
    tesseractResults.clear();
    Uint8List byte = await imageFile!.readAsBytes();
    final result = await widget.vision.tesseractOnImage(bytesList: byte);
    if (result.isNotEmpty) {
      setState(() {
        tesseractResults = result;
      });
    }
  }
}