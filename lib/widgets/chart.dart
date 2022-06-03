import 'package:expense_planner/models/transaction.dart';
import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrans;

  Chart(this.recentTrans);

  List<Map<String, Object>> get groupTransVal {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTrans.length; i++) {
        if (recentTrans[i].date.day == weekDay.day &&
            recentTrans[i].date.month == weekDay.month &&
            recentTrans[i].date.year == weekDay.year) {
          totalSum += recentTrans[i].amount;
        }
      }

      return {'day': DateFormat.E().format(weekDay).substring(0,1),
        'amount': totalSum};
    });
  }

  double get maxSpend{
    return groupTransVal.fold(0.0, (sum, item) =>
    sum + item['amount']
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupTransVal.map((data){
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(data['day'],
                    data['amount'],
                    maxSpend == 0.0 ? 0.0 : (data['amount'] as double) / maxSpend),
              );
            }).toList(),
          ),
      ),
    );
  }
}
