
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  late  WebViewController _controller;

  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..runJavaScript('document.body.style.overflow = \'hidden\';')
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse('https://www.grepiu.com/support?offNav=off'));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title:
          const Text("문의하기", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            isLoading ? Center( child: CircularProgressIndicator(),)
                : Stack(),
          ],
        ))
    );
  }
}
