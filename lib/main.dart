import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_guardian/Screens/add_symptom.dart';
import 'package:medical_guardian/Screens/body.dart';
import 'package:medical_guardian/Screens/group_multi_question.dart';
import 'package:medical_guardian/Screens/group_single_question.dart';
import 'package:medical_guardian/Screens/home_screen.dart';
import 'package:medical_guardian/Screens/medical_question.dart';
import 'package:medical_guardian/Screens/result_counslet.dart';
import 'package:medical_guardian/Screens/singel_question.dart';
import 'package:medical_guardian/Screens/symptomate_screen.dart';

import 'package:medical_guardian/constants.dart';
import 'package:medical_guardian/model/userData.dart';
import 'package:provider/provider.dart';

import 'Screens/Welcome/welcome_screen.dart';
import 'Screens/book_appointment.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: WelcomeScreen(),
        routes: {
          '/add_symptom': (_) => AddSymptom(),
          '/group-single': (_) => GroupSingleQuestion(),
          '/single': (_) => SingleQuestion(),
          '/group-multi': (_) => GroupMultiQuestion(),
          '/results': (_) => ResultConsultation(),
          '/diagnosis': (_) => SymptomChecker(),
          '/home': (_) => HomeScreen(),
          '/medical': (_) => MedicalQuestion(),
          '/appointments': (_) => BookAppoinment(),
        },
      ),
    );
  }
}
