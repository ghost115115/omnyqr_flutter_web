import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/views/tab_qr/bloc/qr_tab_bloc.dart';
import '../widgets/common_app_dialog.dart';

class QrScanDialog {
  QrScanStatus? status;
  BuildContext? context;
  QrScanDialog({this.context, this.status});
  QrScanDialog.callDialog(
    QrScanStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case QrScanStatus.error:
        showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('generic_error'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));
        break;
      case QrScanStatus.pushSent:
        showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('message_sent'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));
        break;
      case QrScanStatus.networkError:
        showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('network_error'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));

        break;
      case QrScanStatus.notFound:
        showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('qr_not_found'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));
        break;
      case QrScanStatus.wrongPosition:
        showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('wrong_address'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));
        break;
      case QrScanStatus.notOmnyQr:
        showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('omny_qr_not_found'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));
        break;

      case QrScanStatus.private:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CommonDialog(
              isBtn1Enabled: false,
              btn2Label: tr('ok'),
              title: tr("omny_qr_private"),
              onTap2: () {
                Navigator.pop(context);
              },
            );
          },
        ).then((value) => context.read<QrTabBloc>().add(ResetDialogEvent()));

        break;
      default:
    }
  }
}
