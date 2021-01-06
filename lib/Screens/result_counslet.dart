import 'package:flutter/material.dart';
import 'package:medical_guardian/components/rounded_button.dart';
import 'package:medical_guardian/model/infermedica_api.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultConsultation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settings = ModalRoute.of(context).settings.arguments as Map;
    final listConditations = settings['respone']['conditions'] as List;
    final evidence = settings['evidence'] as List;
    return Scaffold(
      appBar: AppBar(
        title: Text('Final Result'),
      ),
      body: FutureBuilder<Map>(
          future: Infermedica.suggestDoctor(evidence),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                  child: CircularPercentIndicator(
                radius: 20,
              ));

            final specialist = snapshot.data['recommended_specialist']['name'];
            final channel = snapshot.data['recommended_channel'];

            return SizedBox(
              width: size.width,
              height: size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.builder(
                  itemCount: listConditations.length + 1,
                  itemBuilder: (ctx, index) {
                    if (index == 0)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                      width: 0.5, color: Colors.grey)),
                              elevation: 3.5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/consulting.png',
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(
                                      width: size.width,
                                      child: Text(
                                        'Recommendation:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 20),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Consulting a $specialist within 24 hours',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    RoundedButton(
                                      text: "Book an Appointment",
                                      press: () {
                                        Navigator.of(context)
                                            .pushNamed('/diagnosis');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              margin: EdgeInsets.all(12),
                            ),
                          ),
                          Text(
                            'Results:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 8,
                          )
                        ],
                      );
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(width: 1.0, color: Colors.grey)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 5, color: Colors.black),
                              borderRadius: BorderRadius.circular(25)),
                          leading: CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            percent: listConditations[index - 1]['probability'],
                            center: new Text(
                                "${((listConditations[index - 1]['probability'] as double) * 100).round()}%"),
                            progressColor: (listConditations[index - 1]
                                        ['probability'] as double) >
                                    0.60
                                ? Colors.red
                                : (listConditations[index - 1]['probability']
                                            as double) >
                                        0.20
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                          title: Text(
                              '${listConditations[index - 1]['common_name']}'),
                          subtitle: (listConditations[index - 1]['probability']
                                      as double) >
                                  0.60
                              ? Text('Strong Evidences')
                              : (listConditations[index - 1]['probability']
                                          as double) >
                                      0.2
                                  ? Text('Moderate Evidences')
                                  : Text('Weak Evidences'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
/*
 conditions: [{id: c_55, name: Tension-type headaches, common_name: Tension-type headaches, probability: 0.4405}, {id: c_33, name: Influenza, common_name: Flu, probability: 0.3383}, {id: c_72, name: Acute bronchitis, common_name: Acute bronchitis, probability: 0.2796}, {id: c_269, name: Chronic sinusitis, common_name: Chronic sinusitis, probability: 0.2568}, {id: c_666, name: Nonallergic noninfectious rhinitis, common_name: Nonallergic noninfectious rhinitis, probability: 0.1298}, {id: c_810, name: Nasal septum deviation, common_name: Nasal septum deviation, probability: 0.1144}, {id: c_1118, name: Atypical pneumonia, common_name: Atypical pneumonia, probability: 0.0924},
  {id: c_127, name: Pneumonia, common_name: Pneumonia, probability: 0.0755}], extras: {}, should_stop: true}*/
