import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:expense_planner/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTrans;
  final Function deleteTx;

  TransactionList(this.userTrans, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return userTrans.isEmpty
          ? Column(
              children: [
                Container(
                  height: 300,
                  padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
                  child: Image.asset(
                    'assets/images/test.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    'No Transactions Jost',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text('\$${userTrans[index].amount}')),
                      ),
                    ),
                    title: Text(userTrans [index].title, style: Theme.of(context).textTheme.subtitle1,),
                    subtitle: Text(DateFormat.yMMMd().format(userTrans[index].date),
                  ),
                    trailing:Platform.isIOS ? IconButton(icon:Icon(CupertinoIcons.delete),onPressed: ()=> deleteTx(userTrans[index].id)) : IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: ()=> deleteTx(userTrans[index].id),
                    ),
                  ),
                );
              },
              itemCount: userTrans.length,
            );
  }
}
