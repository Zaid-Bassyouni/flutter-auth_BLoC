import 'package:flutter/widgets.dart';
import '../components/login_bear_animator.dart';

enum BearReactionType { lookAround, handsUp }

class BearFocusManager {
  final LoginBearAnimatorController controller;
  final Map<FocusNode, BearReactionType> focusMap = {};

  BearFocusManager({required this.controller});

  void register(FocusNode node, BearReactionType type) {
    focusMap[node] = type;

    node.addListener(() {
      if (node.hasFocus) {
        _triggerReaction(type);
      } else {
        controller.goIdle?.call();
      }
    });
  }

  void _triggerReaction(BearReactionType type) {
    switch (type) {
      case BearReactionType.lookAround:
        controller.lookAround?.call();
        break;
      case BearReactionType.handsUp:
        controller.handsUp?.call();
        break;
    }
  }

  void dispose() {
    focusMap.keys.forEach((node) => node.dispose());
    focusMap.clear();
  }
}
