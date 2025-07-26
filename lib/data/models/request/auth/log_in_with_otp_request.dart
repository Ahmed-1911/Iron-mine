class LogInWithOtpRequest {
  String phone;
  String password;
  String otp;

  LogInWithOtpRequest({
    required this.phone,
    required this.password,
    required this.otp,
  });

  toJson() => {
        "phone": phone,
        "password": password,
        "otp": otp,
      };
}
