import 'package:better_player/better_player.dart';
import 'package:flutter/widgets.dart';
import 'package:oniplayer/domain/models/local_source.dart';
import 'package:oniplayer/domain/models/stream_source.dart';

abstract class PlayerRepository {
  // setDataSource StreamObject or String
  Future<void> setDataSource(
      {StreamSource? streamObject, LocalSource? localSource});

  //listener {dynamic Function(BetterPlayerEvent)? eventListener}
  void listener(BetterPlayerEvent eventListener);

  // initialized
  bool isVideoInitialized();
  // duration
  Duration duration();

// position
  Duration position();

  // isPlaying
  bool isPlaying();

  // isLooping
  bool isLooping();

  // get aspect ratio
  double aspectRatio();

  // get fit
  BoxFit getFit();

  // get speed
  double getSpeed();

  bool isBuffering();

  // play
  void play();

  // pause
  void pause();

  // toggle play
  void togglePlay();

  // seek
  void seek(Duration duration);

  // setVolume
  void setVolume(double volume);
  void toggleMute();
  void toggleLoop();

  // setSpeed
  void toggleSpeeds();

  // set pip
  void togglePIP();

  void toggleNightMode();

  // seek 10s
  void seek10s();

  // seek 10s
  void seek10sBack();

  // override fit
  void setFit(BoxFit fit);

  // set aspect ratio
  void toggleFit();

  // controls configuration
  BetterPlayerControlsConfiguration controlsConfiguration();
}
