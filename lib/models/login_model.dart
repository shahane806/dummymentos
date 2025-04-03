class LoginModel {
  final int? status;
  final String? email;

  const LoginModel({this.status, this.email});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'email': email,
    };
  }
}
