
import 'dart:io';

import 'package:app/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// 웹뷰
///
class QnaWebview extends StatefulWidget {

  @override
  QnaWebviewState createState() {
    return QnaWebviewState();
  }
}
class QnaWebviewState extends State<QnaWebview> {

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title:
          const Text("문의하기", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.grepiu.com/support',
        ))
    );
  }
}
