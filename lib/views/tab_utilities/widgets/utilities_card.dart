import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omnyqr/commons/constants/omny_images.dart';
import 'package:omnyqr/commons/constants/omny_qr_type.dart';
import '../../../commons/constants/omny_colors.dart';
import '../../../commons/constants/omny_typography.dart';
import '../../../commons/widgets/common_rounded_container_small.dart';

class UtilitiesCard extends StatelessWidget {
  final void Function()? onTap;
  final String? name;
  final String? title;
  final String? address;
  final String? uid;
  final bool? iAmOwner;
  const UtilitiesCard(
      {this.onTap,
      this.address,
      this.name,
      this.title,
      this.uid,
      this.iAmOwner,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: iAmOwner ?? false,
                child: Triangle(
                  name: name,
                ),
              ),
            ),
            RoundBorderContainerSmall(
                givenWidth: 2.w,
                color: getQrColor(name ?? ''),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 12.h, bottom: 12.h, left: 20.w, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  getQrIcon(name ?? ''),
                                  height: 16.h,
                                  width: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                      AppColors.mainBlue, BlendMode.srcIn),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  name ?? '',
                                  style: AppTypografy.common13.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: getQrColor(name ?? '')),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              "${tr('id')}: $uid",
                              maxLines: 2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypografy.common13.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mainBlue),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              title ?? '',
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypografy.commonBlack16
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              address ?? '',
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypografy.common13
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: getQrColor(name ?? ''),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class Triangle extends StatelessWidget {
  final String? name;
  const Triangle({
    super.key,
    this.name,
  });
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: MyPainter(name: name),
        child: Container(
            height: 70.h,
            width: 70.h,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 30.h, bottom: 20.h),
                    child: SvgPicture.asset(
                      AppImages.account,
                      height: 20.h,
                      color: AppColors.commonWhite,
                    )))));
  }
}

class MyPainter extends CustomPainter {
  final String? name;
  const MyPainter({
    this.name,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = getQrColor(name ?? '');
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
