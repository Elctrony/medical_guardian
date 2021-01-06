import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_guardian/components/rounded_button.dart';
import 'package:medical_guardian/model/userData.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final listItem = {
    'image': 'assets/images/doctor.png',
    'name': 'Dr. Mustafa Bugdady',
    'specilist': 'Manyka',
    'date': DateFormat.yMd().format(DateTime.now()),
  };
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final patient = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Medical Guardian"),
      ),
      body: Container(
        width: size.width,
        height: size.height / 1.1,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(patient.id)
                .collection('appointments')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length + 2,
                itemBuilder: (ctx, i) {
                  if (i == 0) {
                    return SizedBox(
                      height: 250,
                      child: PageView(
                        children: [
                          Container(
                            width: size.width,
                            height: size.height / 3.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 12),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      width: 0.6, color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width / 2.156,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Feeling unwell?',
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'You can check your health here!',
                                              style: TextStyle(fontSize: 18)),
                                          RoundedButton(
                                            text: "Diagnosis me",
                                            press: () {
                                              Navigator.of(context)
                                                  .pushNamed('/diagnosis');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width / 2.2,
                                      child: Image.asset(
                                        'assets/images/dig.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: size.height / 3.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 12),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      width: 0.6, color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width / 2.156,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Wanna Meet Doctor?',
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'You can book appointments here!',
                                              style: TextStyle(fontSize: 18)),
                                          RoundedButton(
                                            text: "Book Appointment",
                                            press: () {
                                              Navigator.of(context)
                                                  .pushNamed('/appointments');
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width / 2.2,
                                      child: Image.asset(
                                        'assets/images/consulting.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: size.height / 3.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 12),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      width: 0.6, color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: size.width / 2.156,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Consulate Doctor?',
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'You can chat with doctors here!',
                                              style: TextStyle(fontSize: 18)),
                                          RoundedButton(
                                            text: "Ask Doctor",
                                            press: () {},
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width / 2.2,
                                      child: Image.asset(
                                        'assets/images/chatting.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final documents = snapshot.data.docs;
                  if (documents.length < 1) {
                    return Column(
                      children: [
                        Image.asset(
                          'assets/images/empty.png',
                          width: size.width,
                        ),
                        Text('There is no pervious Reservations')
                      ],
                    );
                  }
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(width: 0.6, color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        onTap: () {},
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(documents[i + 1].data()['image']),
                        ),
                        title: Text(documents[i + 1].data()['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(documents[i + 1].data()['specilist']),
                            Text(documents[i + 1].data()['date'])
                          ],
                        ),
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
