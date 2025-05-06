import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import '../bloc/container_bloc.dart';
import '../bloc/container_event.dart';
import '../bloc/container_state.dart';

class ContainerBottomBar extends StatelessWidget {
  const ContainerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContainerBloc, ContainerState>(
        builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: state.bottomBarSelected == 0
                ? Alignment.bottomLeft
                : state.bottomBarSelected == 1
                    ? Alignment.bottomCenter
                    : Alignment.bottomRight,
            child: Container(
              height: 4.h,
              color: AppColors.mainBlue,
              width: MediaQuery.of(context).size.width * 0.33,
            ),
          ),

        ],
      );
    });
  }
}
