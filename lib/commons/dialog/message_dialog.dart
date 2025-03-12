import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/tab_message/subviews/bloc/message_bloc.dart';
import '../widgets/common_app_dialog.dart';

class MessageDialog {
  MessageStatus? status;
  BuildContext? context;

  MessageDialog({this.context, this.status});
  MessageDialog.callDialog(
    MessageStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case MessageStatus.error:
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
            });

        break;
      case MessageStatus.acepted:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('invitation_accepted'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(RefreshUtilities());

          Navigator.pop(context, true);
        });

        break;
      case MessageStatus.refused:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('invitation_refused'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) => Navigator.pop(context, true));

        break;
      case MessageStatus.networkError:
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
