import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'common_app_bar.dart';

class CommonCreatePageBody extends StatelessWidget {
  final Widget? child;
  final Widget? floating;
  const CommonCreatePageBody({this.child, this.floating, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: child,
          ))),
      floatingActionButton: floating,
    );
  }
}
