import 'package:easy_localization/easy_localization.dart';

extension StringExt on String {
  String? toFormattedDate({String? orPattern, String? newPattern}) {
    var formatter = DateFormat(orPattern ?? "yyyy-MM-ddTHH:mm:ss");
    var parsedDate = formatter.parse(this);
    return DateFormat(newPattern ?? "dd MMM yyyy").format(parsedDate);
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
