import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/services/signaling_service.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import '../../views/main_container/bloc/container_event.dart';
import '../../views/main_container/bloc/container_state.dart';
import '../constants/omny_routes.dart';
import '../widgets/common_app_dialog.dart';

class UtilitiesPageDialog {
  UtilityStatus? status;
  BuildContext? context;

  UtilitiesPageDialog({this.context, this.status});
  UtilitiesPageDialog.callDialog(
    UtilityStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case UtilityStatus.networkError:
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
      case UtilityStatus.initFail:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('app_init_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          SignallingService.instance.socket!.disconnect();
          context.read<ContainerBloc>().add(LogoutEvent());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });

        break;
      case UtilityStatus.error:
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

      default:
    }
  }
}
