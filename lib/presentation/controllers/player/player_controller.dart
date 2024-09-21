import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fraction/fraction.dart' as fraction;
import 'package:get/get.dart';
import 'package:getter/getter.dart';
// import 'package:helpers/helpers/print.dart';
import 'package:oniplayer/app/services/ad_manager.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/domain/models/stream_source.dart';
import 'package:oniplayer/domain/models/local_source.dart';
import 'package:oniplayer/domain/repositories/player_repo.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock/wakelock.dart';

List<BoxFit> videoFit = [
  BoxFit.contain,
  BoxFit.cover,
  BoxFit.fill,
];

List<int> videoSpeeds = [
  1,
  2,
  3,
];

// todo: uncomment
// class PlayerController extends GetxController with PlayerRepository {
class PlayerController extends GetxController {
  late BetterPlayerController better;
  final floating = Floating();
  final double seekSensi = 0.004;
  GlobalKey betterPlayerKey = GlobalKey(); // for PIP

  bool isNightMode = false;
  bool isControlsVisible = true;
  Timer? timer;
  bool isSeeking = false;
  bool guestureSeeking = false;
  bool volumeChanging = false;
  bool brightnessChanging = false;
  double brightness = 0;
  bool isMuted = false;
  double volume = 0;
  double tmpVolume = 0;
  Duration progress = Duration.zero; //for smooth seek
  bool isPipAvailable = false;
  bool isFromIntent = false;
  bool exitingFade = false;
  bool openerFade = true;
  Orientation orientation = Orientation.portrait;

