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
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..runJavaScript('document.body.style.overflow = \'hidden\';')
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('progress : ${progress}');
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
      ..loadRequest(Uri.parse('https://www.grepiu.com/toy/lotto/statistics?offNav=off'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text("회차 별 통계", style: TextStyle(color: Colors.black)),
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
