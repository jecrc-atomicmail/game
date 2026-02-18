import 'package:flutter/material.dart';

enum GameMove { stone, paper, scissors }

extension GameMoveStyle on GameMove {
  String get label {
    switch (this) {
      case GameMove.stone:
        return 'Stone';
      case GameMove.paper:
        return 'Paper';
      case GameMove.scissors:
        return 'Scissors';
    }
  }

  IconData get icon {
    switch (this) {
      case GameMove.stone:
        return Icons.circle;
      case GameMove.paper:
        return Icons.description;
      case GameMove.scissors:
        return Icons.content_cut;
    }
  }

  Color get accentColor {
    switch (this) {
      case GameMove.stone:
        return const Color(0xFF7DF9FF);
      case GameMove.paper:
        return const Color(0xFF5B6BFF);
      case GameMove.scissors:
        return const Color(0xFFF96EB6);
    }
  }

  GameMove nextRandom() {
    final values = GameMove.values;
    final candidate = (values..shuffle()).first;
    return candidate == this ? values[(values.indexOf(candidate) + 1) % values.length] : candidate;
  }
}
