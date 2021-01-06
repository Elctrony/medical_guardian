import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_guardian/Screens/Login/login_screen.dart';
import 'package:medical_guardian/Screens/Signup/components/background.dart';
import 'package:medical_guardian/Screens/Signup/components/or_divider.dart';
import 'package:medical_guardian/components/already_have_an_account_acheck.dart';
import 'package:medical_guardian/components/rounded_button.dart';
import 'package:medical_guardian/components/rounded_input_field.dart';
import 'package:medical_guardian/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_guardian/model/userData.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  bool isMale = false;
  bool isFemale = false;
  String _email = '';
  String _password = '';
  double _age = 18;
  String _name = '';
  String _phone = '';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Name",
              onChanged: (value) {
                _name = value;
              },
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                _email = value;
              },
              type: TextInputType.emailAddress,
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _password = value;
              },
            ),
            RoundedInputField(
              hintText: "Your Phone Number",
              onChanged: (value) {
                _phone = value;
              },
              icon: Icons.phone,
              type: TextInputType.phone,
            ),
            StatefulBuilder(
              builder: (ctx, setState) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      isMale = true;
                      isFemale = false;
                      setState(() {});
                    },
                    child: Chip(
                      labelPadding: EdgeInsets.all(16),
                      label: Text(
                        'Male',
                        style: TextStyle(fontSize: 18),
                      ),
                      backgroundColor:
                          !isFemale && isMale ? Colors.blue : Colors.grey,
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      isMale = false;
                      isFemale = true;
                      setState(() {});
                    },
                    child: Chip(
                      labelPadding: EdgeInsets.all(12),
                      label: Text(
                        'Female',
                        style: TextStyle(fontSize: 18),
                      ),
                      backgroundColor:
                          isFemale && !isMale ? Colors.blue : Colors.grey,
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            StatefulBuilder(builder: (ctx, setState) {
              return Slider(
                value: _age,
                min: 10,
                max: 100,
                divisions: 90,
                label: 'Age: ${_age.round().toString()}',
                onChanged: (double value) {
                  setState(() {
                    _age = value;
                  });
                },
              );
            }),
            StatefulBuilder(builder: (context, setState) {
              return _loading
                  ? CircularProgressIndicator()
                  : RoundedButton(
                      text: "SIGNUP",
                      press: () async {
                        if (_name.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Validation Error'),
                              content: Text('Name field must be completed'),
                            ),
                          );
                          return;
                        }
                        if (_email.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Validation Error'),
                              content: Text('Email field must be completed'),
                            ),
                          );
                          return;
                        } else if (_password.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Validation Error'),
                              content: Text('Password field must be completed'),
                            ),
                          );
                          return;
                        } else if ((!isMale && !isFemale)) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Validation Error'),
                              content: Text('Gender field must be completed'),
                            ),
                          );
                          return;
                        } else if (_phone.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Validation Error'),
                              content: Text('Phone field must be completed'),
                            ),
                          );
                          return;
                        }

                        setState(() => _loading = true);
                        final user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: _email, password: _password))
                            .user;
                        String gender = isMale && !isFemale ? 'male' : 'female';
                        PatientUser patient = new PatientUser(
                            id: user.uid,
                            name: _name,
                            email: _email,
                            age: _age.round(),
                            gender: gender,
                            mobile: _phone);
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser = patient;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set({
                          'name': _name,
                          'email': _email,
                          'age': _age.round(),
                          'gender': gender,
                          'phone': _phone
                        });
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/medical', (route) => false);
                      },
                    );
            }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
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
