import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/user_registration/bloc/register_bloc.dart';

class RegisterDialog {
  RegistrationStatus? status;
  BuildContext? context;

  RegisterDialog({this.context, this.status});
  RegisterDialog.callDialog(
    RegistrationStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case RegistrationStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('register_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) => Navigator.pop(context));
        context.read<RegisterBloc>().add(ResetDialogEvent());
        break;
      case RegistrationStatus.networkError:
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
        context.read<RegisterBloc>().add(ResetDialogEvent());
        break;
      case RegistrationStatus.error:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('register_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<RegisterBloc>().add(ResetDialogEvent());
        break;
      case RegistrationStatus.emailAlreadyInUse:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('email_already_in_use'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<RegisterBloc>().add(ResetDialogEvent());
        break;
      default:
    }
  }
}
