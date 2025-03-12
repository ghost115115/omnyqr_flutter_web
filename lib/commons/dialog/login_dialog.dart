import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/user_login/bloc/login_bloc.dart';

class LoginDialog {
  LoginStatus? status;
  BuildContext? context;

  LoginDialog({this.context, this.status});
  LoginDialog.callDialog(LoginStatus? status, BuildContext context) {
    switch (status) {
      case LoginStatus.authWrongCrendential:
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
            });
        context.read<LoginBloc>().add(ResetDialogEvent());
        break;
      case LoginStatus.authenticationError:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('login_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<LoginBloc>().add(ResetDialogEvent());
        break;
      case LoginStatus.networkError:
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
        context.read<LoginBloc>().add(ResetDialogEvent());
        break;
      case LoginStatus.accountNotActive:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('account_not_active'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<LoginBloc>().add(ResetDialogEvent());
        break;
      case LoginStatus.accountDisabled:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('account_disabled'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            });
        context.read<LoginBloc>().add(ResetDialogEvent());
        break;
      default:
    }
  }
}
