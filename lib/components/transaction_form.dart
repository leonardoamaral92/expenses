import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) return;

    //Comunicação indireta: o pai passou para o filho a função onSubmit pelo constructor
    // e agora o filho está invocando no momento desejado
    widget.onSubmit(title, value, _selectedDate);
  }

  _showDatePicker() {
    //Essa função retorna um future que é usado quando uma função tem um retorno assíncrono
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      //Usamos o THEN passando uma função callback para ser invocada no momento que a showDatePicker estiver com o retorno pronto
      if (pickedDate == null) return;

      //usamos o setState para o Flutter saber que um dado mudou e isso precisa REFLETIR na interface
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              onSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'Nenhuma data selecionada!'
                      : 'Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}'),
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Selecionar data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _showDatePicker,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Text('Nova Transação'),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitForm,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
