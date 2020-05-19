import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.child,
    this.color,
    this.borderRadius: 40.0,
    this.height: 50.0,
    this.width,
    this.onPressed,
  });

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final double width;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:height,
      width:width,
      child: RaisedButton(
        child: child,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
