import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:game/models/game_move.dart';
import 'package:game/models/game_result.dart';

final currentGameResultProvider = StateProvider<GameResult?>((ref) => null);

class OfflineGameState {
  final GameResult? lastResult;
  final int playerScore;
  final int opponentScore;
  final bool busy;

  const OfflineGameState({
    required this.lastResult,
    required this.playerScore,
    required this.opponentScore,
    required this.busy,
  });

  factory OfflineGameState.initial() => const OfflineGameState(
        lastResult: null,
        playerScore: 0,
        opponentScore: 0,
        busy: false,
      );

  OfflineGameState copyWith({
    GameResult? lastResult,
    int? playerScore,
    int? opponentScore,
    bool? busy,
  }) {
    return OfflineGameState(
      lastResult: lastResult ?? this.lastResult,
      playerScore: playerScore ?? this.playerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      busy: busy ?? this.busy,
    );
  }
}

class OfflineGameNotifier extends StateNotifier<OfflineGameState> {
  OfflineGameNotifier(this.ref) : super(OfflineGameState.initial());

  final Ref ref;
  final Random _random = Random();

  void selectMove(GameMove playerMove) {
    if (state.busy) return;
    final opponentMove = GameMove.values[_random.nextInt(GameMove.values.length)];
    final outcome = determineOutcome(playerMove, opponentMove);

    final result = GameResult(
      playerMove: playerMove,
      opponentMove: opponentMove,
      outcome: outcome,
      occurredAt: DateTime.now(),
      arena: 'Offline Arena',
    );

    state = state.copyWith(
      lastResult: result,
      playerScore: state.playerScore + (outcome == GameOutcome.win ? 1 : 0),
      opponentScore: state.opponentScore + (outcome == GameOutcome.lose ? 1 : 0),
      busy: true,
    );

    ref.read(currentGameResultProvider.notifier).state = result;

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      state = state.copyWith(busy: false);
    });
  }

}

class OnlineMatchState {
  final String lobbyStatus;
  final String opponentStatus;
  final String matchmakingNote;
  final bool connected;
  final bool busy;
  final GameResult? lastResult;

  const OnlineMatchState({
    required this.lobbyStatus,
    required this.opponentStatus,
    required this.matchmakingNote,
    required this.connected,
    required this.busy,
    required this.lastResult,
  });

  factory OnlineMatchState.initial() => const OnlineMatchState(
        lobbyStatus: 'Connecting to Supabase...',
        opponentStatus: 'Awaiting opponent',
        matchmakingNote: 'Searching for a room...',
        connected: false,
        busy: false,
        lastResult: null,
      );

  OnlineMatchState copyWith({
    String? lobbyStatus,
    String? opponentStatus,
    String? matchmakingNote,
    bool? connected,
    bool? busy,
    GameResult? lastResult,
  }) {
    return OnlineMatchState(
      lobbyStatus: lobbyStatus ?? this.lobbyStatus,
      opponentStatus: opponentStatus ?? this.opponentStatus,
      matchmakingNote: matchmakingNote ?? this.matchmakingNote,
      connected: connected ?? this.connected,
      busy: busy ?? this.busy,
      lastResult: lastResult ?? this.lastResult,
    );
  }
}

final offlineGameProvider =
    StateNotifierProvider<OfflineGameNotifier, OfflineGameState>(
        (ref) => OfflineGameNotifier(ref));

final onlineMatchProvider =
    StateNotifierProvider<OnlineMatchNotifier, OnlineMatchState>(
        (ref) => OnlineMatchNotifier(ref, Supabase.instance.client));

class OnlineMatchNotifier extends StateNotifier<OnlineMatchState> {
  OnlineMatchNotifier(this.ref, this.supabase)
      : super(OnlineMatchState.initial()) {
    _initChannel();
  }

  final Ref ref;
  final SupabaseClient supabase;
  RealtimeChannel? _channel;

  void _initChannel() {
    try {
      _channel = supabase.channel('stone-paper-match');
      _channel
          ?.on(
            RealtimeListenTypes.broadcast,
            ChannelFilter(event: 'matchmaking'),
            (payload, [ref]) {
              _handleBroadcast(payload);
            },
          )
          .subscribe();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        state = state.copyWith(
          lobbyStatus: 'Matchmaking ready',
          matchmakingNote: 'Listening for an opponent',
          connected: true,
        );
        _broadcast('match_found', {'source': 'local'});
      });
    } catch (error) {
      state = state.copyWith(
        lobbyStatus: 'Connection error',
        matchmakingNote: 'Unable to reach Supabase',
        connected: false,
      );
    }
  }

  void selectMove(GameMove move) {
    if (state.busy) return;
    final opponent = GameMove.values
        .firstWhere((value) => value != move,
            orElse: () => GameMove.values.first)
        .nextRandom();
    final outcome = determineOutcome(move, opponent);
    final result = GameResult(
      playerMove: move,
      opponentMove: opponent,
      outcome: outcome,
      occurredAt: DateTime.now(),
      arena: 'Online Clash',
    );

    state = state.copyWith(
      busy: true,
      opponentStatus: 'Result ready',
      lobbyStatus: 'Result pending confirmation',
      lastResult: result,
    );

    ref.read(currentGameResultProvider.notifier).state = result;
    _broadcast('match_result', {
      'playerMove': move.label,
      'opponentMove': opponent.label,
      'outcome': outcome.title,
      'timestamp': result.occurredAt.toIso8601String(),
      'arena': result.arena,
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      state = state.copyWith(busy: false);
    });
  }

  void _handleBroadcast(Map<String, dynamic> payload) {
    final type = payload['type']?.toString().toLowerCase();
    if (type == 'match_found') {
      state = state.copyWith(
        opponentStatus: 'Connected',
        matchmakingNote: 'Opponent nearby',
        connected: true,
      );
      return;
    }
    if (type == 'match_result') {
      final result = GameResult.fromPayload(payload);
      state = state.copyWith(
        busy: false,
        lastResult: result,
        opponentStatus: 'Result visible',
        lobbyStatus: 'Match confirmed',
      );
      ref.read(currentGameResultProvider.notifier).state = result;
    }
  }

  Future<void> _broadcast(String event, Map<String, dynamic> payload) async {
    if (_channel == null) return;
    await _channel!.send(
      type: RealtimeListenTypes.broadcast,
      event: event,
      payload: payload,
    );
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
}
