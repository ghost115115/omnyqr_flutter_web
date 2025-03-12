import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import '../../views/create_edit_qr/bloc/create_edit_qr_bloc.dart';
import '../../views/main_container/bloc/container_event.dart';
import '../constants/omny_routes.dart';

class CreationDialog {
  CreateStatus? status;
  BuildContext? context;

  CreationDialog({this.context, this.status});
  CreationDialog.callDialog(CreateStatus? status, BuildContext context) {
    switch (status) {
      case CreateStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('utility_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(RefreshUtilities());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });

        break;
      case CreateStatus.error:
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
            });

        break;
      case CreateStatus.updateSuccess:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('update_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(RefreshUtilities());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });

        break;
      case CreateStatus.updateError:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('update_error'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(RefreshUtilities());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });

        break;
      default:
    }
  }
}
