import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// 웹뷰
///
class LottoStatisticsWebview extends StatefulWidget {
  @override
  LottoStatisticsWebviewState createState() {
    return LottoStatisticsWebviewState();
  }
}

///
/// 통계 보기
///
class LottoStatisticsWebviewState extends State<LottoStatisticsWebview> {
  late WebViewController _webViewController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("통계", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
            child: Container(
              child: Stack(
                children: [
                  WebView(
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: 'https://www.grepiu.com/toy/lotto/statistics?offNav=off',
                    onPageFinished: (finish) {
                      _webViewController.runJavascript('document.body.style.overflow = \'hidden\';');
                      setState(() {
                        isLoading = false;
                      });
                    },
                    onProgress: (int progress) {
                      if(progress < 100) {
                        setState(() {
                          isLoading = true;
                        });
                      }
                    },
                    gestureNavigationEnabled: false,
                    zoomEnabled: false,
                    onWebResourceError: (e) {
                      print(e);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20), child: Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(icon: Icon(Icons.refresh_outlined, size: 50, color: Colors.black54), onPressed: (){
                      _webViewController.reload();
                    }),
                  )),
                  isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : Stack(),
                ],
              ),
            ),
            ));
  }
}
