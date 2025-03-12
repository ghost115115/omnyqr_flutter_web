import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import '../../views/personal_area/subviews/change_password/bloc/change_password_bloc.dart';

class PasswordDialog {
  PasswordStatus? status;
  BuildContext? context;

  PasswordDialog({this.context, this.status});
  PasswordDialog.callDialog(PasswordStatus? status, BuildContext context) {
    switch (status) {
      case PasswordStatus.error:
        showDialog(
                context: context,
                builder: (context) {
                  return CommonDialog(
                    btn2Label: tr('ok'),
                    isBtn1Enabled: false,
                    title: tr('wrong_credential'),
                    onTap2: () {
                      Navigator.pop(context);
                    },
                  );
                })
            .then((value) =>
                context.read<ChangePasswordBloc>().add(ResetPasswordDialog()));

        break;
      case PasswordStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('password_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) => Navigator.pop(context));

        break;
      case PasswordStatus.networkError:
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
                context.read<ChangePasswordBloc>().add(ResetPasswordDialog()));

        break;

      default:
    }
  }
}
