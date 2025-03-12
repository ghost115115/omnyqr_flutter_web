import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';

import '../../views/call_deviation/bloc/call_deviation_bloc.dart';

class DeviationDialog {
  BuildContext? context;
  CallDeviationError? status;

  DeviationDialog({this.context, this.status});
  DeviationDialog.callDialog(
    BuildContext context,
    CallDeviationError? status,
  ) {
    switch (status) {
      case CallDeviationError.error:
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
        //.then((value) => Navigator.pop(context, true));

        break;
      case CallDeviationError.networkError:
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
        //.then((value) => Navigator.pop(context, true));

        break;
      case CallDeviationError.noUser:
        break;

      case CallDeviationError.success:
        showDialog(
          context: context,
          builder: (context) {
            return CommonDialog(
              isBtn1Enabled: false,
              btn2Label: tr('ok'),
              title: tr('success_deviation'),
              onTap2: () {
                Navigator.pop(context);
              },
            );
          },
        );
        //.then((value) => Navigator.pop(context, true));
        break;

      case CallDeviationError.none:
        break;
      case null:
        break;
    }
  }
}
