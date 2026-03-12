import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';

Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

Future<void> syncOfflineRequests() async {
  final requests = await DBHelper.getUnsyncedRequests();
  final token = await getAuthToken();

  for (var req in requests) {
    try {
      final url = req['url'];
      final dynamic rawPayload = jsonDecode(req['payload']);

      // Safely cast as Map<String, dynamic> if possible
      final Map<String, dynamic> payload = rawPayload is Map
          ? Map<String, dynamic>.from(rawPayload)
          : {"data": rawPayload}; // fallback for List type

      final isMultipart = req['is_multipart'] == 1;
      final imagePaths =
          List<String>.from(jsonDecode(req['image_paths'] ?? '[]'));
      final supporting_image =
          List<String>.from(jsonDecode(req['supporting_image'] ?? '[]'));

      if (isMultipart) {
        final request = http.MultipartRequest('POST', Uri.parse(url));

        // Only add primitive types as fields
        payload.forEach((key, value) {
          if (value is String || value is num || value is bool) {
            request.fields[key] = value.toString();
          } else {
            request.fields[key] = jsonEncode(value);
          }
        });

        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        for (int i = 0; i < imagePaths.length; i++) {
          final path = imagePaths[i];
          request.files
              .add(await http.MultipartFile.fromPath('image${i + 1}', path));
        }

        if (supporting_image.isNotEmpty && supporting_image[0].isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath(
            'supporting_image',
            supporting_image[0],
          ));
        }

        final response = await request.send();
        final respStr = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          await DBHelper.markRequestAsSynced(req['id']);
          await DBHelper.deleteRequest(req['id']);
          log('✅ Synced Multipart: $respStr');
        } else {
          log('❌ Error [${response.statusCode}]: $respStr');

          if (response.statusCode == 400) {
            return await DBHelper.deleteRequest(req['id']);
          }
        }
      } else {
        // Send JSON payload directly
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200) {
          await DBHelper.markRequestAsSynced(req['id']);
          await DBHelper.deleteRequest(req['id']);
          log('✅ Synced JSON: ${response.body}');
        } else {
          log('❌ Error JSON: ${response.statusCode} => ${response.body}');
        }
      }
    } catch (e) {
      log('❌ Sync Error [${req['id']}]: $e');
    }
  }
}
