import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:omnyqr/views/tab_qr/views/qr_over_lay.dart';
import '../../../commons/constants/omny_colors.dart';
import '../../../commons/constants/omny_images.dart';
import '../../../commons/constants/omny_typography.dart';

// ignore: must_be_immutable
class QrScannerPage extends StatefulWidget {
  final void Function()? onTap;
  const QrScannerPage({this.onTap, super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
        centerTitle: true,
        actions: [
          SizedBox(
            width: 30.w,
          ),
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                AppImages.backIcon,
              )),
          const Spacer(),
          Center(
            child: Text(
              tr('appbar_title'),
              style: AppTypografy.mainContainerAppBarTitle,
            ),
          ),
          const Spacer(),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off,
                        color: AppColors.mainBlue);
                  case TorchState.on:
                    return const Icon(Icons.flash_on,
                        color: AppColors.mainBlue);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          SizedBox(
            width: 30.w,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            scanWindow: Rect.largest,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                cameraController.dispose();
                Navigator.maybePop(context, barcode.rawValue);
              }
            },
          ),
          QRScannerOverlay(
            overlayColour: Colors.grey.withOpacity(0.6),
          ),
          // permissionStatus != PermissionStatus.granted

          // ? Container(
          //     alignment: Alignment.center,
          //     padding: EdgeInsets.symmetric(horizontal: 60),
          //     child: Padding(
          //       padding: const EdgeInsets.only(
          //         top: 120,
          //       ),
          //       child: Text(
          //         "Non è stato abilitato il permesso per accedere alla fotocamera\nVai nelle impostazioni dell'app e abilita l'accesso alla fotocamera.",
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
