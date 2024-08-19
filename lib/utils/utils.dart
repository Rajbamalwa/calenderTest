import 'package:intl/intl.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('EEE dd MMM');
  return formatter.format(dateTime).toUpperCase();
}

String formatDateTime2(DateTime dateTime) {
  final DateFormat formatter = DateFormat('EEEE dd MMMM');
  String formattedDate = formatter.format(dateTime);

  return formattedDate
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
