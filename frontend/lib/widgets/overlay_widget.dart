import 'package:flutter/material.dart';

Widget overlayChildBuilder(BuildContext ctx) {
  final baseColor = Theme.of(ctx).colorScheme.primary;

  return Container(
    height: MediaQuery.of(ctx).size.height,
    width: MediaQuery.of(ctx).size.width,
    color: Colors.black38,
    child: Center(
        child: CircularProgressIndicator(
      color: baseColor,
    )),
  );
}
