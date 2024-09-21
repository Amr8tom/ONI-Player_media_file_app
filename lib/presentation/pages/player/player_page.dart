import 'package:better_player/better_player.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/core/sliders.dart';
import 'package:oniplayer/domain/models/local_source.dart';
import 'package:oniplayer/domain/models/stream_source.dart';
import 'package:oniplayer/presentation/controllers/player/player_controller.dart';
import 'package:oniplayer/presentation/pages/player/player.ui.dart';

class PlayerPage extends GetView<PlayerController> {
  final dynamic args;
  final bool fronIntent;

  const PlayerPage({super.key, this.args, this.fronIntent = false});

  Widget justVideo() {
    return Scaffold(
      body: BetterPlayer(
        controller: controller.better,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerMedia = args ?? Get.arguments;
    controller.isFromIntent = fronIntent;
    if (playerMedia is StreamSource) {
      controller.setDataSource(streamObject: playerMedia);
    } else if (playerMedia is LocalSource) {
      controller.setDataSource(localSource: playerMedia);
    }

    return PiPSwitcher(
      childWhenEnabled: Scaffold(
        body: GetBuilder<PlayerController>(
          id: "pip",
          builder: (_) {
            return Stack(
              children: [
                // BetterPlayer(
                //   controller: controller.better,
                // ),
                controller.betterPlayerKey.currentWidget != null
                    ? controller.betterPlayerKey.currentWidget!
                    : Container(),
                Positioned.fill(
                  child: Container(
                    child: PlayerUI.buildNightFilter(),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    child: PlayerUI.buildBufferWidget(),
                  ),
                ),
                // if (controller.isVideoInitialized()) PlayerUI.buildBufferWidget(),ss
              ],
            );
          },
        ),
      ),
      childWhenDisabled: WillPopScope(
        onWillPop: () async {
          controller.exitFromPlayer();
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: GetBuilder<PlayerController>(
              id: "player",
              builder: (_) {
                var inited = controller.isVideoInitialized();
                return Stack(
                  children: [
                    GetBuilder<PlayerController>(
                        id: "player-view",
                        builder: (context) {
                          return BetterPlayer(
                            key: controller.betterPlayerKey,
                            controller: controller.better,
                          );
                        }),
                    _buildAnimatedOpeningFade(),
                    if (!inited)
                      PlayerUI.buildInitialLoader(
                        controller: controller,
                        showText: playerMedia is StreamSource,
                      ),
                    if (inited) PlayerUI.buildNightFilter(),
                    if (inited && playerMedia is StreamSource)
                      PlayerUI.buildBufferWidget(),
                    if (inited) const BrightnessVolumeBars(),
                    if (inited) PlayerUI.buildPlayerGestures(controller),
                    if (inited) PlayerUI.buildCenterButtons(),
                    if (inited)
                      GetBuilder<PlayerController>(
                          id: "controls",
                          builder: (_) {
                            return IgnorePointer(
                              ignoring: !controller.isControlsVisible,
                              child: AnimatedOpacity(
                                opacity: controller.isControlsVisible ? 1 : 0,
                                duration: const Duration(milliseconds: 100),
                                child: PlayerUI.buildControls(
                                    controller, playerMedia.name),
                              ),
                            );
                          }),
                    // _buildAnimatedExitingFade(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildAnimatedOpeningFade() {
    return GetBuilder<PlayerController>(
      id: "opening",
      builder: (_) {
        return IgnorePointer(
          child: AnimatedOpacity(
              opacity: controller.openerFade ? 1 : 0,
              duration: const Duration(milliseconds: 1500),
              child: Container(
                color: Colors.black,
              )),
        );
      },
    );
  }
}
