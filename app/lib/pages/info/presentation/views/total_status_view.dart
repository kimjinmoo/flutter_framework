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
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..runJavaScript('document.body.style.overflow = \'hidden\';')
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if(progress < 100) {
              setState(() {
                isLoading = true;
              });
            }
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
      ..loadRequest(Uri.parse('https://www.grepiu.com/toy/lotto/total-statistics?offNav=off'));
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
                  WebViewWidget(controller: _webViewController),
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
