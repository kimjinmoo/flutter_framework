
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

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
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
            WebView(
              zoomEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: 'https://www.grepiu.com/support',
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              gestureNavigationEnabled: true,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading ? Center( child: CircularProgressIndicator(),)
                : Stack(),
          ],
        ))
    );
  }
}
