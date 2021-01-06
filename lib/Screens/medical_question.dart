import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_guardian/components/rounded_button.dart';
import 'package:medical_guardian/model/userData.dart';
import 'package:provider/provider.dart';

class MedicalQuestion extends StatelessWidget {
  double _height = 100;
  double _weight = 40;
  List<Map> _medicalHistory = [
    {'text': 'Are you overweight or obese?', 'value': false},
    {'text': 'Do you smoke cigarettes', 'value': false},
    {'text': 'Have you recently suffered an injury?', 'value': false},
    {'text': 'Do you have high cholesterol?', 'value': false},
    {'text': 'Do you have hypertension?', 'value': false},
  ];
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.75, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              child: StatefulBuilder(builder: (ctx, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12),
                      child: Text(
                        'Height: ${_height.round().toString()} meters',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Slider(
                      value: _height,
                      min: 100,
                      max: 200,
                      divisions: 100,
                      label: 'Height: ${_height.round().toString()} meters',
                      onChanged: (double value) {
                        setState(() {
                          _height = value;
                        });
                      },
                    )
                  ],
                );
              }),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.75, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              child: StatefulBuilder(builder: (ctx, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12),
                      child: Text(
                        'Weight: ${_weight.round().toString()} Kilograms',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Slider(
                      value: _weight,
                      min: 40,
                      max: 200,
                      divisions: 160,
                      label: 'Height: ${_weight.round().toString()} Kilograms',
                      onChanged: (double value) {
                        setState(() {
                          _weight = value;
                        });
                      },
                    )
                  ],
                );
              }),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.75, color: Colors.grey),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Medical History:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      List<DataRow> dataItems = [];
                      for (int index = 0;
                          index < _medicalHistory.length;
                          index++) {
                        dataItems.add(DataRow(
                          cells: [
                            DataCell(
                              Text('${_medicalHistory[index]['text']}'),
                            ),
                          ],
                          onSelectChanged: (value) {
                            setState(
                                () => _medicalHistory[index]['value'] = value);
                            print(_medicalHistory[index]['value']);
                          },
                          selected: _medicalHistory[index]['value'],
                        ));
                      }
                      return DataTable(
                        columns: [DataColumn(label: Text('Chronic Disease'))],
                        rows: dataItems,
                      );
                    }),
                  ],
                ),
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return _loading
                    ? CircularProgressIndicator()
                    : RoundedButton(
                        text: 'Deliver',
                        press: () async {
                          setState(() => _loading = true);
                          final provider = Provider.of<UserProvider>(context,listen: false);
                          provider.setHeight = _height;
                          provider.setWeight = _weight;
                          provider.setIsOverweight =
                              _medicalHistory[0]['value'];
                          provider.setIsSmoker = _medicalHistory[1]['value'];
                          provider.setHasInjuried = _medicalHistory[2]['value'];
                          provider.setHighCholesterol =
                              _medicalHistory[3]['value'];
                          provider.setHasHypertension =
                              _medicalHistory[4]['value'];

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(provider.getUser.id)
                              .update({
                            'height': _height,
                            'weight': _weight,
                            'overweight': _medicalHistory[0]['value'],
                            'smoke': _medicalHistory[1]['value'],
                            'injuried': _medicalHistory[2]['value'],
                            'cholesterol': _medicalHistory[3]['value'],
                            'hypertension': _medicalHistory[4]['value'],
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
