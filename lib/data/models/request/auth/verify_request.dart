class VerifyRequest {
  String otp;
  String phone;

  VerifyRequest({
    required this.phone,
    required this.otp,
  });

  toJson() => {
        "otp": otp,
        "phone": phone,
      };
}
