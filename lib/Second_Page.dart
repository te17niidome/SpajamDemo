import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  SecondPage(this.name);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/icon_demo.jpg'),
            Text(name,
            style: TextStyle(
              fontSize: 50,
            )),
            ElevatedButton(
              onPressed: (){
                //ボタンを押した時に呼ばれるコードを書く
                Navigator.pop(context);
              },
              child: const Text('次の画面へ'),
            ),
          ],
        ),
      ),
    );
  }
}