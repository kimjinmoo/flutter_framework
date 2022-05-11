import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 프로그램에 대해서...
class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("이프로그램은..."),
        ),
        body: const Center(child: Text("oops"))
    );
  }



}
