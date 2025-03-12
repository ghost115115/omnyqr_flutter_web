import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:omnyqr/views/message_section/bloc/send_message_bloc.dart';
import '../widgets/common_app_dialog.dart';

class SendMessageDialog {
  SendStatus? status;
  BuildContext? context;

  SendMessageDialog({this.context, this.status});
  SendMessageDialog.callDialog(
    SendStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case SendStatus.success:
        showDialog(
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
            }).then((value) {
          Navigator.pop(context);
        });

        break;
      case SendStatus.error:
        showDialog(
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
            }).then((value) => Navigator.pop(context, true));

        break;
      case SendStatus.networkError:
        showDialog(
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
            }).then((value) => Navigator.pop(context, true));

        break;
      default:
    }
  }
}
