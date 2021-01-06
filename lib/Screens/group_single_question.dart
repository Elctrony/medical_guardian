import 'package:flutter/material.dart';
import 'package:medical_guardian/model/infermedica_api.dart';

class GroupSingleQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = (ModalRoute.of(context).settings.arguments as Map);
    final evidence = settings['evidence'] as List;
    final questionMap = settings['respone']['question'];
    final question = questionMap['text'] as String;
    final answers = questionMap['items'] as List;
    final size = MediaQuery.of(context).size;
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
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (ctx, i) {
                  return InkWell(
                    onTap: () async {
                      evidence.add({
                        "id": answers[i]['id'],
                        "choice_id": "present",
                      });
                      print('${answers[i]['id']}: ${answers[i]['name']}:');
                      final respone = await Infermedica.diagnosis(evidence);
                      print(respone);
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
                    child: Container(
                      width: size.width,
                      height: size.height / 10,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(35)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${answers[i]['name']}',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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

/*
 {question: {type: group_single, text: How strong is your headache?, 
 items: [{id: s_1780, name: Mild,
  choices: [{id: present, label: Yes}, {id: absent, label: No}, {id: unknown, label: Don't know}]},
   {id: s_1781, name: Moderate, choices: [{id: present, label: Yes}, {id: absent, label: No}, {id: unknown, label: Don't know}]},
    {id: s_1193, name: Severe, choices: [{id: present, label: Yes}, {id: absent, label: No}, {id: unknown, label: Don't know}]}], 
    extras: {}}, conditions: [{id: c_87, name: Common cold, common_name: Common cold, probability: 0.4997},
     {id: c_121, name: Acute viral tonsillopharyngitis, common_name: Acute viral tonsillopharyngitis, probability: 0.1183}, 
     {id: c_133, name: Acute rhinosinusitis, common_name: Acute sinusitis, probability: 0.0845},
      {id: c_1118, name: Atypical pneumonia, common_name: Atypical pneumonia, probability: 0.0571}], extras: {}}*/
