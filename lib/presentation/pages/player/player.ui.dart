import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getter/getter.dart';
import 'package:lottie/lottie.dart';
import 'package:oniplayer/app/config/app_constants.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/core/oni_button.dart';
import 'package:oniplayer/app/extensions/color.dart';
import 'package:oniplayer/presentation/controllers/player/player_controller.dart';

abstract class PlayerUI {
  static Widget buildNightFilter() {
    return Positioned.fill(
      child: IgnorePointer(
        child: GetBuilder<PlayerController>(
            id: "night-mode",
            builder: (controller) {
              return AnimatedOpacity(
                opacity: controller.isNightMode ? 1 : 0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              );
            }),
      ),
    );
  }

  static Widget buildBufferWidget() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: GetBuilder<PlayerController>(
          id: "buffering",
          builder: (controller) {
            return controller.isBuffering()
                ? Container(
                    width: Get.width,
                    height: Get.height,
                    color: Colors.black.withOpacity(0.4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          kLoadingBuffering,
                          height: 80,
                        ),
                        const Text(
                          "جاري التحميل.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }

  static Widget buildInitialLoader(
      {required bool showText, required PlayerController controller}) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(1),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(kLoading, height: 120),
              showText
                  ? Text(
                      controller.isFromIntent
                          ? ".جاري إعداد سرفر المشاهدة"
                          : "Loading Stream",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildCenterButtons() {
    return Positioned.fill(
      child: Center(
        child: GetBuilder<PlayerController>(
          id: "center-controls",
          builder: (controller) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: controller.isControlsVisible && !controller.isBuffering()
                  ? 1
                  : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OniPlayerBtn(
                    icon: Icons.replay_10_outlined,
                    onTap: controller.seek10sBack,
                  ),
                  const SizedBox(width: 15),
                  OniPlayerBtn(
                    icon: controller.isPlaying()
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    size: 44,
                    onTap: controller.togglePlay,
                  ),
                  const SizedBox(width: 15),
                  OniPlayerBtn(
                    icon: Icons.forward_10_rounded,
                    onTap: controller.seek10s,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget buildControls(PlayerController controller, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Builder(builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.3),
                    child: Text(
                      name.toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        overflow: TextOverflow.ellipsis,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 10),
              const OniPlayerBtn(
                icon: Icons.brightness_4_rounded,
                radius: 50,
                active: true,
                text: "1",
              ),
              const Spacer(),
              OniPlayerBtn(
                icon: Icons.close,
                onTap: controller.exitFromPlayer,
              ),
            ],
          ),
          const SizedBox(height: 15),
          GetBuilder<PlayerController>(
              id: "quick-options",
              builder: (_) {
                return Row(
                  children: [
                    OniPlayerBtn(
                      icon: Icons.volume_off_rounded,
                      active: controller.isMuted,
                      onTap: controller.toggleMute,
                    ),
                    const SizedBox(width: 13),
                    OniPlayerBtn(
                      icon: Icons.repeat_one_rounded,
                      active: controller.isLooping(),
                      onTap: controller.toggleLoop,
                    ),
                    const SizedBox(width: 13),
                    OniPlayerBtn(
                      icon: Icons.brightness_4_rounded,
                      active: controller.isNightMode,
                      onTap: controller.toggleNightMode,
                    ),
                    const SizedBox(width: 13),
                    OniPlayerBtn(
                      icon: Icons.brightness_4_rounded,
                      active: controller.getSpeed().toInt() != 1,
                      text: "x${controller.getSpeed().toInt()}",
                      onTap: controller.toggleSpeeds,
                    ),
                    const SizedBox(width: 13),
                    controller.isPipAvailable
                        ? OniPlayerBtn(
                            icon: Icons.picture_in_picture_alt_rounded,
                            onTap: controller.togglePIP,
                          )
                        : const SizedBox(),
                    const SizedBox(width: 13),
                    OniPlayerBtn(
                      icon: Icons.crop_rotate_rounded,
                      onTap: controller.rotate,
                    ),
                  ],
                );
              }),
          // const Spacer(),

          const Spacer(),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: controller.orientation == Orientation.landscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/onitv-w.png",
                        height: 20,
                      ),
                      Expanded(
                        child: _buildProgress(),
                      ),
                      OniPlayerBtn(
                        icon: Icons.aspect_ratio_rounded,
                        onTap: controller.toggleFit,
                        noBg: true,
                      )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _buildProgress(),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }

  static Widget _buildProgress() {
    return GetBuilder<PlayerController>(
        id: "progress",
        builder: (controller) {
          // final buffered =
          //     controller.better.videoPlayerController!.value.buffered.last.end;

          // // get the buffered percentage based on config
          // var config = controller.better.betterPlayerDataSource!
          //     .bufferingConfiguration.minBufferMs;
          // var bufferedPercentage =
          //     Duration(milliseconds: config).inSeconds / buffered.inSeconds;

          // printOrange(
          //     "bufferedPercentage: ${Duration(milliseconds: config).inSeconds}");
          // printGreen("bufferedPercentage: ${buffered.inSeconds}");

          return Row(
            children: [
              if (MediaQuery.of(Get.context!).orientation ==
                  Orientation.landscape)
                SizedBox(
                  width: 33,
                  height: 25,
                  child: VerticalDivider(
                    color: Colors.grey.withOpacity(0.5),
                    thickness: 1,
                  ),
                ),
              Text(
                FormatDuration.format(controller.position()),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              Expanded(
                child: Slider(
                  activeColor: AppTheme.primaryColorDark,
                  inactiveColor: AppTheme.primaryColorDark.withOpacity(0.3),
                  value: controller.position().inSeconds.toDouble(),
                  max: controller.duration().inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.setProgress(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                FormatDuration.format(controller.duration()),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              if (MediaQuery.of(Get.context!).orientation ==
                  Orientation.landscape)
                SizedBox(
                  width: 33,
                  height: 25,
                  child: VerticalDivider(
                    color: Colors.grey.withOpacity(0.5),
                    thickness: 1,
                  ),
                ),
            ],
          );
        });
  }

  static Widget buildPlayerGestures(PlayerController controller) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: Get.size.height,
          child: GestureDetector(
            onDoubleTap: () {
              controller.togglePlay();
            },
            onTap: () {
              controller.toggleControls();
            },
            onVerticalDragDown: (details) {},
            onVerticalDragUpdate: (details) {
              if (!controller.isVideoInitialized()) return;
              var volumeGestureUnit = 0.2;
              var stepper = 0.0666666666666667;
              double delta = details.primaryDelta as double;

              if (details.globalPosition.dx >= (Get.size.width / 2)) {
                // volume
                if (delta > 0) {
                  var vol = controller.volume - volumeGestureUnit * stepper;
                  vol = vol.clamp(0, 1);
                  controller.onVolumeUpdate(vol);
                } else {
                  var vol = controller.volume + volumeGestureUnit * stepper;
                  vol = vol.clamp(0, 1);
                  controller.onVolumeUpdate(vol);
                }
              } else {
                // brightness
                if (delta > 0) {
                  var vol = controller.brightness - volumeGestureUnit * stepper;
                  vol = vol.clamp(0, 1);
                  controller.onBrightnessUpdate(vol);
                } else {
                  var vol = controller.brightness + volumeGestureUnit * stepper;
                  vol = vol.clamp(0, 1);
                  controller.onBrightnessUpdate(vol);
                }
              }
            },
            onVerticalDragEnd: (details) {
              controller.onBrightnessUpdateDone();
              controller.onVolumeUpdateDone();
            },

            onHorizontalDragStart: (_) {},
            onHorizontalDragUpdate: (details) {},
            onHorizontalDragEnd: (details) {},

            // for debug
            // child: Container(
            //   color: Colors.green.withOpacity(0.4),
            // ),
          ),
        ),
      ),
    );
  }
}
