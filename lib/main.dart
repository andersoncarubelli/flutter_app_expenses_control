import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    //Transaction(id: 't1', title: 'new shoes', amount: 69.99, date: DateTime.now()),
    //Transaction(id: 't2', title: 'groceriers', amount: 16.99, date: DateTime.now())
  ];

  bool _showChart = false;

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
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =  mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS ? CupertinoNavigationBar(
      middle: Text('Suas despesas'),
      trailing: Row( 
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddNewTransaction(context)
          )
        ],
      ),
    )
    : AppBar(
      title: Text('Suas despesas', style: TextStyle(fontFamily: 'OpenSans')),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.add), onPressed: () => _startAddNewTransaction(context),)
      ],
    );

    final txListWidget = Container(
      height: (
        mediaQuery.size.height - 
          appBar.preferredSize.height - 
          mediaQuery.padding.top
      ) * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction)
    ); 
    

    final pageBody = SafeArea(child: SingleChildScrollView(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text('Show Chart', style: Theme.of(context).textTheme.title),
                Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart, onChanged: (val){
                  setState(() {
                    _showChart = val;
                  });
                }),
              ]),
            if (!isLandscape) Container(
              height: (
                mediaQuery.size.height - 
                appBar.preferredSize.height -
                mediaQuery.padding.top
              ) * 0.3,
              child: Chart(_recentTransactions)
            ),

            if(!isLandscape) txListWidget,

            if(isLandscape) _showChart ? Container(
              height: (
                mediaQuery.size.height - 
                appBar.preferredSize.height -
                mediaQuery.padding.top
              ) * 0.7,
              child: Chart(_recentTransactions)
            )
            : txListWidget
          ],
        )
      )
      );
    

    return Platform.isIOS ? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,
      ) 
      : Scaffold(
        appBar: appBar,
        body: pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS ? Container() : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      )
    );
  }
}
