import 'package:flutter/material.dart';
import 'dart:async';

class AnimationCon{
  bool animat = false;
  var context;
  AnimationCon(this.context);
  ani(ani){
    animat = ani;
  }
  scaled(delaySecond, durationSecond, child){
    delaySecond == 0? delaySecond = 0.001: delaySecond = delaySecond;
    Timer(Duration(seconds: delaySecond), () => ani(true));
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      transform: (Matrix4.identity()
        ..translate(MediaQuery.of(context).size.width/100, 0)
        ..scale(0.9, 0.9)
      ),
      child: child
    );
  }
}