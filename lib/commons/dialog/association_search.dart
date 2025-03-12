import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../views/association_search/bloc/association_bloc.dart';
import '../widgets/common_app_dialog.dart';

class AssociationSearchDialog {
  AssociationSearch? status;
  BuildContext? context;

  AssociationSearchDialog({this.context, this.status});
  AssociationSearchDialog.callDialog(
    AssociationSearch? status,
    BuildContext context,
  ) {



    switch (status) {
    
      case AssociationSearch.error:
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
                context.read<AssociationBloc>().add(ResetAssociationStatus()));

        break;
      case AssociationSearch.networkError:

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
                context.read<AssociationBloc>().add(ResetAssociationStatus()));

        break;
      default:
    }
  }
}

 