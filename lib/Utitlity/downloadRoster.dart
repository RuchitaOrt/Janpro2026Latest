import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

Future<void> downloadRoster(String url, String attendanceId) async {
  try {
    // 📂 App-specific directory
    Directory baseDir = await getApplicationDocumentsDirectory();
    String filePath = "${baseDir.path}/roster_$attendanceId.pdf";

    // 📥 Download
    Dio dio = Dio();
    await dio.download(url, filePath,
        onReceiveProgress: (received, total) {
      print("Downloading $received / $total");
    });

    print("Downloaded to: $filePath");

    // 👁 Open file
    await OpenFilex.open(filePath);
  } catch (e) {
    print("Download error: $e");
  }
}

