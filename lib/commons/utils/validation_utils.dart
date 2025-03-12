// ignore_for_file: curly_braces_in_flow_control_structures, prefer_contains

import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';

class AppValidationUtils {
  static String? isPasswordValid(String value) {
    RegExp letterRegex = RegExp(r'[a-zA-Z]');
    RegExp numberRegex = RegExp(r'[0-9]');

    bool containsLetter = letterRegex.hasMatch(value);
    bool containsNumber = numberRegex.hasMatch(value);
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length >= 8) {
      if (containsLetter == false || containsNumber == false) {
        return tr('pass_hint');
      }
    } else if (value.length < 8) {
      return tr('pass_hint_2');
    }
    return null;
  }

  static String? isNewPasswordValid(String old, String newP) {
    RegExp letterRegex = RegExp(r'[a-zA-Z]');
    RegExp numberRegex = RegExp(r'[0-9]');

    bool containsLetter = letterRegex.hasMatch(newP);
    bool containsNumber = numberRegex.hasMatch(newP);
    if (newP.isEmpty) {
      return tr('required_field');
    } else if (newP == old) {
      return tr('pass_hint_3');
    } else if (newP.length >= 8) {
      if (containsLetter == false || containsNumber == false) {
        return tr('pass_hint');
      }
    } else if (newP.length < 8) {
      return tr('pass_hint_4');
    }
    return null;
  }

  static String? isNotEmpty(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isAssociationIdValid(String value) {
    RegExp check = RegExp(r'^[a-zA-Z0-9]+$');
    if (value.isEmpty) {
      return tr('required_field');
    } else if (!check.hasMatch(value)) {
      return tr('invalid_char');
    }
    return null;
  }

  static String? isConfirmPasswordValid(String value, String newPassword) {
    RegExp letterRegex = RegExp(r'[a-zA-Z]');
    RegExp numberRegex = RegExp(r'[0-9]');
    bool containsLetter = letterRegex.hasMatch(value);
    bool containsNumber = numberRegex.hasMatch(value);

    if (value.isEmpty) {
      return tr('required_field');
    } else {
      if (containsLetter == false || containsNumber == false) {
        return tr('pass_hint');
      } else {
        if (newPassword != '' && value != newPassword) {
          return tr('pass_hint_5');
        }
      }
    }
    return null;
  }

  static String? isDocumentValid(String value, String dateControl) {
    if (value.length == 10) {
      List<String> list = value.split("/");

      Iterable<String>? invertedList = list.reversed;

      String newString = invertedList.join();

      if (isValidDate(newString) == false) {
        return tr('date_error');
      } else if (int.parse(dateControl) > int.parse(newString)) {
        return 'Data scadenza antecedente alla data di ritorno';
      }
    } else if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length.clamp(8, 9) == value.length) {
      return tr('date_error_3');
    }
    return null;
  }

  static String? isInputDateValid(String value) {
    if (value.length == 10) {
      List<String> list = value.split("-");

      Iterable<String>? invertedList = list.reversed;

      String newString = invertedList.join();

      if (isValidDate(newString) == false) {
        return tr('date_error');
      }
    } else if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length.clamp(8, 9) == value.length) {
      return tr('date_error_3');
    }
    return null;
  }

  static String? isAdultInputDateValid(String value) {
    if (value.length == 10) {
      List<String> list = value.split("-");

      Iterable<String>? invertedList = list.reversed;

      String newString = invertedList.join();

      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(value);

      String formattedDate = DateFormat("yyyy-MM-dd").format(parsedDate);
      if (isValidDate(newString) == false) {
        return tr('date_error');
      } else if (isAdult(DateTime.parse(formattedDate)) == false) {
        return tr('subscriber');
      }
    } else if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length.clamp(8, 9) == value.length) {
      return tr('date_error_3');
    }
    return null;
  }

  static String? isNameValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.startsWith(' ')) {
      return tr('invalid_char');
    }
    return null;
  }

  static String? isSurnameValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.startsWith(' ')) {
      return tr('invalid_char');
    }
    return null;
  }

  static String? isPlaceOfBirthValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static dynamic isNisValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (controllaCF(value) != true) {
      return tr('nis');
    }
  }

  static String? isCityValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isProvinceValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length < 2) {
      return 'La provincia deve essere di 2 caratteri ';
    }
    return null;
  }

  static String? isAddress(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isJobValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isCapValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isVatValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isRegistryValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isIntercomValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isUrlValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isDetailValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isEndDetailValid(String start, String end) {
    // Stringa rappresentante la data e l'ora
    String dateStartString = start;

    // Dividi la stringa per ottenere data e ora separatamente
    List<String> parts = dateStartString.split(" - ");
    String datePart = parts[0]; // Parte della data
    String timePart = parts[1]; // Parte dell'ora

    // Dividi la parte della data
    List<String> dateParts = datePart.split("/");
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Dividi la parte dell'ora
    List<String> timeParts = timePart.split(":");
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Creazione dell'oggetto DateTime
    DateTime startDateTime = DateTime(year, month, day, hour, minute);

    // Stringa rappresentante la data e l'ora
    String dateEndString = end;

    // Dividi la stringa per ottenere data e ora separatamente
    List<String> endparts = dateEndString.split(" - ");
    String enddatePart = endparts[0]; // Parte della data
    String endtimePart = endparts[1]; // Parte dell'ora

    // Dividi la parte della data
    List<String> enddateParts = enddatePart.split("/");
    int endday = int.parse(enddateParts[0]);
    int endmonth = int.parse(enddateParts[1]);
    int endyear = int.parse(enddateParts[2]);

    // Dividi la parte dell'ora
    List<String> endtimeParts = endtimePart.split(":");
    int endhour = int.parse(endtimeParts[0]);
    int endminute = int.parse(endtimeParts[1]);

    // Creazione dell'oggetto DateTime
    DateTime endDateTime =
        DateTime(endyear, endmonth, endday, endhour, endminute);

    if (end.isEmpty) {
      return tr('required_field');
    } else if (startDateTime.isAfter(endDateTime)) {
      return tr('wrong_date_selected');
    }
    return null;
  }

  static String? isProfessionValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    }
    return null;
  }

  static String? isItalianCapValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length != 5) {
      return 'Il CAP deve essere di 5 cifre';
    }
    return null;
  }

  static String? isHomePhoneValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length < 9) {
      return tr('required_field');
    }
    return null;
  }

  static String? isPhoneValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (value.length < 9) {
      return tr('required_field');
    }
    return null;
  }

  static String? isEmailValid(String value) {
    if (value.isEmpty) {
      return tr('required_field');
    } else if (EmailValidator.validate(value) == false & value.isNotEmpty) {
      return tr('wrong_email_hint');
    }
    return null;
  }
}

