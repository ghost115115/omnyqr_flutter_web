import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:omnyqr/views/personal_area/bloc/personal_area_bloc.dart';
import '../widgets/common_app_dialog.dart';

class IncognitoDialog {
  UpdateStatus? status;
  BuildContext? context;

  IncognitoDialog({this.context, this.status});
  IncognitoDialog.callDialog(
    UpdateStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case UpdateStatus.error:
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
      case UpdateStatus.networkError:
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
            });

        break;
      default:
    }
  }
}
