import 'package:flutter/material.dart';


class CustomFlatButton extends StatelessWidget {
  CustomFlatButton({
    this.child,
    this.onPressed,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: child,

      onPressed: onPressed,
    );
  }
}
