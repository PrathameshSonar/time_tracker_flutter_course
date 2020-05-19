import 'package:flutter/cupertino.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color color,
    Color textColor,
    double width,
    VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          color: color,
          height: 100.0,
          width: 100.0,
          onPressed: onPressed,
          borderRadius: 30.0,
        );
}
