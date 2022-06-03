import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:expense_planner/widgets/new_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './new_transactions.dart';
import './transaction_list.dart';
import '../models/transaction.dart';
import 'chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

/// `MyApp` is a `StatefulWidget` that creates a `_MyAppState` object
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

/// _MyAppState extends State<MyApp>
///
/// This means that the class _MyAppState is a subclass of State and that it's
/// associated with the class MyApp
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.orange,
        fontFamily: 'Jost',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // String titleInput;
  final List<Transaction> userTrans = [
    // Transaction(
    //   id: 'Q1',
    //   title: 'New Nike Shoe',
    //   amount: 30,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'Q2',
    //   title: 'JBL Speaker',
    //   amount: 50,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTrans {
    return userTrans.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTrans(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: chosenDate);
    setState(() {
      userTrans.add(newTx);
    });
  }

  void _startNewTrans(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTrans(_addNewTrans),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deletTrans(String id) {
    setState(() {
      userTrans.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startNewTrans(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Personal Expenses'),
          );
    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(_recentTrans),
            ),
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.7,
                child: TransactionList(userTrans, _deletTrans)),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () => _startNewTrans(context),
                    ),
                  ),
          );
  }
}
