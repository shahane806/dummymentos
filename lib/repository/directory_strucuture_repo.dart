import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:scanningapp/constants/Apiconst.dart';
import '../models/directory_docs_model.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class ApiService {
  static String baseUrl = Apiconst.Uri;
  static String logicUrl = baseUrl + 'logic.php';
  final http.Client _client = http.Client();
  CancelableOperation? _currentOperation;

  Future<List<FolderItem>> fetchFolderItems(String path) async {
    try {
      // Cancel previous operation if it exists
      _currentOperation?.cancel();

      final cleanPath =
          Uri.encodeFull(path.trim().replaceAll(RegExp(r'^/+|/+$'), ''));
      final url = Uri.parse('$logicUrl?path=$cleanPath');

      print("Fetching data from: $url");

      // Track the request using CancelableOperation
      _currentOperation = CancelableOperation.fromFuture(_client.get(url));
      final response = await _currentOperation!.value;

      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => FolderItem.fromJson(item)).toList();
        }
         return _handleErrorMessage('Invalid response format from server.');
      } else {
        return _handleError(response.statusCode);
      }
    } catch (e) {
      return _handleErrorMessage('Something went wrong. Please try again.');
    }
  }

  String getFileUrl(String fullPath) {
    return Uri.parse('$baseUrl' + '$fullPath').toString();
  }

  Future<File> downloadFile(String url, String fileName) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

List<FolderItem> _handleError(int statusCode) {
    String errorMessage;
    switch (statusCode) {
      case 403:
        errorMessage = 'Access Denied: You don\'t have permission to view this directory.';
        break;
      case 404:
        errorMessage = 'Directory not found. Please check the path.';
        break;
      case 500:
        errorMessage = 'Server error. Please try again later.';
        break;
      default:
        errorMessage = 'An unexpected error occurred. Please try again.';
    }
    return _handleErrorMessage(errorMessage);
  }

  List<FolderItem> _handleErrorMessage(String message) {
    print('Error: $message');
    throw message; // Throw only the clean message
  }
}
