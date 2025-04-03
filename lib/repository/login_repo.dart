import 'dart:convert';
import 'package:scanningapp/constants/Apiconst.dart';
import 'package:scanningapp/models/login_model.dart';
import 'package:http/http.dart' as http;

class LoginRepo {
  Future<LoginModel> authentication(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Apiconst.Uri + "auth/login.php"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      print("Swami");
      if (response.statusCode == 200) {
        print("login response: ${response.body}");
        final data = json.decode(response.body);
        return LoginModel.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception("Login failed: ${errorData['message']}");
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
