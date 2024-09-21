import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/presentation/controllers/player/player_controller.dart';

class BrightnessVolumeBars extends GetView<PlayerController> {
  const BrightnessVolumeBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Row(
          children: [
            GetBuilder<PlayerController>(
              id: "volume",
              builder: (_) {
                // is landscape mode
                bool isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                return AnimatedOpacity(
                  opacity: controller.volumeChanging ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.size.width * 0.14,
                      ),
                      SeekBar(
                        height: isLandscape
                            ? Get.size.height * 0.4
                            : Get.size.height * 0.2,
                        width: 15,
                        position: 66,
                        icon: Icons.volume_up_rounded,
                        lowIcon: Icons.volume_mute_rounded,
                        volume: controller.volume,
                        color: Colors.redAccent,
                        type: SeekType.volume,
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
            GetBuilder<PlayerController>(
              id: "brightness",
              builder: (_) {
                bool isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                return AnimatedOpacity(
                  opacity: controller.brightnessChanging ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.size.width * 0.14,
                      ),
                      SeekBar(
                        height: isLandscape
                            ? Get.size.height * 0.4
                            : Get.size.height * 0.2,
                        width: 15,
                        position: 66,
                        icon: Icons.brightness_high_rounded,
                        lowIcon: Icons.brightness_low_rounded,
                        brightness: controller.brightness,
                        color: const Color(0xFFFFC916),
                        type: SeekType.brightness,
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

enum SeekType { brightness, volume }

class SeekBar extends StatelessWidget {
  final double height;
  final double width;
  final double position;
  final Color color;
  final IconData icon;
  final IconData lowIcon;
  final SeekType type;
  final double volume;
  final double brightness;

  const SeekBar({
    super.key,
    required this.height,
    required this.width,
    required this.position,
    required this.icon,
    required this.type,
    required this.color,
    this.volume = 0,
    this.brightness = 0,
    required this.lowIcon,
  });

  @override
  Widget build(BuildContext context) {
    var currentVal =
        ((type == SeekType.volume ? volume : brightness) * 15).toInt();
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$currentVal",
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Container(
                  // height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: LayoutBuilder(builder: (_, constrains) {
                    var height = constrains.maxHeight;
                    var n = type == SeekType.volume ? volume : brightness;
                    var position = n * height;

                    return CustomPaint(
                      painter: _SeekBarPainter(
                        position: position,
                        width: width,
                        height: height,
                        color: color,
                        bgColor: Colors.grey,
                        // icon: icon,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 5),
              Icon(currentVal == 0 ? lowIcon : icon, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeekBarPainter extends CustomPainter {
  final double position;
  final double width;
  final double height;
  final Color color;
  final Color bgColor;
  // final Icon icon;

  _SeekBarPainter({
    required this.position,
    required this.width,
    required this.height,
    required this.color,
    this.bgColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBg(canvas);
    _drawFill(canvas);
  }

  _drawBg(Canvas canvas) {
    final paint = Paint()..color = bgColor;
    var radius = const Radius.circular(4);
    var rrect = RRect.fromLTRBR(0, 0, width, height, radius);
    canvas.drawRRect(rrect, paint);
  }

  _drawFill(Canvas canvas) {
    final paint = Paint()..color = color;
    var radius = const Radius.circular(4);
    var rrect = RRect.fromLTRBR(0, height - position, width, height, radius);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
