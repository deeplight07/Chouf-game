import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltAction { correct, skip }

class SensorService {
  StreamSubscription<GyroscopeEvent>? _subscription;
  final StreamController<TiltAction> _tiltController =
      StreamController<TiltAction>.broadcast();

  DateTime? _lastTiltTime;
  // Cooldown augmenté à 1000ms pour éviter les faux positifs en paysage
  static const int _cooldownMs = 1000;

  // Seuil de vitesse angulaire (rad/s)
  static const double _angularThreshold = 2.5;

  Stream<TiltAction> get tiltStream => _tiltController.stream;

  void startListening() {
    _subscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      final now = DateTime.now();
      if (_lastTiltTime != null &&
          now.difference(_lastTiltTime!).inMilliseconds < _cooldownMs) {
        return;
      }

      // En paysage (landscapeLeft), téléphone sur le front :
      // Les axes du gyroscope restent dans le référentiel PORTRAIT du téléphone.
      // event.y = rotation autour de l'axe vertical portrait = pitch en paysage
      // Quand on penche la tête AVANT (écran vers sol) → event.y NÉGATIF → CORRECT
      // Quand on penche la tête ARRIÈRE (écran vers ciel) → event.y POSITIF → SKIP
      // Note : si les tilts sont inversés sur l'appareil, inverser les deux conditions.

      if (event.y < -_angularThreshold) {
        _tiltController.add(TiltAction.correct);  // Tête penche AVANT → SOL → CORRECT
        _lastTiltTime = now;
      } else if (event.y > _angularThreshold) {
        _tiltController.add(TiltAction.skip);     // Tête penche ARRIÈRE → CIEL → SKIP
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
