import 'dart:convert';

class GetOrdersRequest {
  String? page;
  String limit;
  String? phone;
  String? fullName;
  String? vehicleId;

  GetOrdersRequest({
    this.page = '1',
    this.limit = '10',
    this.phone,
    this.fullName,
    this.vehicleId,
  });

  GetOrdersRequest copyWith({
    String? page,
    String? limit,
    String? phone,
    String? fullName,
    String? vehicleId,
  }) {
    return GetOrdersRequest(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      vehicleId: vehicleId ?? this.vehicleId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
    };
  }

  factory GetOrdersRequest.fromMap(Map<String, dynamic> map) {
    return GetOrdersRequest(
      page: map['page'] ?? '',
      limit: map['limit'] ?? '',
      phone: map['phone'] ?? '',
      fullName: map['fullName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GetOrdersRequest.fromJson(String source) =>
      GetOrdersRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetOrdersDto(page: $page, limit: $limit, phone: $phone, fullName: $fullName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GetOrdersRequest &&
        other.page == page &&
        other.limit == limit &&
        other.phone == phone &&
        other.fullName == fullName;
  }

  @override
  int get hashCode {
    return page.hashCode ^ limit.hashCode ^ phone.hashCode ^ fullName.hashCode;
  }
}
