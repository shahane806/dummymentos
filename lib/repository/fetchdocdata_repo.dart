import 'dart:convert';
import 'package:scanningapp/models/document_model.dart';
import 'package:http/http.dart' as http;

import '../constants/Apiconst.dart';

class FetchdocdataRepo {
  int totalPages = 1;
  int totalRecords = 0;
  Future<List<DocumentModel>> fetchdocsData(
      String state,
      String section,
      String district,
      String taluka,
      String docsformat,
      String docstype,
      int page,
      int limit) async {
    final response = await http
        .post(Uri.parse(Apiconst.Uri + "documents/GetDocument.php"), body: {
      "state": state,
      "section": section,
      "district": district,
      "taluka": taluka,
      "docsformat": docsformat,
      "docstype": docstype,
      "page": '$page',
      "limit": '$limit'
    });

    print("response body ${response.body}");

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);

        if (jsonData['data'] == null || jsonData['data']['records'] == null) {
          return [];
        }
        totalPages = jsonData['data']['totalPages'] ?? 1;
        totalRecords = jsonData['data']['totalRecords'] ?? 0;
      
        final List<dynamic> documentList = jsonData['data']['records'];

        print(documentList);

        return documentList
            .map((data) => DocumentModel.fromJson(data))
            .toList();
      } catch (e) {
        print("Error : $e");
        return [];
      }
    } else {
      return [];
    }
  }
}
