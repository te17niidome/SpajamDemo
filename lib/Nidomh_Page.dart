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
            Text('宇宙人'),
            Container(
              color: Colors.blue,
              width: 200,
              height: 160,
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Text('a'),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text('a'),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text('a'),
                    value: 1,
                  ),
                ],
                onChanged: (int? value) {},
                value: isSelectedItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
