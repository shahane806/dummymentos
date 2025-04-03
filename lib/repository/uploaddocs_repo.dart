import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/Apiconst.dart';

class UploaddocsRepo {
  Future<void> uploadDocsToApi(
    String section,
    String district,
    String taluka,
    String docformat,
    String docId,
    String doctype,
    PlatformFile documentFile,
    String? remarked,
    String? password,
    String state,
  ) async {
    final url = Uri.parse(Apiconst.Uri + "documents/SetDocument.php");

    var request = http.MultipartRequest('POST', url)
      ..fields['section'] = section
      ..fields['district'] = district
      ..fields['taluka'] = taluka
      ..fields['docsformat'] = docformat
      ..fields['docId'] = docId
      ..fields['docstype'] = doctype
      ..files.add(
        await http.MultipartFile.fromPath(
            'document', documentFile.path.toString()),
      )
      ..fields['remarked'] = remarked.toString()
      ..fields['password'] = password.toString()
      ..fields['state'] = state;

    var response = await request.send();
    var responseStream = await response.stream.bytesToString();
    debugPrint("Response Body: $responseStream");
    print("response ${response}");
    if (response.statusCode == 200) {
      print("response ${response}");
    } else {
      throw Exception(
          "Failed to upload image. Status code: ${response.statusCode}");
    }
  }
}
