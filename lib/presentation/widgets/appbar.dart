import 'package:flutter/material.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';

AppBar buildAppBar({
  required String title,
  Widget? leading,
}) {
  return AppBar(
    backgroundColor: AppTheme.backgroundColorLight,
    titleSpacing: 0,
    shape: const Border(bottom: BorderSide(color: Colors.white10, width: 1)),
    elevation: 4,
    title: Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppTheme.textColorLight,
        fontWeight: FontWeight.w300,
      ),
    ),
    leading: leading ??
        Builder(builder: (context) {
          return IconButton(
            icon: Utils.getIcon(
              "menu",
              color: Colors.white,
              format: "png",
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.refresh,
          color: AppTheme.textColorLight,
        ),
        onPressed: () {
          FoldersController.to.fetchVideos();
        },
      )
    ],
  );
}
