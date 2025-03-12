import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnyqr/commons/constants/omny_typography.dart';
import '../constants/omny_colors.dart';

class CommonFormField extends StatelessWidget {
  final String? title;
  final String? text;
  final String? hint;
  final Widget? icon;
  final bool? obscured;
  final bool? readOnly;
  final bool? capitalization;
  final bool? useController;
  final int? maxLine;
  final TextAlign? txtAlign;
  final double? bottomPadding;
  final void Function()? onTap;
  final void Function(String)? onChange;
  final String? Function(String?)? validate;
  final List<TextInputFormatter>? formatters;
  final AutovalidateMode? autovalidateMode;
  final bool? isScan;
  const CommonFormField(
      {this.hint,
      this.title,
      this.text,
      this.maxLine,
      this.icon,
      this.obscured,
      this.capitalization = false,
      this.txtAlign,
      this.bottomPadding,
      this.useController,
      this.readOnly,
      this.onTap,
      this.onChange,
      this.validate,
      this.formatters,
      this.autovalidateMode,
      this.isScan = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Text(
                title ?? '',
                style: AppTypografy.common13,
              )
            : Container(),
        SizedBox(
          height: title != null ? 5.h : 0.h,
        ),
        TextFormField(
            onTap: onTap,
            textCapitalization: capitalization == true
                ? TextCapitalization.characters
                : TextCapitalization.none,
            initialValue: useController == true ? null : text,
            onChanged: onChange,
            controller: useController == true
                ? TextEditingController(text: text)
                : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (validate != null) {
                return validate?.call(value);
              }
              return null;
            },
            maxLines: maxLine ?? 1,
            readOnly: readOnly ?? false,
            textAlign: txtAlign ?? TextAlign.start,
            obscureText: obscured ?? false,
            cursorColor: AppColors.formBorderColor,
            inputFormatters: formatters,
            decoration: InputDecoration(
                fillColor: AppColors.formFieldColor,
                filled: true,
                focusColor: AppColors.formBorderColor,
                errorBorder: conf(),
                focusedErrorBorder: conf(),
                border: conf(),
                focusedBorder: conf(),
                enabledBorder: conf(),
                disabledBorder: conf(),
                hintText: hint,
                hintStyle: AppTypografy.formHint,
                labelStyle: const TextStyle(color: AppColors.formBorderColor),
                suffixIcon: icon,
                suffixIconColor: AppColors.formHintColor)),
        SizedBox(
          height: bottomPadding ?? 20.h,
        ),
      ],
    );
  }

  conf() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(3.r),
      borderSide: BorderSide(
          color: isScan == true ? AppColors.mainBlue : AppColors.transparent,
          width: isScan == true ? 3 : 1),
    );
  }
}
