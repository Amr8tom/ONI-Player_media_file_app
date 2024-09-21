import 'package:flutter/material.dart';
import 'package:oniplayer/app/config/app_constants.dart';
import 'package:oniplayer/app/config/app_theme.dart';

class OniPlayerBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final Function? onTap;
  final double size;
  final bool border;
  final bool noBg;
  final double radius;
  final String? text;

  const OniPlayerBtn({
    super.key,
    required this.icon,
    this.active = false,
    this.text,
    this.size = 25,
    this.onTap,
    this.border = false,
    this.noBg = false,
    this.radius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: noBg
                ? Colors.transparent
                : active
                    ? AppTheme.primaryColorDark.withOpacity(0.9)
                    : Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(radius),
            // white border
            border: border
                ? Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  )
                : null,
            // glow when active
            boxShadow: [
              if (active)
                BoxShadow(
                  color: AppTheme.primaryColorDark.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
            ],
          ),
          child: Stack(
            children: [
              Icon(
                icon,
                size: size,
                color: text != null
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.7),
              ),
              text != null
                  ? Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          text!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: size * 0.7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          )),
    );
  }
}
