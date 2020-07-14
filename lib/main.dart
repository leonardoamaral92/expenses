import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'components/chart.dart';
import 'models/transaction.dart';
import 'dart:math';
import 'package:expenses/components/transaction_list.dart';

void main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
      Transaction(
        id: 't1',
        title: 'Novo tênis de corrida',
        value: 310.76,
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      Transaction(
        id: 't2',
        title: 'Conta de luz',
        value: 20.30,
        date: DateTime.now().subtract(Duration(days: 2)),
      ),
      Transaction(
        id: 't3',
        title: 'Conta de internet',
        value: 89.90,
        date: DateTime.now().subtract(Duration(days: 3)),
      ),
      Transaction(
        id: 't4',
        title: 'Alimentação',
        value: 410.30,
        date: DateTime.now().subtract(Duration(days: 4)),
      ),
      Transaction(
        id: 't5',
        title: 'Aluguel',
        value: 1000.00,
        date: DateTime.now().subtract(Duration(days: 5)),
      ),
      Transaction(
        id: 't6',
        title: 'Fatura cartão',
        value: 650.30,
        date: DateTime.now().subtract(Duration(days: 6)),
      ),

  ];

  List<Transaction> get _recentTransactions{
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoais'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context),
          )
        ],
      ),
      //O componente pai precisa ter um tamanho definido para que o scroll funcione
      body: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            width: double.infinity,
            child: Chart(_recentTransactions),
          ),
          TransactionList(_transactions),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
