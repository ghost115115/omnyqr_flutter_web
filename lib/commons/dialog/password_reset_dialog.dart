import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/password_reset/bloc/password_reset_bloc.dart';
import '../constants/omny_routes.dart';

class PasswordReset {
  SendResetStatus? status;
  BuildContext? context;

  PasswordReset({this.context, this.status});
  PasswordReset.callDialog(SendResetStatus? status, BuildContext context) {
    switch (status) {
      case SendResetStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('email_recover'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<PasswordResetBloc>().add(ResetDialogEvent());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });

        break;
      case SendResetStatus.wrongEmail:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('wrong_email'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<PasswordResetBloc>().add(ResetDialogEvent());
        });

        break;
      case SendResetStatus.notFound:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('not_found'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<PasswordResetBloc>().add(ResetDialogEvent());
        });

        break;
      case SendResetStatus.error:
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
            }).then((value) {
          context.read<PasswordResetBloc>().add(ResetDialogEvent());
        });
        break;
      case SendResetStatus.networkError:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('network_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<PasswordResetBloc>().add(ResetDialogEvent());
        });

        break;

      default:
    }
  }
}
