import 'package:intl/intl.dart';

String getFarsiNumber(String number) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (var element in en) {
    number = number.replaceAll(element, fa[en.indexOf(element)]);
  }
  return number;
}

String formatNumber(String number) {
  final formatter = NumberFormat("#,###");
  final intNumber = int.tryParse(number.replaceAll(',', '')) ?? 0;
  return formatter.format(intNumber);
}
