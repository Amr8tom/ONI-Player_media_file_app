import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/services/ad_manager.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';
import 'package:oniplayer/presentation/pages/folder/folder_item.dart';
import 'package:oniplayer/presentation/widgets/appbar.dart';
import 'package:oniplayer/presentation/widgets/drawer.dart';

class FoldersPage extends GetView<FoldersController> {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Storage",
      ),
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            return await controller.fetchVideos();
          },
          child: Column(
            children: [
              if (controller.played.length > 5)
                AdManager.to.getNativeBannerAd(),
              controller.byFolders.isEmpty && controller.done.value
                  ? const Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Center(
                          child: Text(
                        "No videos found",
                        style: TextStyle(color: AppTheme.textColor),
                      )),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: controller.byFolders.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final folder = controller.byFolders[index];
                            return FolderItem(folder);
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
