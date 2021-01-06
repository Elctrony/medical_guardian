import 'package:flutter/material.dart';

class PatientUser {
  String id;
  String name;
  String email;
  String mobile;
  int age;
  String gender;
  bool isOverweight;
  bool isSmoker;
  bool hasInjuried;
  bool highCholesterol;
  bool hasHypertension;
  double height;
  double weight;
  PatientUser({
    @required this.id,
    this.name,
    this.email,
    this.mobile,
    this.age,
    this.gender,
    this.isOverweight,
    this.isSmoker,
    this.hasInjuried,
    this.highCholesterol,
    this.hasHypertension,
    this.height,
    this.weight,
  });
}

class UserProvider with ChangeNotifier {
  PatientUser _user;

  PatientUser get getUser => _user;

  set setUser(PatientUser user) => this._user = user;

  String get getName => _user.name;

  set setName(String name) => this._user.name = name;

  String get getEmail => _user.email;

  set setEmail(String email) => this._user.email = email;

  String get getMobile => _user.mobile;

  set setMobile(String mobile) => this._user.mobile = mobile;

  int get getAge => _user.age;

  set setAge(int age) => this._user.age = age;

  String get getGender => _user.gender;

  set setGender(String gender) => this._user.gender = gender;

  bool get getIsOverweight => _user.isOverweight;

  set setIsOverweight(bool isOverweight) =>
      this._user.isOverweight = isOverweight;

  bool get getIsSmoker => _user.isSmoker;

  set setIsSmoker(bool isSmoker) => this._user.isSmoker = isSmoker;

  bool get getHasInjuried => _user.hasInjuried;

  set setHasInjuried(bool hasInjuried) => this._user.hasInjuried = hasInjuried;

  bool get getHighCholesterol => _user.highCholesterol;

  set setHighCholesterol(bool highCholesterol) =>
      this._user.highCholesterol = highCholesterol;

  bool get getHasHypertension => _user.hasHypertension;

  set setHasHypertension(bool hasHypertension) =>
      this._user.hasHypertension = hasHypertension;

  double get getHeight => _user.height;

  set setHeight(double height) => this._user.height = height;

  double get getWeight => _user.weight;

  set setWeight(double weight) => this._user.weight = weight;
}
