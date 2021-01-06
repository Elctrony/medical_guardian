import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_guardian/Screens/Login/components/background.dart';
import 'package:medical_guardian/Screens/Signup/signup_screen.dart';
import 'package:medical_guardian/components/already_have_an_account_acheck.dart';
import 'package:medical_guardian/components/rounded_button.dart';
import 'package:medical_guardian/components/rounded_input_field.dart';
import 'package:medical_guardian/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_guardian/model/userData.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  String _email = '';
  String _pass = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                _email = value;
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _pass = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                final user = (await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _email, password: _pass))
                    .user;
                final document = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                final userData = document.data();
                final provider =
                    Provider.of<UserProvider>(context, listen: false);
                provider.setUser = PatientUser(
                    id: user.uid,
                    name: userData['name'],
                    email: userData['email'],
                    age: userData['age'],
                    gender: userData['gender'],
                    mobile: userData['phone']);
                print(userData.containsKey('cholesterol'));
                if (!(userData.containsKey('cholesterol') &&
                    userData.containsKey('height') &&
                    userData.containsKey('injuried') &&
                    userData.containsKey('overweight') &&
                    userData.containsKey('smoke') &&
                    userData.containsKey('weight'))) {
                  print('loss in data');
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/medical', (route) => false);
                } else {
                  provider.setHeight = userData['height'];
                  provider.setWeight = userData['weight'];
                  provider.setIsOverweight = userData['overweight'];
                  provider.setIsSmoker = userData['smoke'];
                  provider.setHasInjuried = userData['injuried'];
                  provider.setHighCholesterol = userData['cholesterol'];
                  provider.setHasHypertension = userData['hypertension'];
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/home', (route) => false);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
