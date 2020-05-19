import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {

  Widget buildCupertinoWidget(BuildContext context);
  Widget buildMaterialWIdget(BuildContext context);
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return buildCupertinoWidget(context);
    } else {
      return buildMaterialWIdget(context);
    }
  }
}
