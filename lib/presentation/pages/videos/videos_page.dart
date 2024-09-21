import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/domain/models/local_source.dart';
import 'package:oniplayer/presentation/controllers/local/folders_controller.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:oniplayer/presentation/widgets/appbar.dart';
import 'package:oniplayer/presentation/widgets/drawer.dart';
import 'package:oniplayer/presentation/widgets/thumbnail_preview.dart';

class VideosPage extends GetView<FoldersController> {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: controller.current.value.name,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppTheme.primaryColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.current.value.media.length,
          physics: const BouncingScrollPhysics(),
          addAutomaticKeepAlives: true,
          itemBuilder: (context, index) {
            final video = controller.current.value.media[index];
            return ListTile(
              title: Text(
                video.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColorLight,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    video.size.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GetBuilder<FoldersController>(
                    id: "new-tag",
                    builder: (_) {
                      return controller.isNew(video)
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "NEW",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.textColorLight,
                                  fontSize: 11,
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  )
                ],
              ),
              // dense: true,
              enableFeedback: true,
              horizontalTitleGap: 10,

              leading: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      //  all borders
                      border: Border.all(
                        color: Colors.white24,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Hero(
                        tag: "folder_${video.path}",
                        child: CachedThumbnail(
                          key: ValueKey(video.path),
                          path: video.path.path,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColorLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video!.duration!.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                // play
                Get.toNamed(Routes.player,
                        arguments: LocalSource(
                            path: video.path.path,
                            orientation: Orientation.landscape))!
                    .then((value) {
                  controller.addToPlayed(video.path.path);
                });
              },
            );
          },
        ),
      ),
    );
  }
}
