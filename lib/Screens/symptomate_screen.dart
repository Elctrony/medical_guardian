import 'package:flutter/material.dart';
import 'package:medical_guardian/components/rounded_button.dart';
import 'package:medical_guardian/model/infermedica_api.dart';

class SymptomChecker extends StatefulWidget {
  @override
  _SymptomCheckerState createState() => _SymptomCheckerState();
}

class _SymptomCheckerState extends State<SymptomChecker> {
  List symptomsName = [];
  List symptoms = [];
  @override
  Widget build(BuildContext context) {
    print(symptoms);
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Text(
                'Add your symptoms',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                'Add as many symptoms as you can for the most accurate results.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            for (int i = 0; i < symptomsName.length; i += 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Chip(
                      backgroundColor: symptoms[i]['choice_id'] == 'present'
                          ? Colors.blue[600]
                          : Colors.red[700],
                      label: FlatButton.icon(
                        color: symptoms[i]['choice_id'] == 'present'
                            ? Colors.blue[600]
                            : Colors.red[700],
                        onPressed: () {
                          setState(() {
                            symptoms.removeAt(i);
                            symptomsName.removeAt(i);
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        textColor: Colors.white,
                        label: Text('${symptomsName[i]}'),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    (i + 1) == symptomsName.length
                        ? Container()
                        : Chip(
                            backgroundColor:
                                symptoms[i+1]['choice_id'] == 'present'
                                    ? Colors.blue[600]
                                    : Colors.red[700],
                            label: FlatButton.icon(
                              color: symptoms[i+1]['choice_id'] == 'present'
                                  ? Colors.blue[600]
                                  : Colors.red[700],
                              onPressed: () {
                                setState(() {
                                  symptoms.removeAt(i+1);
                                  symptomsName.removeAt(i+1);
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              textColor: Colors.white,
                              label: Text('${symptomsName[i + 1]}'),
                            ),
                          ),
                  ],
                ),
              ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 50,
              child: RaisedButton.icon(
                textColor: Colors.blue,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: Colors.grey, width: 0.5)),
                icon: Icon(
                  Icons.add_circle,
                  size: 35,
                ),
                label: Text(
                  'Add Symptom',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  final symptom = await Navigator.of(context)
                      .pushNamed('/add_symptom') as List;
                  if (symptom == null) {
                    return;
                  }
                  for (int i = 0; i < symptom.length; i++) {
                    symptomsName.add(symptom[i]['common_name']);
                    symptoms.add(symptom[i]);
                  }
                  setState(() {});
                },
              ),
            ),
            Expanded(child: Container()),
            Divider(
              thickness: 1.5,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  RaisedButton(
                    onPressed: () async {
                      final evidence = symptoms
                          .map<Map>((e) => {
                                'id': e['id'],
                                'choice_id': e['choice_id'],
                                "source": "initial"
                              })
                          .toList();
                      final respone = await Infermedica.diagnosis(evidence);
                      if (respone['should_stop']) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/results', ModalRoute.withName('/home'), arguments: {
                          'respone': respone,
                          'evidence': evidence
                        });
                      } else {
                        final type = respone['question']['type'];
                        if (type == 'group_single') {
                          Navigator.of(context).pushNamed('/group-single',
                              arguments: {
                                'respone': respone,
                                'evidence': evidence
                              });
                        } else if (type == 'single') {
                          Navigator.of(context).pushNamed('/single',
                              arguments: {
                                'respone': respone,
                                'evidence': evidence
                              });
                        } else if (type == 'group_multiple') {
                          Navigator.of(context).pushNamed('/group-multi',
                              arguments: {
                                'respone': respone,
                                'evidence': evidence
                              });
                        }
                      }
                    },
                    color: Colors.green[500],
                    child: Text('Next'),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(12),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
