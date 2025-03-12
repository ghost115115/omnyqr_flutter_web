import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnyqr/commons/widgets/common_app_dialog.dart';
import 'package:omnyqr/views/main_container/bloc/container_bloc.dart';
import 'package:omnyqr/views/utility_overview/bloc/overview_page_bloc.dart';
import '../../views/main_container/bloc/container_event.dart';
import '../constants/omny_routes.dart';

class DeleteDialog {
  DeleteStatus? status;
  BuildContext? context;

  DeleteDialog({this.context, this.status});
  DeleteDialog.callDialog(DeleteStatus? status, BuildContext context) {
    switch (status) {
      case DeleteStatus.success:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('delete_utility_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(RefreshUtilities());
          context.read<OverviewPageBloc>().add(ResetDialog());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });
        break;

      case DeleteStatus.logoutUser:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                btn2Label: tr('ok'),
                isBtn1Enabled: false,
                title: tr('exit_utility_success'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) {
          context.read<ContainerBloc>().add(RefreshUtilities());
          context.read<OverviewPageBloc>().add(ResetDialog());
          Navigator.of(context).popUntil(ModalRoute.withName(Routes.main));
        });
        break;

      case DeleteStatus.error:
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
        context.read<OverviewPageBloc>().add(ResetDialog());
        break;
      case DeleteStatus.networkError:
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
        context.read<OverviewPageBloc>().add(ResetDialog());
        break;

      default:
    }
  }
}
