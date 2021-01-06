import 'package:flutter/material.dart';
import 'package:medical_guardian/model/infermedica_api.dart';

class AddSymptom extends StatelessWidget {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD Symptoms'),
        actions: [
          FlatButton.icon(
              onPressed: () async {
                final text = _textController.text;
                _textController.clear();
                final symptoms = await Infermedica.parseText(text);
                Navigator.of(context).pop(symptoms);
              },
              icon: Icon(Icons.check, color: Colors.white),
              label: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 38.0, bottom: 12, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Write down what do you feel!',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            SizedBox(
              height: 28,
            ),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                  hintText: 'I sever from headach and stomach pain',
                  labelText: 'Symptoms'),
            ),
            Expanded(child: Container()),
            Divider(thickness: 1, height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                  onPressed: () async {
                   Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'Back',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    final text = _textController.text;
                    _textController.clear();
                    final symptoms = await Infermedica.parseText(text);
                    Navigator.of(context).pop(symptoms);
                  },
                  color: Colors.green[500],
                  child: Text('Next'),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(12),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
