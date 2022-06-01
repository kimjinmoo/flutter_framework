import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Setting extends GetView {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title:
          const Text("설정", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: Text("Version 1.0"),
        ),
    );
  }
}
