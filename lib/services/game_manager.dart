
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vibration/vibration.dart';

import '../models/category_model.dart';
import '../models/game_session.dart';
import '../services/sensor_service.dart';
import '../services/audio_service.dart';

enum GameStatus { ready, playing, paused, finished }

class GameManager extends ChangeNotifier {
  final SensorService _sensorService;
  final AudioService _audioService;
  
  GameSession? _currentSession;
  Timer? _gameTimer;
  StreamSubscription? _tiltSubscription;
  int _timeLeft = 60;
  GameStatus _status = GameStatus.ready;
  
  // Current word display
  String _currentWord = "";
  
  // For avoiding double skips/corrects
  bool _isProcessingTilt = false;

  GameManager(this._sensorService, this._audioService);

  int get timeLeft => _timeLeft;
  GameStatus get status => _status;
  GameSession? get session => _currentSession;
  String get currentWord => _currentWord;
  int get score => _currentSession?.score ?? 0;

  void prepareGame(CategoryModel category) {
    _currentSession = GameSession(category: category);
    _timeLeft = 60;
    _status = GameStatus.ready;
    _currentSession!.category.words.shuffle();
    _nextWord(); // Setup first word
    notifyListeners();
  }

  void startGame() {
    if (_status != GameStatus.ready && _status != GameStatus.paused) return;

    _status = GameStatus.playing;
    WakelockPlus.enable();
    
    // Start Sensor
    _sensorService.startListening();
    _tiltSubscription?.cancel();
    _tiltSubscription = _sensorService.tiltStream.listen(_handleTilt);
    
    // Start Timer
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        endGame();
      }
    });

    notifyListeners();
  }

  void _nextWord() {
    if (_currentSession == null) return;
    
    int usedCount = _currentSession!.results.length;
    if (usedCount < _currentSession!.category.words.length) {
      _currentWord = _currentSession!.category.words[usedCount];
    } else {
      endGame();
    }
    notifyListeners();
  }

  void _handleTilt(TiltAction action) async {
    if (_status != GameStatus.playing || _isProcessingTilt) return;
    
    _isProcessingTilt = true;
    
    
    if (action == TiltAction.correct) {
      await _audioService.playDing();
      if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 200);
      _currentSession?.addResult(_currentWord, true);
    } else if (action == TiltAction.skip) {
      await _audioService.playBuzz();
      if (await Vibration.hasVibrator() ?? false) Vibration.vibrate(duration: 500);
      _currentSession?.addResult(_currentWord, false);
    }
    
    _nextWord();
    
    // Reset processing flag immediately as SensorService has 1000ms cooldown.
    _isProcessingTilt = false; 
    notifyListeners();
  }

  void pauseGame() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.paused;
      _gameTimer?.cancel();
      _tiltSubscription?.pause();
      _sensorService.stopListening();
      WakelockPlus.disable();
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_status == GameStatus.paused) {
      _status = GameStatus.playing;
      WakelockPlus.enable();
      _sensorService.startListening();
      _tiltSubscription?.resume();
      
      _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          _timeLeft--;
          notifyListeners();
        } else {
          endGame();
        }
      });
      notifyListeners();
    }
  }

  void endGame() {
    _status = GameStatus.finished;
    _gameTimer?.cancel();
    _tiltSubscription?.cancel();
    _sensorService.stopListening();
    WakelockPlus.disable();
    _audioService.playTimeUp();
    notifyListeners();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _tiltSubscription?.cancel();
    _sensorService.stopListening();
    WakelockPlus.disable();
    super.dispose();
  }
}
