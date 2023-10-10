import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subspace/Screens/blog_screen.dart';
class spalsh_screen extends StatefulWidget {
  const spalsh_screen({super.key});

  @override
  State<spalsh_screen> createState() => _spalsh_screenState();
}

class _spalsh_screenState extends State<spalsh_screen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(_fadeInPageRoute())
    );
  }
  PageRouteBuilder _fadeInPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlogScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        var tween = Tween(begin: begin, end: end);
        var opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(image: AssetImage("Images/logo1.png"),width: 300,),
      ),
    );
  }
}
