import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/dialog/association_search.dart';
import 'package:omnyqr/commons/widgets/common_create_pages_body.dart';
import 'package:omnyqr/repositories/utilities/utility_repo.dart';
import 'package:omnyqr/views/association_search/bloc/association_bloc.dart';
import '../../commons/constants/omny_colors.dart';
import '../../commons/constants/omny_routes.dart';
import '../../commons/constants/omny_typography.dart';

class AssociationPage extends StatelessWidget {
  const AssociationPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? params = ModalRoute.of(context)!.settings.arguments as String?;
    return BlocProvider(
      create: (context) => AssociationBloc(context.read<UtilityRepository>())
        ..add(AssociationInitEvent(value: params)),
      child: BlocConsumer<AssociationBloc, AssociationState>(
        listener: (context, state) {
          AssociationSearchDialog.callDialog(state.status, context);
        },
        builder: (context, state) {
          return CommonCreatePageBody(
            floating: FloatingActionButton(
              backgroundColor: AppColors.mainBlue,
              onPressed: () async {
                AssociationBloc bloc = context.read<AssociationBloc>();
                bool result = await Navigator.of(context)
                        .pushNamed(Routes.createAssociation, arguments: params)
                    as bool;

                if (result == true) {
                  bloc.add(AssociationRefreshEvemt());
                }
              },
              child: const Icon(Icons.add),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      state.title ?? '',
                      style: AppTypografy.commonBlack16
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Visibility(
                        visible: state.isLoading == true,
                        child: SizedBox(
                            width: double.maxFinite,
                            height: 400.h,
                            // ignore: prefer_const_constructors
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(
                                  color: AppColors.mainBlue,
                                ),
                              ],
                            ))),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.associations?.length ?? 0,
                      itemBuilder: (context, index) {
                        var data = state.associations?[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, data);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.commonWhite,
                                border:
                                    Border.all(color: AppColors.containerSmall),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12.h,
                                    bottom: 12.h,
                                    left: 20.w,
                                    right: 20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data?.name ?? '',
                                      style: AppTypografy.common13.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.commonBlack),
                                    ),
                                    Text(
                                      data?.uid ?? '',
                                      style: AppTypografy.common13.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.mainBlue),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      data?.address ?? '',
                                      style: AppTypografy.common13.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.commonBlack),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
