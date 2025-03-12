import 'package:flutter/material.dart';

class ScaleFactorWidget extends StatelessWidget {
  final Widget? child;
  const ScaleFactorWidget({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.5);
    final boldText = MediaQuery.boldTextOf(context);
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(boldText: boldText, textScaler: TextScaler.linear(scale)),
        child: child ?? Container());
  }
}
