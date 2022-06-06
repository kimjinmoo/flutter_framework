import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// 웹뷰
///
class LottoTotalStatisticsWebview extends StatefulWidget {
  @override
  LottoTotalStatisticsWebviewState createState() {
    return LottoTotalStatisticsWebviewState();
  }
}

///
/// 통계 보기
///
class LottoTotalStatisticsWebviewState extends State<LottoTotalStatisticsWebview> {
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
          title: const Text("총 번호", style: TextStyle(color: Colors.black)),
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
                    initialUrl: 'https://www.grepiu.com/toy/lotto/total-statistics?offNav=off',
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
