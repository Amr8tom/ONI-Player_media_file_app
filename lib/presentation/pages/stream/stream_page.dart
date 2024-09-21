import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/services/ad_manager.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/domain/models/stream_source.dart';
import 'package:oniplayer/presentation/controllers/stream/stream.controller.dart';
import 'package:oniplayer/presentation/pages/router.dart';
import 'package:oniplayer/presentation/widgets/appbar.dart';
import 'package:oniplayer/presentation/widgets/drawer.dart';

class StreamPage extends GetView<StreamController> {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "Streams",
      ),
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
      body: Obx(
        () => controller.streams.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Utils.getIcon(
                        "icon_drafnew_rect",
                        color: AppTheme.primaryColor,
                        format: "png",
                        width: 80,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Add new stream",
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    color: AppTheme.textColorLight.withOpacity(0.2),
                  );
                },
                itemCount: controller.streams.length,
                itemBuilder: (context, index) {
                  final stream = controller.streams[index];
                  return ListTile(
                    title: Text(stream.name),
                    // style: ,
                    leading: Utils.getIcon(
                      "help_video_title_icon",
                      format: "png",
                      color: AppTheme.primaryColor,
                      width: 40,
                    ),
                    subtitle: Text(
                      stream.url,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 20, top: 10, bottom: 10),

                    trailing: SizedBox(
                      width: 60,
                      height: double.infinity,
                      child: PopupMenuButton(
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: AppTheme.dangerColor,
                                ),
                              ),
                            ),
                          ];
                        },
                        iconSize: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side:
                              const BorderSide(color: Colors.white10, width: 1),
                        ),
                        position: PopupMenuPosition.under,
                        tooltip: "more",
                        color: AppTheme.backgroundColorLight,
                        onSelected: (value) {
                          if (value == "edit") {
                            controller.editStream(index);
                            Get.toNamed(Routes.addStream);
                          } else if (value == "delete") {
                            controller.removeStream(index);
                          }
                        },
                      ),
                    ),
                    onTap: () async {
                      // play stream
                      Get.toNamed(Routes.player,
                              arguments: StreamSource(
                                url: stream.url,
                                name: stream.name,
                                headers: stream.headers,
                              ))!
                          .then((value) {
                        // show ads
                      });
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.addStream);
          },
          highlightElevation: 0,
          hoverColor: Colors.transparent,
          heroTag: "add_stream",
          elevation: 0,
          backgroundColor: AppTheme.primaryColor,
          // rounded rect shapre
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          )),
    );
  }
}
