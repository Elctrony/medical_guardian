import 'package:flutter/material.dart';
import 'package:medical_guardian/model/infermedica_api.dart';

class GroupMultiQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = (ModalRoute.of(context).settings.arguments as Map);
    final evidence = settings['evidence'] as List;
    final questionMap = settings['respone']['question'];
    final question = questionMap['text'] as String;
    final answersList = questionMap['items'] as List;
    final answers = answersList
        .map((e) => {'id': e['id'], 'name': e['name'], 'value': false})
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32, right: 16, left: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            SizedBox(
              height: 32,
            ),
            StatefulBuilder(
              builder: (ctx, setState) {
                print(answers);
                List<DataRow> dataItems = [];
                for (int index = 0; index < answers.length; index++) {
                  dataItems.add(DataRow(
                    cells: [
                      DataCell(
                        Text('${answers[index]['name']}'),
                      ),
                    ],
                    onSelectChanged: (value) {
                      setState(() => answers[index]['value'] = value);
                      print(answers[index]['value']);
                    },
                    selected: answers[index]['value'],
                  ));
                }
                return DataTable(
                  columns: [DataColumn(label: Text('items'))],
                  rows: dataItems,
                );
              },
            ),
            SizedBox(
              height: 26,
            ),
            Text('Just leave all empty if you don\'t know the answer'),
            Expanded(child: Container()),
            Divider(thickness: 1, height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton.icon(
                  onPressed: () {},
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
                    answers.forEach((element) {
                      if (element['value']) {
                        evidence
                            .add({'id': element['id'], 'choice_id': 'present'});
                      } else {
                        evidence
                            .add({'id': element['id'], 'choice_id': 'absent'});
                      }
                    });
                    final respone = await Infermedica.diagnosis(evidence);
                    print(respone);
                    final type = respone['question']['type'];
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
                        Navigator.of(context).pushNamed('/single', arguments: {
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
            )
          ],
        ),
      ),
    );
  }
}
