import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:oniplayer/data/repositories/sql_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CachedThumbnail extends StatefulWidget {
  final String path;
  const CachedThumbnail({super.key, required this.path});

  @override
  State<CachedThumbnail> createState() => _CachedThumbnailState();
}

class _CachedThumbnailState extends State<CachedThumbnail>
    with AutomaticKeepAliveClientMixin {
  late Stream<Uint8List?> _thumbnail;

  @override
  void initState() {
    super.initState();
    _thumbnail = _getThumbnail();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: _thumbnail,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: snapshot.data == null ? 0 : 1,
            child: Image.memory(
              snapshot.data as Uint8List,
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  /* -------------------------------------------------------------------------- */
  /*                                GET THUMBNAIL                               */
  /* -------------------------------------------------------------------------- */

  Stream<Uint8List?> _getThumbnail() async* {
    try {
      // get the thumbnail
      var thum = await SqlStorageImpl.to.getThumbnailCache(widget.path);
      if (thum != null) {
        yield thum;
      } else {
        Uint8List? thumnail = await VideoThumbnail.thumbnailData(
          video: widget.path,
          imageFormat: ImageFormat.JPEG,
          quality: 60,
        );
        // cache it
        if (thumnail != null) {
          SqlStorageImpl.to.setThumbnailCache(widget.path, thumnail);
          yield thumnail;
        } else {
          yield null;
        }
      }
    } catch (e) {
      // printRed(e);
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      yield null;
    }
  }
}
