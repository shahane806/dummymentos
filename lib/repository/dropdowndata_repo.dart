import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scanningapp/constants/Apiconst.dart';

class DropdowndataRepo {
// Section

  Future<List<String>> sectiondata() async {
    try {
      final response = await http
          .get(Uri.parse(Apiconst.Uri + "GetCategories/GetSection.php"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 200 && data['data'] is List) {
          return List<String>.from(data['data']);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching sections: $e');
    }
  }

  Future<List<String>> documentFormatsData() async {
    try {
      final response = await http
          .get(Uri.parse(Apiconst.Uri + "GetCategories/GetDocumentFormat.php"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 200 && data['data'] is List) {
          return List<String>.from(data['data']);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching sections: $e');
    }
  }

  Future<List<String>> documentTypesData() async {
    try {
      final response = await http
          .get(Uri.parse(Apiconst.Uri + "GetCategories/GetDocumentType.php"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 200 && data['data'] is List) {
          return List<String>.from(data['data']);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching sections: $e');
    }
  }

  //for state
  Future<List<String>> statedata() async {
    try {
      final response = await http
          .get(Uri.parse(Apiconst.Uri + "GetCategories/GetState.php"));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 200 && data['data'] is List) {
          return List<String>.from(data['data']);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching sections: $e');
    }
  }
// For District

  Future<List<String>> districtdata(String state) async {
    try {
      final response = await http.post(
          Uri.parse(Apiconst.Uri + "GetCategories/GetDistrict.php"),
          body: {"state": state});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['data'] != null) {
          return List<String>.from(data['data']);
        } else {
          throw Exception('No Data Found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching state: $e');
    }
  }

// For Taluka

  Future<List<String>> talukadata(String district) async {
    try {
      final response = await http.post(
          Uri.parse(Apiconst.Uri + "GetCategories/GetTaluka.php"),
          body: {"District": district});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['data'] != null) {
          return List<String>.from(data['data']);
        } else {
          throw Exception('No Data Found');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error fetching District: $e');
    }
  }
}
