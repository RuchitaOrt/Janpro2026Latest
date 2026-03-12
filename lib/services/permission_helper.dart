import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  /// Requests a permission and returns true if granted
  static Future<bool> requestPermission(Permission permission) async {
    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      return true; // already granted
    } else if (status.isDenied || status.isLimited) {
      status = await permission.request();
      return status.isGranted;
    } else if (status.isPermanentlyDenied) {
      // Open app settings
      await openAppSettings();
      return false;
    }
    return false;
  }
}
