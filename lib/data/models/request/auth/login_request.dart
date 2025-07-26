class LoginRequest {
  String password;
  String phone;

  LoginRequest({
    required this.phone,
    required this.password,
  });

  toJson() => {
        "password": password,
        "phone": phone,
      };
}
