import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/domain/models/folder.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';

class FolderItem extends GetView<FoldersController> {
  final Folder folder;
  const FolderItem(this.folder, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Opacity(
        opacity: !controller.isAllVideoPlayed(folder) ? 1 : 0.7,
        child: Text(
          folder.name,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: AppTheme.textColorLight,
          ),
        ),
      ),
      subtitle: Opacity(
        opacity: !controller.isAllVideoPlayed(folder) ? 1 : 0.7,
        child: Text(
          "${folder.count} videos",
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            color: AppTheme.textColor,
          ),
        ),
      ),
      dense: true,
      enableFeedback: true,
      horizontalTitleGap: 10,
      leading: Stack(
        children: [
          Icon(
            Icons.folder,
            size: 60,
            color: AppTheme.primaryColor,
          ),
          // badeg
          if (!controller.isAllVideoPlayed(folder))
            Positioned(
              top: 5,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 15,
                  minHeight: 15,
                ),
                child: Text(
                  "${controller.getUnwatchedVideos(folder)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onTap: () {
        controller.selectFolder(folder);
      },
    );
  }
}
