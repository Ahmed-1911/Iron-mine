class LoginResponse {
  String? id;
  String? role;
  dynamic email;
  String? name;
  String? firstName;
  String? lastName;
  String? phone;
  dynamic photo;
  dynamic orgPrivileges;
  dynamic orgName;
  dynamic orgNameEn;
  dynamic orgId;
  dynamic orgImageUrl;
  dynamic orgType;
  dynamic depName;
  String? accessToken;
  String? message;

  LoginResponse({
    this.id,
    this.role,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
    this.phone,
    this.photo,
    this.orgPrivileges,
    this.orgName,
    this.orgNameEn,
    this.orgId,
    this.orgImageUrl,
    this.orgType,
    this.depName,
    this.accessToken,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    id: json["id"],
    role: json["role"],
    email: json["email"],
    name: json["name"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phone: json["phone"],
    photo: json["photo"],
    orgPrivileges: json["orgPrivileges"],
    orgName: json["orgName"],
    orgNameEn: json["orgNameEn"],
    orgId: json["orgId"],
    orgImageUrl: json["orgImageUrl"],
    orgType: json["orgType"],
    depName: json["depName"],
    accessToken: json["access_token"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "email": email,
    "name": name,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    "photo": photo,
    "orgPrivileges": orgPrivileges,
    "orgName": orgName,
    "orgNameEn": orgNameEn,
    "orgId": orgId,
    "orgImageUrl": orgImageUrl,
    "orgType": orgType,
    "depName": depName,
    "access_token": accessToken,
    "message": message,
  };
}