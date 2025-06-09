import 'package:intl/intl.dart';

String formatReadableDate(DateTime date) {
  final formatter = DateFormat.yMMMd('en_PH').add_Hm().add_jm();
  return formatter.format(date);
}
