
import 'package:audioplayers/audioplayers.dart';
import 'package:logging/logging.dart';

class AudioService {
  // Separate players so ding/buzz/timeup never conflict
  final AudioPlayer _dingPlayer = AudioPlayer();
  final AudioPlayer _buzzPlayer = AudioPlayer();
  final AudioPlayer _timeUpPlayer = AudioPlayer();
  final Logger _log = Logger('AudioService');

  AudioService() {
    _dingPlayer.setPlayerMode(PlayerMode.lowLatency);
    _buzzPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  /// Fire-and-forget: caller should NOT await this.
  void playDing() {
    _dingPlayer.stop().then((_) {
      _dingPlayer.play(AssetSource('audio/ding.mp3'));
    }).catchError((e) {
      _log.severe('Error playing ding sound', e);
    });
  }

  /// Fire-and-forget: caller should NOT await this.
  void playBuzz() {
    _buzzPlayer.stop().then((_) {
      _buzzPlayer.play(AssetSource('audio/buzz.mp3'));
    }).catchError((e) {
      _log.severe('Error playing buzz sound', e);
    });
  }

  /// Fire-and-forget for time-up.
  void playTimeUp() {
    _timeUpPlayer.play(AssetSource('audio/time_up.mp3')).catchError((e) {
      _log.severe('Error playing time_up sound', e);
    });
  }

  void dispose() {
    _dingPlayer.dispose();
    _buzzPlayer.dispose();
    _timeUpPlayer.dispose();
  }
}
