import 'package:flutter/material.dart';
import 'package:flutter_user_agentx/flutter_user_agent.dart';
import 'package:get/get.dart';
import 'package:oniplayer/data/repositories/sql_storage.dart';
import 'package:oniplayer/domain/models/stream.dart';

class StreamController extends GetxController {
  //
  static StreamController get to => Get.find<StreamController>();
  var urlController = TextEditingController();
  var nameController = TextEditingController();
  var headersControls = <HeadersControlsModel>[].obs;
  var streams = <StreamModel>[].obs;
  var editing = -1;
  var userAgent = "";
  var isNameEmpty = true.obs;
  var isUrlEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    SqlStorageImpl.to.getStreams().then((value) {
      streams.assignAll(value);
    });
    FlutterUserAgent.getPropertyAsync('userAgent').then((agent) {
      userAgent = agent;
      addDeviceUserAgent();
    });

    urlController.addListener(() {
      isUrlEmpty.value = urlController.text.isEmpty;
    });
    nameController.addListener(() {
      isNameEmpty.value = nameController.text.isEmpty;
    });
  }

  bool get allowSave => !isNameEmpty.value && !isUrlEmpty.value;

  void editStream(int index) {
    // edit stream\
    editing = index;
    final stream = streams[index];
    urlController.text = stream.url;
    nameController.text = stream.name;
    headersControls.clear();
    headersControls.addAll(stream.headers.entries.map((e) {
      return HeadersControlsModel(
        keyController: TextEditingController(text: e.key),
        valueController: TextEditingController(text: e.value),
      );
    }).toList());
  }

  void removeStream(int index) {
    // remove stream
    SqlStorageImpl.to.deleteStream(streams[index]);
    streams.removeAt(index);
  }

  void addNewHeader() {
    headersControls.insert(
      0,
      HeadersControlsModel(
        keyController: TextEditingController(),
        valueController: TextEditingController(),
      ),
    );
  }

  void removeHeader(int index) {
    headersControls.removeAt(index);
  }

  void saveStream() {
    // save stream
    String url = urlController.text;
    String name = nameController.text;
    Map<String, String> headers = headersControls
        .map((e) => HeadersModel(
              key: e.keyController.text,
              value: e.valueController.text,
            ))
        .toList()
        .asMap()
        .map((key, value) => MapEntry(key.toString(), value.toMap()))
        .values
        .fold(
            {},
            (previousValue, element) => {
                  ...element,
                  ...previousValue,
                });

    final newStream = StreamModel(name: name, url: url, headers: headers);
    if (editing != -1) {
      // edit stream
      SqlStorageImpl.to.updateStream(streams[editing], newStream);
      streams[editing] = newStream;
    } else {
      streams.add(newStream);
      SqlStorageImpl.to.addStream(newStream);
    }
    cleanup();
    Get.back();
  }

  // clear all controllers
  void cleanup() {
    urlController.clear();
    nameController.clear();
    for (var element in headersControls) {
      element.keyController.dispose();
      element.valueController.dispose();
    }
    headersControls.clear();
    editing = -1;
    addDeviceUserAgent();
  }

  void addDeviceUserAgent() {
    headersControls.add(
      HeadersControlsModel(
        keyController: TextEditingController(text: "User-Agent"),
        valueController: TextEditingController(text: userAgent),
      ),
    );
  }
}

//
class HeadersControlsModel {
  final TextEditingController keyController;
  final TextEditingController valueController;

  HeadersControlsModel({
    required this.keyController,
    required this.valueController,
  });
}

class HeadersModel {
  final String key;
  final String value;

  HeadersModel({
    required this.key,
    required this.value,
  });

  Map<String, String> toMap() => {
        key: value,
      };
}
