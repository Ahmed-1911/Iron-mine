class VerifyResponse {
  String? id;
  String? createdDate;
  String? phone;
  String? email;
  String? otp;
  String? lastNameAr;
  dynamic lastNameEn;
  String? firstNameAr;
  dynamic firstNameEn;
  String? personalIdNo;
  String? address;
  String? birthDate;
  PersonalIdPhoto? personalIdPhoto;
  String? password;
  bool? verified;
  String? roleEn;
  String? roleAr;
  String? orgType;
  String? gender;
  Photo? photo;
  dynamic fcmtoken;
  dynamic ostype;
  dynamic osVersion;
  dynamic deviceModel;
  String? fullName;
  Department? department;
  bool? status;
  String? message;

  VerifyResponse({
    this.id,
    this.createdDate,
    this.phone,
    this.email,
    this.otp,
    this.lastNameAr,
    this.lastNameEn,
    this.firstNameAr,
    this.firstNameEn,
    this.personalIdNo,
    this.address,
    this.birthDate,
    this.personalIdPhoto,
    this.password,
    this.verified,
    this.roleEn,
    this.roleAr,
    this.orgType,
    this.gender,
    this.photo,
    this.fcmtoken,
    this.ostype,
    this.osVersion,
    this.deviceModel,
    this.fullName,
    this.department,
    this.status,
    this.message,
  });

  VerifyResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = json['createdDate'];
    phone = json['phone'];
    email = json['email'];
    otp = json['otp'];
    lastNameAr = json['lastNameAr'];
    lastNameEn = json['lastNameEn'];
    firstNameAr = json['firstNameAr'];
    firstNameEn = json['firstNameEn'];
    personalIdNo = json['personalIdNo'];
    address = json['address'];
    birthDate = json['birthDate'];
    personalIdPhoto = json['personalIdPhoto'] != null
        ? PersonalIdPhoto.fromJson(json['personalIdPhoto'])
        : json['personalIdPhoto'];
    password = json['password'];
    verified = json['verified'];
    roleEn = json['roleEn'];
    roleAr = json['roleAr'];
    orgType = json['orgType'];
    gender = json['gender'];
    photo =
        json['photo'] != null ? Photo.fromJson(json['photo']) : json['photo'];
    fcmtoken = json['fcmtoken'];
    ostype = json['ostype'];
    osVersion = json['osVersion'];
    deviceModel = json['deviceModel'];
    fullName = json['fullName'];
    status = json['status'];
    message = json['message'];
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdDate'] = createdDate;
    data['phone'] = phone;
    data['email'] = email;
    data['otp'] = otp;
    data['lastNameAr'] = lastNameAr;
    data['lastNameEn'] = lastNameEn;
    data['firstNameAr'] = firstNameAr;
    data['firstNameEn'] = firstNameEn;
    data['personalIdNo'] = personalIdNo;
    data['address'] = address;
    data['birthDate'] = birthDate;
    if (personalIdPhoto != null) {
      data['personalIdPhoto'] = personalIdPhoto!.toJson();
    }
    data['password'] = password;
    data['verified'] = verified;
    data['roleEn'] = roleEn;
    data['roleAr'] = roleAr;
    data['orgType'] = orgType;
    data['gender'] = gender;
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    data['fcmtoken'] = fcmtoken;
    data['ostype'] = ostype;
    data['osVersion'] = osVersion;
    data['deviceModel'] = deviceModel;
    data['status'] = status;
    data['message'] = message;
    data['fullName'] = fullName;
    if (department != null) {
      data['department'] = department!.toJson();
    }
    return data;
  }
}

class Photo {
  String? name;
  String? path;

  Photo({this.name, this.path});

  Photo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    return data;
  }
}

class PersonalIdPhoto {
  String? name;
  String? path;

  PersonalIdPhoto({this.name, this.path});

  PersonalIdPhoto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    return data;
  }
}

class Department {
  String? id;
  String? createdDate;
  String? nameEn;
  String? nameAr;
  Organization? organization;

  Department(
      {this.id, this.createdDate, this.nameEn, this.nameAr, this.organization});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = json['createdDate'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    organization = json['organization'] != null
        ? Organization.fromJson(json['organization'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdDate'] = createdDate;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    if (organization != null) {
      data['organization'] = organization!.toJson();
    }
    return data;
  }
}

class Organization {
  String? id;
  String? createdDate;
  String? nameEn;
  String? nameAr;
  bool? isActive;
  String? type;

  Organization(
      {this.id,
      this.createdDate,
      this.nameEn,
      this.nameAr,
      this.isActive,
      this.type});

  Organization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdDate = json['createdDate'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
    isActive = json['isActive'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdDate'] = createdDate;
    data['nameEn'] = nameEn;
    data['nameAr'] = nameAr;
    data['isActive'] = isActive;
    data['type'] = type;
    return data;
  }
}
