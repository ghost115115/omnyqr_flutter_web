import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import '../constants/omny_typography.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? icon;

  const CommonAppBar({this.title, this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.transparent,
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        SizedBox(
          width: 25.w,
        ),
        InkWell(
            enableFeedback: false,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              AppImages.backIcon,
            )),
        SizedBox(
          width: 5.w,
        ),
        const Spacer(
          flex: 2,
        ),
        Center(
            child: Text(title ?? tr('appbar_title'),
                style: AppTypografy.mainContainerAppBarTitle)),
        const Spacer(
          flex: 3,
        ),
        SizedBox(
          width: 30.w,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
