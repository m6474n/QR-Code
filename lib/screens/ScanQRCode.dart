import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code/controller/HomeController.dart';
import 'package:qr_code/screens/AddDevice.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  late QRViewController qrViewController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text('QR Code Scanner'),
            ),
            body:  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
          );
        });
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    final homeController = Get.find<HomeController>();
    this.qrViewController = qrViewController;
    qrViewController.scannedDataStream.listen((scanData) {

      if (scanData.code != null) {
        setState(() {

          homeController.isDeviceFound = true;
          homeController.decodeQR(scanData.code!);
          Get.to(AddDevice());
        });
      }
    });
  }


  @override
  void dispose() {
    qrViewController.dispose();
    super.dispose();
  }
}
