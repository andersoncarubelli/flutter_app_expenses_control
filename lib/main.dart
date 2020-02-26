import 'package:flutter/material.dart';
import 'package:flutter_app_expenses_control/widgets/chart.dart';
import 'package:flutter_app_expenses_control/widgets/new_transaction.dart';
import 'package:flutter_app_expenses_control/models/transaction.dart';
import 'package:flutter_app_expenses_control/widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de despesas', 
      theme: ThemeData (
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          button: TextStyle(
            color: Colors.white
          )
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
              fontFamily: 'OpenSans', 
              fontSize: 20,
            )
          )
        )
      ),
      home: MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransactions = [
    Transaction(id: 't1', title: 'new shoes', amount: 69.99, date: DateTime.now()),
    Transaction(id: 't2', title: 'groceriers', amount: 16.99, date: DateTime.now())
  ];

  List <Transaction> get _recentTransactions {
    return _userTransactions.where((tx){
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7)
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(), 
      title: title, 
      amount: amount, 
      date: chosenDate
      );

      setState(() {
        _userTransactions.add(newTx);
      });
  }
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_){
      return NewTransaction(_addNewTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Suas despesas', style: TextStyle(fontFamily: 'OpenSans')),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),)
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction) 
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
