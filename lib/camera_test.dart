import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

// image_gallery_saverのimport追加
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<void> amain() async {
  // main 関数内で非同期処理を呼び出すための設定
  WidgetsFlutterBinding.ensureInitialized();
  // デバイスで使用可能なカメラのリストを取得
  final cameras = await availableCameras();
  // 利用可能なカメラのリストから特定のカメラを取得
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Example',
      theme: ThemeData(),
      home: TakePictureScreen(camera: camera),
    );
  }
}

/// 写真撮影画面
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  // アニメーション用
  DateTime _buttonTime = DateTime.now();
  DateTime _startTime = DateTime.now();
  var diff_time;
  late AnimationController _animeController;
  late Animation<double> animation;

  final GlobalKey _globalKey = GlobalKey();

  Future<void> AnimeOn() async {
    // // main 関数内で非同期処理を呼び出すための設定
    // WidgetsFlutterBinding.ensureInitialized();

    // // デバイスで使用可能なカメラのリストを取得
    // final cameras = await availableCameras();

    // // 利用可能なカメラのリストから特定のカメラを取得
    // final firstCamera = cameras.first;

    // // 取得できているか確認
    // print(firstCamera);

    var random = math.Random();
    int _time = 2000 + random.nextInt(8000);
    await Future.delayed(Duration(milliseconds: _time));
    _startTime = DateTime.now();
    _animeController.forward();
  }

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // カメラを指定
      widget.camera,
      // 解像度を定義
      ResolutionPreset.medium,
    );

    // コントローラーを初期化
    _initializeControllerFuture = _controller.initialize();

    // アニメーション
    AnimeOn();
    _animeController = AnimationController(
      vsync: this, // with SingleTickerProviderStateMixin を忘れずに
      duration: Duration(milliseconds: 600), // ここに遷移する時間記入
    );
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたら、コントローラーを破棄
    _controller.dispose();
    _animeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // アニメーションのロゴのサイズ
    const double smallLogo = 50;
    const double bigLogo = 70;
    const double cont_size_x = 360;
    const double cont_size_y = 540;
    // アニメーションの座標
    const double start_x = 0 - smallLogo;
    const double start_y = 0 - smallLogo;
    const double end_x = cont_size_x;
    const double end_y = cont_size_y;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nidomhのぺーじ'),
      ),
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Column(
            children: [
              const Text('反射神経測定アプリ',
                  style: TextStyle(fontFamily: 'YuseiMagic', fontSize: 40)),
              Container(
                width: cont_size_x,
                height: cont_size_y,
                color: Colors.yellow[50],
                child: Stack(
                  children: [
                    FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CameraPreview(_controller);
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                    PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromLTRB(
                            start_x,
                            start_y,
                            cont_size_x - start_x - smallLogo,
                            cont_size_y - start_y - smallLogo),
                        end: RelativeRect.fromLTRB(
                          end_x,
                          end_y,
                          cont_size_x - end_x - smallLogo,
                          cont_size_y - end_y - smallLogo,
                        ),
                      ).animate(CurvedAnimation(
                        parent: _animeController,
                        curve: Curves.easeIn,
                      )),
                      child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: FlutterLogo(
                            size: smallLogo,
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "あなたは" + diff_time.toString() + "秒かかりました．",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 50,
                          // height: 150,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              main();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     // builder: (context) => NiidomeHomePage(title: "niidome"),
                              //     // builder: (context) => amain(),
                              //   ),
                              // );
                            },
                            child: Text('戻る')),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // アニメーションの停止
          setState(() {
            _buttonTime = DateTime.now();
            diff_time = _buttonTime.difference(_startTime);
          });
          _animeController.stop();

          // 写真を撮る
          final image = await _controller.takePicture();
          final Uint8List buffer = await image.readAsBytes();
          // カメラロールに保存する
          await ImageGallerySaver.saveImage(buffer, name: image.name);

          _captureImage();

          // // 表示用の画面に遷移
          // await Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => DisplayPictureScreen(imagePath: image.path),
          //     fullscreenDialog: true,
          //   ),
          // );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<void> _captureImage() async {
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String appDirPath = appDir.path;
    print('appDirPath=$appDirPath');
    final File imageFile = await File('$appDirPath/image.png').create();
    await imageFile.writeAsBytes(pngBytes);

    // カメラロールにむりに保存する
    await ImageGallerySaver.saveImage(pngBytes, name: "TESTIMAGE001");
  }
}

// 撮影した写真を表示する画面
class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('撮れた写真')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
