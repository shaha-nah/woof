import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title : 'Timer',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Woof'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      )
    );
  }
}