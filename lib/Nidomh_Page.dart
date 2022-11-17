import 'package:flutter/material.dart';

class NiidomeHomePage extends StatefulWidget {
  const NiidomeHomePage({super.key, required this.title});

  final String title;

  @override
  State<NiidomeHomePage> createState() => _NiidomeHomePageState();
}

class _NiidomeHomePageState extends State<NiidomeHomePage> {
  int? isSelectedItem = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nidomhのぺーじ'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('宇宙人'),
            Container(
              color: Colors.blue,
              width: 200,
              // height: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('a'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('b'),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('c'),
                    ),
                  ],
                  onChanged: (int? value) {
                    setState(() {
                      isSelectedItem = value;
                    });
                  },
                  value: isSelectedItem,
                  isExpanded: true,
                  // テキストのスタイル
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),

                  // アイコンのデザイン
                  iconEnabledColor: Colors.white,
                  iconSize: 20,
                  icon: const Icon(Icons.add_circle_outline),

                  // アンダーライン
                  underline: Container(
                    height: 0,
                    color: Colors.white,
                  ),

                  // リストに色を付ける
                  dropdownColor: Colors.blue[200],
                  // リストに影を付ける
                  elevation: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
