import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../views/association_create/bloc/association_create_bloc.dart';
import '../widgets/common_app_dialog.dart';

class AssociationCreateDialog {
  AssociationStatus? status;
  BuildContext? context;

  AssociationCreateDialog({this.context, this.status});
  AssociationCreateDialog.callDialog(
    AssociationStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case AssociationStatus.complete:
        showDialog(
            context: context,
            builder: (context) {
              return CommonDialog(
                isBtn1Enabled: false,
                btn2Label: tr('ok'),
                title: tr('association_created'),
                onTap2: () {
                  Navigator.pop(context);
                },
              );
            }).then((value) => Navigator.pop(context,true));

        break;
   case AssociationStatus.error:
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
                })
            .then((value) =>
                context.read<AssociationCreateBloc>().add(CreateAssociationReset()));

        break;
      case AssociationStatus.networkError:
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
                context.read<AssociationCreateBloc>().add(CreateAssociationReset()));

        break;
      default:
    }
  }
}
