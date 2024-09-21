import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';
import 'package:oniplayer/app/util/util.dart';
import 'package:oniplayer/presentation/controllers/stream/stream.controller.dart';

class AddStreamPage extends GetView<StreamController> {
  const AddStreamPage({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.cleanup();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          leadingWidth: 85,
          title: const Text(
            "New Stream",
            style: TextStyle(
              color: AppTheme.textColorLight,
              fontWeight: FontWeight.w300,
            ),
          ),
          leading: TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: AppTheme.dangerColor,
                fontWeight: FontWeight.w300,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              controller.cleanup();
              Get.back();
            },
          ),
          actions: [
            Obx(() => TextButton(
                  onPressed:
                      controller.allowSave ? controller.saveStream : null,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color: controller.allowSave
                          ? AppTheme.primaryColor
                          : AppTheme.textColor.withOpacity(0.2),
                    ),
                  ),
                )),
          ],
        ),
        body: Hero(
          tag: "add-stream",
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  // input field with leading icon
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.nameController,
                    style: const TextStyle(
                        fontSize: 16, color: AppTheme.textColor),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white38),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      hintText: "Name",
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Utils.getIcon(
                          "exo_ic_play_circle",
                          // color: controller.color.value,
                          format: "png",
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: controller.urlController,
                    style: const TextStyle(
                        fontSize: 16, color: AppTheme.textColor),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white38),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.primaryColor),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      hintText: "Stream URL ",
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Utils.getIcon(
                          "exo_ic_play_circle",
                          color: AppTheme.primaryColor,
                          format: "png",
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // ColorPicker(
                  //   color: controller,
                  //   onColorChanged: (color) {
                  //     controller.setColor(color);
                  //   },
                  // ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Text(
                        "Headers",
                        style: TextStyle(
                          color: AppTheme.textColorLight,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Utils.getIcon(
                          "addd_",
                          color: AppTheme.primaryColor,
                          format: "png",
                          // width: 80,
                        ),
                        onPressed: () => controller.addNewHeader(),
                      ),
                    ],
                  ),
                  Obx(() => controller.headersControls.isEmpty
                      ? const Text(
                          "No headers added",
                          style: TextStyle(color: Colors.white60),
                        )
                      : const SizedBox()),
                  Obx(() => Column(
                        children: [
                          for (final item in controller.headersControls)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: item.keyController,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.textColor),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.url,
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                            color: Colors.white10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                        hintText: "key",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: item.valueController,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.textColor),
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.url,
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                            color: Colors.white10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppTheme.primaryColor),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        hintText: "value",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                        border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white70),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Utils.getIcon(
                                      "icon_ws_delete",
                                      color: AppTheme.dangerColor,
                                      format: "png",
                                      // width: 80,
                                    ),
                                    onPressed: () {
                                      controller.removeHeader(
                                        controller.headersControls
                                            .indexOf(item),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )),
                  // save button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
