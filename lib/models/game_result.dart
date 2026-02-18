import 'package:flutter/material.dart';
import 'package:game/models/game_move.dart';

enum GameOutcome { win, lose, draw }

extension GameOutcomeExtension on GameOutcome {
  String get title {
    switch (this) {
      case GameOutcome.win:
        return 'Victory';
      case GameOutcome.lose:
        return 'Defeat';
      case GameOutcome.draw:
        return 'Draw';
    }
  }

  Color get highlight {
    switch (this) {
      case GameOutcome.win:
        return Colors.lightGreenAccent;
      case GameOutcome.lose:
        return Colors.redAccent;
      case GameOutcome.draw:
        return Colors.amberAccent;
    }
  }
}

class GameResult {
  final GameMove playerMove;
  final GameMove opponentMove;
  final GameOutcome outcome;
  final DateTime occurredAt;
  final String arena;

  const GameResult({
    required this.playerMove,
    required this.opponentMove,
    required this.outcome,
    required this.occurredAt,
    required this.arena,
  });

  String get subtitle {
    if (outcome == GameOutcome.win) {
      return 'Perfect timing! Opponent didn’t see that coming.';
    }
    if (outcome == GameOutcome.lose) {
      return 'Close call. Reset and try again.';
    }
    return 'A locked stance. Try another throw.';
  }

  factory GameResult.fromPayload(Map<String, dynamic> payload) {
    return GameResult(
      playerMove: GameMove.values.firstWhere(
          (move) => move.label.toLowerCase() == payload['playerMove']?.toString().toLowerCase(),
          orElse: () => GameMove.stone),
      opponentMove: GameMove.values.firstWhere(
          (move) => move.label.toLowerCase() == payload['opponentMove']?.toString().toLowerCase(),
          orElse: () => GameMove.paper),
      outcome: _outcomeFromString(payload['outcome']),
      occurredAt: DateTime.tryParse(payload['timestamp']?.toString() ?? '') ?? DateTime.now(),
      arena: payload['arena']?.toString() ?? 'Online Arena',
    );
  }

  static GameOutcome _outcomeFromString(String? raw) {
    if (raw == null) return GameOutcome.draw;
    switch (raw.toLowerCase()) {
      case 'win':
      case 'you win':
        return GameOutcome.win;
      case 'lose':
      case 'you lose':
        return GameOutcome.lose;
      default:
        return GameOutcome.draw;
    }
  }
}

GameOutcome determineOutcome(GameMove player, GameMove opponent) {
  if (player == opponent) return GameOutcome.draw;
  if (player == GameMove.stone && opponent == GameMove.scissors ||
      player == GameMove.paper && opponent == GameMove.stone ||
      player == GameMove.scissors && opponent == GameMove.paper) {
    return GameOutcome.win;
  }
  return GameOutcome.lose;
}
