import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

class RoundBorderContainerBig extends StatelessWidget {
  final Widget? child;
  const RoundBorderContainerBig({this.child,super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        
       
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05), // Sfondo blu semi-trasparente
            border: Border.all(
              color: AppColors.containerBig,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.r))),
            child: child,
      ),
    );
  }
}