bool isValidDate(String input) {
  final date = DateTime.parse(input);
  final originalFormatString = toOriginalFormatString(date);
  return input == originalFormatString;
}

String toOriginalFormatString(DateTime dateTime) {
  final y = dateTime.year.toString().padLeft(4, '0');
  final m = dateTime.month.toString().padLeft(2, '0');
  final d = dateTime.day.toString().padLeft(2, '0');
  return "$y$m$d";
}

bool isAdult(DateTime date) {
  final DateTime today = DateTime.now();
  final DateTime adultDate = DateTime(
    date.year + 18,
    date.month,
    date.day,
  );

  return adultDate.isBefore(today);
}

bool controllaCF(String cf) {
  String validi, set1, set2, setpari, setdisp;
  int i, s = 0;
  cf = cf.toUpperCase();

  if (cf == '') return false;

  if (cf.length != 16) return false;

  validi = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

  for (i = 0; i < 16; i++) {
    if (validi.indexOf(cf[i]) == -1) return false;
  }

  set1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  set2 = "ABCDEFGHIJABCDEFGHIJKLMNOPQRSTUVWXYZ";
  setpari = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  setdisp = "BAKPLCQDREVOSFTGUHMINJWZYX";

  for (i = 1; i <= 13; i += 2) s += setpari.indexOf(set2[set1.indexOf(cf[i])]);

  for (i = 0; i <= 14; i += 2) s += setdisp.indexOf(set2[set1.indexOf(cf[i])]);

  if (s % 26 != cf.codeUnitAt(15) - 'A'.codeUnitAt(0))
    return false;
  else
    return true;
}
