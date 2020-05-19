import 'package:flutter/cupertino.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {

  SocialSignInButton( {
    @required String assetName,
    Color color,
    Color textColor,
    VoidCallback onPressed,
    double width,
  }) : super(
    child: Image.asset(assetName),
    color: color,
    onPressed: onPressed,
    height: 70.0,
    width: 70.0,
    borderRadius: 40.0,
  );
}
