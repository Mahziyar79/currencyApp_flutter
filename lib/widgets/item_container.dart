import 'package:flutter/material.dart';
import '../model/currency_model.dart';
import '../utils/format_number.dart';

class ItemContainer extends StatelessWidget {
  final Currency currency;
  const ItemContainer({super.key, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.grey)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(currency.title!, style: Theme.of(context).textTheme.bodySmall),
          Text(
            getFarsiNumber(formatNumber(currency.price!)),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            getFarsiNumber(currency.changes!),
            style: currency.status == 'n'
                ? Theme.of(context).textTheme.labelSmall
                : Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
