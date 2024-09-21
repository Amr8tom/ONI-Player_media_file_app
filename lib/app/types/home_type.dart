import 'package:flutter/cupertino.dart';

enum HomeMenuType { refresh, settings }

extension HomeMenuItem on HomeMenuType {
  Icon get icon {
    switch (this) {
      case HomeMenuType.refresh:
        return const Icon(CupertinoIcons.refresh, size: 18);
      case HomeMenuType.settings:
        return const Icon(CupertinoIcons.settings, size: 18);
    }
  }

  String get title {
    switch (this) {
      case HomeMenuType.refresh:
        return "Refresh";
      case HomeMenuType.settings:
        return "Settings";
    }
  }
}
