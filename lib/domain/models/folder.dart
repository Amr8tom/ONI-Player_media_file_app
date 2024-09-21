import 'package:getter/getter.dart';

class Folder {
  final String name;
  final List<Media> media;

  int get count => media.length;

  Folder({required this.name, required this.media});
  Folder.empty()
      : media = [],
        name = "";
}
