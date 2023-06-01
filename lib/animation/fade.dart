import 'dart:async';

import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  const MyAnimation({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<MyAnimation> createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  double turns = 0;
  double scale = 1;
  Duration duration = const Duration(milliseconds: 750);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedScale(
          scale: scale,
          duration: duration,
          child: AnimatedRotation(
            turns: turns,
            duration: duration,
            curve: Curves.easeInOut,
            child: InkWell(
              onTap: () async {
                await rotate();
              },
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> rotate() async {
    setState(() {
      turns = 0.5;
      scale = 10;
      print(' first $turns');
    });
    await Future.delayed(duration);
    setState(() {
      turns = 0;
      scale = 1;
      print(' second $turns');
    });
  }
}

class CustomScale extends StatefulWidget {
  const CustomScale({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<CustomScale> createState() => _CustomScaleState();
}

class _CustomScaleState extends State<CustomScale> {
  double scale = 1;
  Duration duration = const Duration(milliseconds: 750);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedScale(
          scale: scale,
          duration: duration,
          child: InkWell(
            onTap: () async {
              await scaleWidget();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Future<void> scaleWidget() async {
    setState(() {
      scale = 10;
    });
    await Future.delayed(duration);
    setState(() {
      scale = 1;
    });
  }
}

class CustomRotate extends StatefulWidget {
  const CustomRotate({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<CustomRotate> createState() => _CustomRotateState();
}

class _CustomRotateState extends State<CustomRotate> {
  double turns = 0;
  Duration duration = const Duration(milliseconds: 750);

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: duration,
      child: InkWell(
        onTap: () async {
          await rotate();
        },
        child: widget.child,
      ),
    );
  }

  Future<void> rotate() async {
    setState(() {
      turns = 1;
    });
    await Future.delayed(duration);
    setState(() {
      turns = 0;
    });
  }
}
