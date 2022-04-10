import 'dart:io';

import 'package:app/pages/home/presentation/controllers/home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCode extends StatefulWidget {

  @override
  State createState() {
    return QrCodeState();
  }
}

// QR 코드로 검색
class QrCodeState extends State<QrCode> {
  // 다른 페이지에서 사용되는 컨트롤러를 Get으로 찾아서 redirect 할 수 있습니다.
  final HomeController c = Get.find();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  Widget build(context) {
    // 업데이트된 count 변수에 연결
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR 코드인식"),
      ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? Text(
                    'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                    : Text('Scan a code'),
              ),
            )
          ],
        )
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
