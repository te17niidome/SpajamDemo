import 'package:flutter/material.dart';
import 'second_page.dart';

class FirstPage extends StatelessWidget {
  String nameText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage('太郎'),
                    fullscreenDialog: true,
                  )
              );
            },
            child: Text('太郎'),
          ),
        ],
        title: const Text('First'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: NetworkImage('https://kumamoto-nct.ac.jp/wp/wp-content/themes/KumamotoNCT-201006/images/logo_home.png'),
              ),
              TextField(
                onChanged: (text){
                  nameText = text;
                },
              ),
              ElevatedButton(
                onPressed: (){
                  //ボタンを押した時に呼ばれるコードを書く
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage(nameText),
                      fullscreenDialog: true,
                    )
                  );
                },
                child: const Text('次の画面へ'),),
            ],
          ),
        ),
      ),
    );
  }
}