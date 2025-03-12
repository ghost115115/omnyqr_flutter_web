// il formatters serve per escludere o consentire l'immissione dei caratteri

import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppFormatters {
  static FilteringTextInputFormatter onlyLetters() {
    FilteringTextInputFormatter formatters =
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"));
    return formatters;
  }

  static FilteringTextInputFormatter onlyLettersAndSpace() {
    FilteringTextInputFormatter formatters =
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"));
    return formatters;
  }

  static MaskTextInputFormatter postalCodeFormatters() {
    MaskTextInputFormatter formatters = MaskTextInputFormatter(
        mask: '#####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return formatters;
  }

  static MaskTextInputFormatter provinceFormatter() {
    MaskTextInputFormatter formatters = MaskTextInputFormatter(
        mask: "##",
        filter: {"#": RegExp(r'[a-zA-Z]')},
        type: MaskAutoCompletionType.lazy);
    return formatters;
  }

  static MaskTextInputFormatter homePhoneFormatter() {
    MaskTextInputFormatter formatters = MaskTextInputFormatter(
        mask: '###############',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return formatters;
  }

  static MaskTextInputFormatter dateFormatters() {
    MaskTextInputFormatter dateFormatter = MaskTextInputFormatter(
        mask: '##-##-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    return dateFormatter;
  }

  static MaskTextInputFormatter nisFormatter() {
    MaskTextInputFormatter nisFormatter = MaskTextInputFormatter(
        mask: '################',
        filter: {"#": RegExp("[0-9a-zA-Z]")},
        type: MaskAutoCompletionType.lazy);

    return nisFormatter;
  }

  
}
