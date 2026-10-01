import 'package:intl/intl.dart';

/// Date/number formatting helpers replacing the prototype's `toLocaleDateString()` calls.
class Fmt {
  Fmt._();

  /// `new Date(x).toLocaleDateString()`            -> 1/15/2024
  static String dateShort(DateTime d, String locale) =>
      DateFormat.yMd(locale).format(d);

  /// `{month:'short', day:'numeric', year:'numeric'}` -> Jan 15, 2024
  static String dateMedium(DateTime d, String locale) =>
      DateFormat.yMMMd(locale).format(d);

  /// `{weekday:'long', year, month:'long', day}`   -> Monday, January 15, 2024
  static String dateLong(DateTime d, String locale) =>
      DateFormat.yMMMMEEEEd(locale).format(d);

  /// Time of day -> 8:00 AM
  static String time(DateTime d, String locale) =>
      DateFormat.jm(locale).format(d);

  /// JS-style number printing: 2.0 -> "2", -0.5 -> "-0.5".
  static String number(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}
