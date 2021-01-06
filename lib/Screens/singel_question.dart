import 'package:flutter/material.dart';
import 'package:medical_guardian/model/infermedica_api.dart';

class SingleQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settings = (ModalRoute.of(context).settings.arguments as Map);
    final evidence = settings['evidence'] as List;
    final questionMap = settings['respone']['question'];
    final question = questionMap['text'] as String;
    final id = (questionMap['items'] as List).first['id'];
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
            InkWell(
              onTap: () async {
                evidence.add({"id": id, 'choice_id': 'present'});
                print('${id}: present');
                final respone = await Infermedica.diagnosis(evidence);
                print(respone);
                if (respone['should_stop']) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/results', ModalRoute.withName('/home'),
                      arguments: {'respone': respone, 'evidence': evidence});
                } else {
                  final type = respone['question']['type'];
                  if (type == 'group_single') {
                    Navigator.of(context).pushNamed('/group-single',
                        arguments: {'respone': respone, 'evidence': evidence});
                  } else if (type == 'single') {
                    Navigator.of(context).pushNamed('/single',
                        arguments: {'respone': respone, 'evidence': evidence});
                  } else if (type == 'group_multiple') {
                    Navigator.of(context).pushNamed('/group-multi',
                        arguments: {'respone': respone, 'evidence': evidence});
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                width: size.width,
                height: size.height / 10,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 36,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Yes',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () async {
                evidence.add({"id": id, 'choice_id': 'absent'});
                print('${id}: absent');
                final respone = await Infermedica.diagnosis(evidence);
                print(respone);
                if (respone['should_stop']) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/results', ModalRoute.withName('/home'),
                      arguments: {'respone': respone, 'evidence': evidence});
                } else {
                  final type = respone['question']['type'];
                  if (type == 'group_single') {
                    Navigator.of(context).pushNamed('/group-single',
                        arguments: {'respone': respone, 'evidence': evidence});
                  } else if (type == 'single') {
                    Navigator.of(context).pushNamed('/single',
                        arguments: {'respone': respone, 'evidence': evidence});
                  } else if (type == 'group_multiple') {
                    Navigator.of(context).pushNamed('/group-multi',
                        arguments: {'respone': respone, 'evidence': evidence});
                  }
                }
              },
              child: Container(
                width: size.width,
                height: size.height / 10,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 28,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'No',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            InkWell(
              onTap: () async {
                evidence.add({"id": id, 'choice_id': 'unknown'});
                print('${id}: unknown');
                final respone = await Infermedica.diagnosis(evidence);
                print(respone);
                if (respone['should_stop']) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/results', ModalRoute.withName('/home'),
                      arguments: {'respone': respone, 'evidence': evidence});
                } else {
                  final type = respone['question']['type'];
                  if (type == 'group_single') {
                    Navigator.of(context).pushNamed('/group-single',
                        arguments: {'respone': respone, 'evidence': evidence});
                  } else if (type == 'single') {
                    Navigator.of(context).pushNamed('/single',
                        arguments: {'respone': respone, 'evidence': evidence});
                  } else if (type == 'group_multiple') {
                    Navigator.of(context).pushNamed('/group-multi',
                        arguments: {'respone': respone, 'evidence': evidence});
                  }
                }
              },
              child: Container(
                width: size.width,
                height: size.height / 10,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                      size: 28,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Don\'t Know',
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: Container()),
            Divider(thickness: 1, height: 10),
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
            )
          ],
        ),
      ),
    );
  }
}
