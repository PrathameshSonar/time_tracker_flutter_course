import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
}) : super(
    child: Text(
      text,
      style: TextStyle(color: Colors.black, fontSize: 20.0),
    ),
    height: 44.0,
    color: Colors.cyan[200],
    borderRadius: 10.0,
    onPressed: onPressed,
  );
}