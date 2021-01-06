import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import 'package:medical_guardian/model/userData.dart';
import 'package:provider/provider.dart';

class BookAppoinment extends StatefulWidget {
  @override
  _BookAppoinmentState createState() => _BookAppoinmentState();
}

class _BookAppoinmentState extends State<BookAppoinment> {
  final weekDay = {
    1: 'Saturday',
    2: 'Sunday',
    3: 'Monday',
    4: 'Tuesday',
    5: 'Wednesday',
    6: 'Thursday',
    7: 'Friday',
  };

  Map selectedDate = {};

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    final patient = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(title: Text('Book Appointment')),
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('doctors').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            final data = snapshot.data.docs;
            return _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.count(
                    crossAxisCount: 2,
                    children: data
                        .map<Widget>(
                          (e) => Card(
                            color: Colors.white,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(e.data()['img']),
                                    radius: 30,
                                  ),
                                  Text(
                                    '${e.data()['name']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${e.data()['specialist']}',
                                  ),
                                  StarRating(
                                    rating: e.data()['rate'],
                                    starConfig: StarConfig(
                                      size: 22,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 28),
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        final appointment =
                                            await showDialog<Map>(
                                          context: context,
                                          child: AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              title: Text(
                                                  'Select appropriate time'),
                                              content: SizedBox(
                                                width: double.minPositive,
                                                height: size.height / 4,
                                                child: ListView.builder(
                                                  itemBuilder: (ctx, index) =>
                                                      ListTile(
                                                    onTap: () {
                                                      selectedDate =
                                                          (e.data()['info']
                                                              as List)[index];
                                                      Navigator.of(context)
                                                          .pop(selectedDate);
                                                    },
                                                    title: Text(
                                                        '${getDate((e.data()['info'] as List)[index])}'),
                                                  ),
                                                  itemCount:
                                                      (e.data()['info'] as List)
                                                          .length,
                                                ),
                                              )),
                                        );
                                        List evidences = [];
                                        List condiations = [];
                                        if (arguments != null) {
                                          evidences = arguments['evidences'];
                                          condiations =
                                              arguments['condiations'];
                                        }
                                        final document = {
                                          'patientId': patient.id,
                                          'patientName': patient.name,
                                          'patientGender': patient.gender,
                                          'patientPhone': patient.mobile,
                                          'evidence': evidences,
                                          'condiations': condiations,
                                          'date': selectedDate['day'],
                                        };
                                        _loading = true;
                                        await FirebaseFirestore.instance
                                            .collection('doctors')
                                            .doc(e.id)
                                            .collection('appointments')
                                            .add(document);
                                        print(appointment);
                                      },
                                      child: Text('Appointment'),
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      color: Colors.blue.withOpacity(0.75),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        )
                        .toList(),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 12,
                  );
          }),
    );
  }

  String getDate(Map date) {
    return weekDay[date['day']] + ',  ${date['start']} : ${date['end']}';
  }
}
