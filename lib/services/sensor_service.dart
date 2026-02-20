import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltAction { correct, skip }

/// State machine for tilt detection.
/// neutral -> tilted (action emitted) -> wait for angular velocity to drop -> neutral
enum _TiltState { neutral, tilted }

class SensorService {
  StreamSubscription<GyroscopeEvent>? _subscription;
  final StreamController<TiltAction> _tiltController =
      StreamController<TiltAction>.broadcast();

  DateTime? _lastTiltTime;

  // Cooldown increased to 1200ms for more deliberate actions
  static const int _cooldownMs = 1200;

  // Threshold raised: require more deliberate movement (was 2.5)
  static const double _angularThreshold = 3.5;

  // Neutral zone: angular velocity must drop below this before next tilt accepted
  static const double _neutralThreshold = 1.0;

  _TiltState _tiltState = _TiltState.neutral;

  Stream<TiltAction> get tiltStream => _tiltController.stream;

  void startListening() {
    _tiltState = _TiltState.neutral;
    _subscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      final now = DateTime.now();

      // If currently in "tilted" state, wait for return to neutral
      if (_tiltState == _TiltState.tilted) {
        if (event.y.abs() < _neutralThreshold) {
          _tiltState = _TiltState.neutral;
        }
        return; // Don't process any tilt while not neutral
      }

      // Cooldown check
      if (_lastTiltTime != null &&
          now.difference(_lastTiltTime!).inMilliseconds < _cooldownMs) {
        return;
      }

      // En paysage (landscapeLeft), telephone sur le front :
      // event.y negatif = tete penche AVANT (ecran vers sol) = CORRECT
      // event.y positif = tete penche ARRIERE (ecran vers ciel) = SKIP
      if (event.y < -_angularThreshold) {
        _tiltController.add(TiltAction.correct);
        _lastTiltTime = now;
        _tiltState = _TiltState.tilted;
      } else if (event.y > _angularThreshold) {
        _tiltController.add(TiltAction.skip);
        _lastTiltTime = now;
        _tiltState = _TiltState.tilted;
      }
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _tiltState = _TiltState.neutral;
  }

  void dispose() {
    _tiltController.close();
  }
}
