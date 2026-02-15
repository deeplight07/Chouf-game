import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';

enum TiltAction { correct, skip }

class SensorService {
  StreamSubscription<GyroscopeEvent>? _subscription;
  final StreamController<TiltAction> _tiltController = 
      StreamController<TiltAction>.broadcast();
  
  DateTime? _lastTiltTime;
  static const int _cooldownMs = 800;
  
  // Seuil de vitesse angulaire (rad/s) - à calibrer
  static const double _angularThreshold = 2.5;

  Stream<TiltAction> get tiltStream => _tiltController.stream;

  void startListening() {
    _subscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      final now = DateTime.now();
      if (_lastTiltTime != null && 
          now.difference(_lastTiltTime!).inMilliseconds < _cooldownMs) {
        return;
      }
      
      // En paysage, le téléphone sur le front:
      // event.x = rotation avant/arrière de la tête (pitch)
      // Valeur positive = tête penche AVANT (vers sol) = CORRECT
      // Valeur négative = tête penche ARRIÈRE (vers ciel) = SKIP
      
      if (event.x > _angularThreshold) {
        _tiltController.add(TiltAction.correct);  // Tilt vers SOL
        _lastTiltTime = now;
      } else if (event.x < -_angularThreshold) {
        _tiltController.add(TiltAction.skip);     // Tilt vers CIEL
        _lastTiltTime = now;
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }
  
  void dispose() {
    _tiltController.close();
  }
}
