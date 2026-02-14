
import 'package:audioplayers/audioplayers.dart';
import 'package:logging/logging.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final Logger _log = Logger('AudioService');

  // Preload sounds during initialization? Not strictly necessary with modern players but good for latency.
  
  Future<void> playDing() async {
    try {
      await _player.play(AssetSource('audio/ding.mp3'), mode: PlayerMode.lowLatency);
    } catch (e) {
      _log.severe('Error playing ding sound', e);
    }
  }

  Future<void> playBuzz() async {
    try {
      await _player.play(AssetSource('audio/buzz.mp3'), mode: PlayerMode.lowLatency);
    } catch (e) {
      _log.severe('Error playing buzz sound', e);
    }
  }
  
  Future<void> playTimeUp() async {
    try {
       await _player.play(AssetSource('audio/time_up.mp3'));
    } catch (e) {
      _log.severe('Error playing game over sound', e);
    }
  }
}
