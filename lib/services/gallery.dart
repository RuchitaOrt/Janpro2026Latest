import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestGalleryPermission() async {
  if (Platform.isAndroid) {
    // Android 13+
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      return true;
    }

    // Try requesting
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }

  if (Platform.isIOS) {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  return false;
}
