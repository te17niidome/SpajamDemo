import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  late AnimationController controller;
  late Animation<double> animation;

  Future<void> showPicture() async {
    var random = math.Random();
    int _time = 2000 + random.nextInt(8000);
    print('明日の天気は');
    await Future.delayed(Duration(milliseconds: _time));
    print('晴れです');
    _startTime = DateTime.now();
    controller.forward();
  }

  // ウィジェットが作成されたタイミングで処理を行うinitState()
  @override
  void initState() {
    super.initState();
    showPicture();

    controller = AnimationController(
      vsync: this, // with SingleTickerProviderStateMixin を忘れずに
      duration: Duration(seconds: 2),
    );
    animation = Tween<double>(
      begin: 1.0, // アニメーション開始時のスケール
      end: 2.0, // アニメーション終了時のスケール
    ).animate(controller);
  }

  // disposeは画面が消えるときの処理
  //    AnimationControllerのインスタンスを破棄する
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              width: 360,
              height: 360,
              color: Colors.yellow[50],
              child: Stack(
                children: [
                  Text('あいうえお'),
                  Text('かきくけこ'),
                  ScaleTransition(
                    scale: animation,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.black,
                    ),
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
                controller.stop();
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
