
import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

enum TiltAction { correct, skip }

class SensorService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  final StreamController<TiltAction> _tiltController = StreamController<TiltAction>.broadcast();
  
  DateTime? _lastTiltTime;
  static const int _cooldownMs = 1000;
  static const double _threshold = 7.0; // User specified 7.0

  Stream<TiltAction> get tiltStream => _tiltController.stream;

  void startListening() {
    _subscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final now = DateTime.now();
      if (_lastTiltTime != null && now.difference(_lastTiltTime!).inMilliseconds < _cooldownMs) {
        return;
      }
      
      // event.x > 7.0 => Tilted UP (Skip)
      // event.x < -7.0 => Tilted DOWN (Correct)
      
      if (event.x > _threshold) {
        _tiltController.add(TiltAction.skip);
        _lastTiltTime = now;
      } else if (event.x < -_threshold) {
        _tiltController.add(TiltAction.correct);
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
