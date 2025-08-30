import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';

class LoginBearAnimator extends StatefulWidget {
  const LoginBearAnimator({super.key, required this.controller});

  final LoginBearAnimatorController controller;

  @override
  State<LoginBearAnimator> createState() => _LoginBearAnimatorState();
}

class LoginBearAnimatorController {
  void Function()? lookAround;
  void Function()? handsUp;
  void Function(String)? moveEyes;
  void Function(bool success)? reactToLogin;
  void Function()? goIdle;
}

class _LoginBearAnimatorState extends State<LoginBearAnimator> {
  late final String animationPath = 'lib/animations/Bear_animation_login_screen.riv';
  Artboard? artboard;
  StateMachineController? stateMachineController;

  SMITrigger? successTrigger;
  SMITrigger? failTrigger;
  SMIBool? isHandsUp;
  SMIBool? isChecking;
  SMINumber? lookNum;
  SMIBool? showHands;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();

    widget.controller.lookAround = lookAround;
    widget.controller.handsUp = handsUpOnEyes;
    widget.controller.moveEyes = moveEyes;
    widget.controller.reactToLogin = reactToLogin;

    widget.controller.goIdle = () {
      isChecking?.change(false);
      isHandsUp?.change(false);
      showHands?.change(false);
    };
  }

  void _loadRiveFile() async {
    final data = await rootBundle.load(animationPath);
    final file = RiveFile.import(data);

    final art = file.mainArtboard;
    final ctrl = StateMachineController.fromArtboard(art, 'Login Machine');
    if (ctrl != null) {
      art.addController(ctrl);
      stateMachineController = ctrl;

      for (final input in stateMachineController!.inputs) {
        switch (input.name) {
          case 'isChecking':
            isChecking = input as SMIBool;
            break;
          case 'isHandsUp':
            isHandsUp = input as SMIBool;
            break;
          case 'trigSuccess':
            successTrigger = input as SMITrigger;
            break;
          case 'trigFail':
            failTrigger = input as SMITrigger;
            break;
          case 'numLook':
            lookNum = input as SMINumber;
            break;
          case 'showHands':
            showHands = input as SMIBool;
            break;
        }
      }
      setState(() => artboard = art);
    }
  }

  void lookAround() {
    showHands?.change(false);
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(String value) {
    lookNum?.change(value.length.toDouble());
  }

  void handsUpOnEyes() {
    showHands?.change(true);
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void reactToLogin(bool success) {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (success) {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
    setState(() {});
  }

  //build method.
  @override
  Widget build(BuildContext context) {
    return artboard != null ? SizedBox(width: 280, height: 280, child: Rive(artboard: artboard!)) : const SizedBox.shrink();
  }
}
