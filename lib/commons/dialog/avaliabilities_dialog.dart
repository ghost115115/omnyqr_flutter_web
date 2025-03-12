import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/availability/bloc/availabilities_bloc.dart';

class AvaliabilyDialog {
  UpdateStatus? status;
  BuildContext? context;

  AvaliabilyDialog({this.context, this.status});
  AvaliabilyDialog.callDialog(UpdateStatus? status, BuildContext context) {
    switch (status) {
      case UpdateStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('availability_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          Navigator.pop(context);
          context.read<AvailabilitiesBloc>().add(ResetDialog());
        });
        break;
      case UpdateStatus.error:
        showDialog(
                context: context,
                builder: (context) {
                  return CommonDialog(
                    isBtn1Enabled: false,
                    btn2Label: tr('ok'),
                    title: tr('utility_error'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) =>
                context.read<AvailabilitiesBloc>().add(ResetDialog()));

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
                })
            .then((value) =>
                context.read<AvailabilitiesBloc>().add(ResetDialog()));

        break;

      default:
    }
  }
}
