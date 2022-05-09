
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
class LottoStatisticsWebviewState extends State<LottoStatisticsWebview> {

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
          const Text("당첨 통계", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.grepiu.com',
        ))
    );
  }
}