  @override
  void onInit() {
    Wakelock.enable();
    VolumeController().showSystemUI = false;
    VolumeController().listener(((p0) {
      if (!volumeChanging) {
        if (isMuted && p0 > 0) {
          isMuted = false;
          update(["quick-options"]);
        }
        volume = p0;
        update(["volume"]);
      }
    }));
    ScreenBrightness().onCurrentBrightnessChanged.listen((value) => {
          if (!brightnessChanging) {brightness = value}
        });
    super.onInit();
    better = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        fit: BoxFit.fill,
        eventListener: listener,
        autoDispose: false,
        controlsConfiguration: controlsConfiguration(),
      ),
    );
    floating.isPipAvailable.then((value) => isPipAvailable = value);
  }

  void exitFromPlayer() async {
    // if (exitingFade) return;
    // exitingFade = true;
    // update(["exiting"]);
    better.pause();
    // await Future.delayed(const Duration(milliseconds: 150));
    if (isFromIntent) {
      await AdManager.to.showFacebookInterstitialAd();
      disposeAll();
      SystemNavigator.pop();
    } else {
      // printRed("exit from player");
      await Utils.enableLandscapMode(false);
      Get.back();
    }
  }

  void setProgress(Duration value) {
    progress = value;
    update(["progress", "seek-duration"]);
    seek(value);
  }

  @override
  bool isVideoInitialized() {
    return better.isVideoInitialized() == true;
  }

  void toggleControls({bool? show}) {
    isControlsVisible = show ?? !isControlsVisible;
    resetTimer();
    update(["controls", "center-controls"]);
  }

  void resetTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 3), () {
      if (isPlaying() && !isSeeking) {
        isControlsVisible = false;
        update(["controls", "center-controls"]);
      }
    });
  }

  onVolumeUpdate(double value) {
    if (!volumeChanging) volumeChanging = true;
    volume = value;
    VolumeController().setVolume(volume);
    if (isMuted) {
      isMuted = false;
      update(["quick-options"]);
    }
    update(["volume"]);
  }

  onVolumeUpdateDone() {
    volumeChanging = false;
    update(["volume"]);
  }

  onBrightnessUpdate(double value) {
    if (!brightnessChanging) brightnessChanging = true;
    brightness = value;
    ScreenBrightness().setScreenBrightness(brightness);
    update(["brightness"]);
  }

  onBrightnessUpdateDone() {
    brightnessChanging = false;
    update(["brightness"]);
  }

  @override
  double aspectRatio() {
    if (!isVideoInitialized()) return 9 / 16;
    return better.videoPlayerController!.value.aspectRatio;
  }

  @override
  Duration duration() {
    if (!isVideoInitialized()) return Duration.zero;
    return better.videoPlayerController!.value.duration as Duration;
  }

  @override
  BoxFit getFit() {
    if (!isVideoInitialized()) return BoxFit.contain;
    return better.getAspectRatio() as BoxFit;
  }

  @override
  double getSpeed() {
    if (!isVideoInitialized()) return 1;
    return better.videoPlayerController!.value.speed;
  }

  @override
  bool isLooping() {
    if (!isVideoInitialized()) return false;
    return better.videoPlayerController!.value.isLooping;
  }

  @override
  bool isPlaying() {
    if (!isVideoInitialized()) return false;
    return better.videoPlayerController!.value.isPlaying;
  }

  @override
  Duration position() {
    if (!isVideoInitialized()) return Duration.zero;
    return better.videoPlayerController!.value.position;
  }

  @override
  void pause() async {
    if (!isVideoInitialized()) return;
    better.pause();
    update(["center-controls"]);
    resetTimer();
  }

  @override
  void play() async {
    if (!isVideoInitialized()) return;
    better.play();
    update(["center-controls"]);
    resetTimer();
  }

  @override
  void seek(Duration duration) async {
    if (!isVideoInitialized()) return;
    better.seekTo(duration);
    resetTimer();
  }

  @override
  void seek10s() async {
    if (!isVideoInitialized()) return;
    better.seekTo(better.videoPlayerController!.value.position +
        const Duration(seconds: 10));
    resetTimer();
  }

  @override
  void seek10sBack() async {
    if (!isVideoInitialized()) return;
    better.seekTo(better.videoPlayerController!.value.position -
        const Duration(seconds: 10));
    resetTimer();
  }

  @override
  void toggleFit() {
    if (!isVideoInitialized()) return;
    better.setOverriddenFit(
        videoFit[(videoFit.indexOf(better.getFit()) + 1) % videoFit.length]);
    update(['player-view']);
    resetTimer();
  }

  @override
  Future<void> setDataSource(
      {StreamSource? streamObject, LocalSource? localSource}) async {
    if (streamObject != null) {
      Utils.enableLandscapMode(true);
      better.setupDataSource(
        BetterPlayerDataSource(
          BetterPlayerDataSourceType.network,
          streamObject.url,
          headers: streamObject.headers,
        ),
      );
    } else if (localSource != null) {
      // printGreen(localSource.orientation);
      Utils.enableLandscapMode(
          localSource.orientation == Orientation.landscape ||
              localSource.orientation == Orientation);
      orientation = localSource.orientation;
      better.setupDataSource(BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        localSource.path,
      ));
    }
  }

  @override
  Future<void> setFit(BoxFit fit) async {
    if (!isVideoInitialized()) return;
    better.setOverriddenFit(fit);
    resetTimer();
  }

  @override
  void togglePIP() async {
    if (!isVideoInitialized()) return;
    var frac = fraction.Fraction.fromDouble(aspectRatio());

    /// todo : fix this and then uncomment
    // if (isPipAvailable) {
    //   await floating.enable(Rational(
    //     frac.numerator,
    //     frac.denominator,
    //   ));
    //   update(["pip"]);
    // }
  }

  @override
  Future<void> toggleSpeeds() async {
    if (!isVideoInitialized()) return;
    var speed = videoSpeeds[
        (videoSpeeds.indexOf(getSpeed().toInt()) + 1) % videoSpeeds.length];
    better.videoPlayerController!.setSpeed(speed.toDouble());
    resetTimer();
    update(["quick-options"]);
  }

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> togglePlay() async {
    if (!isVideoInitialized()) return;
    isPlaying() ? pause() : play();
  }

  /* -------------------------------------------------------------------------- */
  /*                               event listener                               */
  /* -------------------------------------------------------------------------- */
  @override
  void listener(BetterPlayerEvent eventListener) async {
    switch (eventListener.betterPlayerEventType) {
      case BetterPlayerEventType.initialized:
        openerFade = false;
        update(["opening"]);
        if (aspectRatio() > 1.5 && orientation == Orientation.landscape) {
          Utils.enableLandscapMode(true);
        }
        better.setOverriddenAspectRatio(aspectRatio());
        better.setSpeed(1);
        resetTimer();
        update(["player"]);
        break;
      case BetterPlayerEventType.progress:
        update(["progress"]);
        break;
      case BetterPlayerEventType.bufferingStart:
        update(["buffering", "center-controls"]);
        break;
      case BetterPlayerEventType.bufferingEnd:
        update(["buffering", "center-controls"]);
        break;

      case BetterPlayerEventType.finished:
        try {
          if (await floating.pipStatus == PiPStatus.enabled) {
            better.pause();
          } else {
            exitFromPlayer();
          }
        } catch (e) {
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          exitFromPlayer();
        }
        break;
      case BetterPlayerEventType.exception:
        // printOrange("[✨]exception  ${isBuffering()}");
        better.retryDataSource();
        update(["buffering"]);
        break;
      default:
    }
  }

  @override
  BetterPlayerControlsConfiguration controlsConfiguration() {
    return const BetterPlayerControlsConfiguration(
      playerTheme: BetterPlayerTheme.custom,
    );
  }

  @override
  bool isBuffering() {
    if (!isVideoInitialized()) return true;
    return better.videoPlayerController!.value.isBuffering;
  }

  @override
  void toggleLoop() {
    if (!isVideoInitialized()) return;
    isLooping() ? better.setLooping(false) : better.setLooping(true);
    update(["quick-options"]);
  }

  @override
  void toggleMute() {
    if (!isVideoInitialized()) return;
    resetTimer();
    if (isMuted) {
      VolumeController().setVolume(tmpVolume);
    } else {
      tmpVolume = volume;
      VolumeController().muteVolume();
    }
    isMuted = !isMuted;
    update(["quick-options"]);
  }

  @override
  void toggleNightMode() {
    isNightMode = !isNightMode;
    update(["quick-options", "night-mode"]);
  }

  void rotate() {
    if (orientation == Orientation.landscape) {
      Utils.enableLandscapMode(false);
      orientation = Orientation.portrait;
    } else {
      Utils.enableLandscapMode(true);
      orientation = Orientation.landscape;
    }
    update(["player"]);
  }

  @override
  void onClose() {
    disposeAll();
    super.onClose();
  }

  void disposeAll() async {
    await Utils.enableLandscapMode(false);
    better.removeEventsListener(listener);
    await better.videoPlayerController?.dispose();
    better.dispose();
    VolumeController().removeListener();
    await ScreenBrightness().resetScreenBrightness();
    await Wakelock.disable();
    // todo: uncomment
    // floating.dispose();
  }
}
