import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Bouncy extends PageRouteBuilder {
  final Widget page;
  Bouncy({required this.page})
      : super(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              animation =
                  CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn);
              return ScaleTransition(
                alignment: Alignment.center,
                scale: animation,
                child: child,
              );
            });
}
