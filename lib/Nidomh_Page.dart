import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:camera/camera.dart';

class NiidomeHomePage extends StatefulWidget {
  const NiidomeHomePage({super.key, required this.title});

  final String title;

  @override
  State<NiidomeHomePage> createState() => _NiidomeHomePageState();
}

class _NiidomeHomePageState extends State<NiidomeHomePage>
    with SingleTickerProviderStateMixin {
  int? isSelectedItem = 1;
  int count = 0;
  DateTime _buttonTime = DateTime.now();
  DateTime _startTime = DateTime.now();
  var diff_time;

  // アニメーションで使う変数
  late AnimationController _controller;
  late Animation<double> animation;

  Future<void> showPicture() async {
    // main 関数内で非同期処理を呼び出すための設定
    WidgetsFlutterBinding.ensureInitialized();

    // デバイスで使用可能なカメラのリストを取得
    final cameras = await availableCameras();

    // 利用可能なカメラのリストから特定のカメラを取得
    final firstCamera = cameras.first;

    // 取得できているか確認
    print(firstCamera);

    var random = math.Random();
    int _time = 2000 + random.nextInt(8000);
    print('明日の天気は');
    await Future.delayed(Duration(milliseconds: _time));
    print('晴れです');
    _startTime = DateTime.now();
    _controller.forward();
  }

  // ウィジェットが作成されたタイミングで処理を行うinitState()
  @override
  void initState() {
    super.initState();
    showPicture();

    _controller = AnimationController(
      vsync: this, // with SingleTickerProviderStateMixin を忘れずに
      duration: Duration(milliseconds: 500),
    );
    // animation = Tween<double>(
    //   begin: 1.0, // アニメーション開始時のスケール
    //   end: 2.0, // アニメーション終了時のスケール
    // ).animate(controller);
  }

  // disposeは画面が消えるときの処理
  //    AnimationControllerのインスタンスを破棄する
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // アニメーションのロゴのサイズ
    const double smallLogo = 50;
    const double bigLogo = 70;
    const double cont_size = 360;
    // アニメーションの座標
    const double start_x = 0 - smallLogo;
    const double start_y = 0 - smallLogo;
    const double end_x = cont_size;
    const double end_y = cont_size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nidomhのぺーじ'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('反射神経測定アプリ',
                style: TextStyle(fontFamily: 'YuseiMagic', fontSize: 40)),
            Container(
              width: cont_size,
              height: cont_size,
              color: Colors.yellow[50],
              child: Stack(
                children: [
                  Text('あいうえお'),
                  Text('かきくけこ'),
                  PositionedTransition(
                    rect: RelativeRectTween(
                      begin: RelativeRect.fromLTRB(
                          start_x,
                          start_y,
                          cont_size - start_x - smallLogo,
                          cont_size - start_y - smallLogo),
                      end: RelativeRect.fromLTRB(
                        end_x,
                        end_y,
                        cont_size - end_x - smallLogo,
                        cont_size - end_x - smallLogo,
                      ),
                    ).animate(CurvedAnimation(
                      parent: _controller,
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
            ElevatedButton.icon(
              onPressed: () {
                //
                setState(() {
                  count++;
                  _buttonTime = DateTime.now();
                  diff_time = _buttonTime.difference(_startTime);
                });
                //
                _controller.stop();
              },
              icon: Icon(Icons.play_arrow),
              label: Text("Play"),
            ),
            Text("あなたは" + diff_time.toString() + "秒かかりました．")
            // Container(
            //   color: Colors.blue,
            //   width: 200,
            //   // height: 160,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: DropdownButton(
            //       items: const [
            //         DropdownMenuItem(
            //           value: 1,
            //           child: Text('a'),
            //         ),
            //         DropdownMenuItem(
            //           value: 2,
            //           child: Text('b'),
            //         ),
            //         DropdownMenuItem(
            //           value: 3,
            //           child: Text('c'),
            //         ),
            //       ],
            //       onChanged: (int? value) {
            //         setState(() {
            //           isSelectedItem = value;
            //         });
            //       },
            //       value: isSelectedItem,
            //       isExpanded: true,
            //       // テキストのスタイル
            //       style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 20,
            //       ),

            //       // アイコンのデザイン
            //       iconEnabledColor: Colors.white,
            //       iconSize: 20,
            //       icon: const Icon(Icons.add_circle_outline),

            //       // アンダーライン
            //       underline: Container(
            //         height: 0,
            //         color: Colors.white,
            //       ),

            //       // リストに色を付ける
            //       dropdownColor: Colors.blue[200],
            //       // リストに影を付ける
            //       elevation: 16,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
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

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたら、コントローラーを破棄
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder で初期化を待ってからプレビューを表示（それまではインジケータを表示）
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
