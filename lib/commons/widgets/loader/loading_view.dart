import 'package:flutter/material.dart';
import 'package:omnyqr/commons/constants/omny_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        color: Colors.black.withAlpha(50),
        // ignore: prefer_const_constructors
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: AppColors.mainBlue,
            ),
          ],
        ));
  }
}
