import 'package:flutter/material.dart';

class Ders {
  String? dersName = "";
  int? dersCredit = 0;
  double? dersGrade = 0.0;
  double? takdirDersGrade = 0.0;
  TextEditingController? dersCreditController = TextEditingController();
  TextEditingController? TakdirDersGradeController = TextEditingController();

  Ders(
      {this.dersName,
        this.dersCredit,
        this.dersGrade,
        this.takdirDersGrade,
        this.dersCreditController,
        this.TakdirDersGradeController});
}
