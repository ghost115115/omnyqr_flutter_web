import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/constants/omny_routes.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/main_container/bloc/container_event.dart';
import 'package:omnyqr/views/personal_area/bloc/personal_area_bloc.dart';
import '../widgets/common_app_dialog.dart';

class DeleteAccountDialog {
  AccountDeleteStatus? status;
  BuildContext? context;

  DeleteAccountDialog({this.context, this.status});
  DeleteAccountDialog.callDialog(
    AccountDeleteStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case AccountDeleteStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('account_delete_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(LogoutEvent());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });

        break;
      case AccountDeleteStatus.error:
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
      case AccountDeleteStatus.networkError:
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
