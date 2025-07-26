import 'package:iron_mine/data/models/request/auth/login_request.dart';

import '../../../core/utils/enums.dart';
import '../../models/request/auth/log_in_with_otp_request.dart';
import '../../models/response/auth/login_response.dart';
import '../../network/networkCallback/network_callback.dart';
import '../../network/services_urls.dart';

class AuthRepository {
  static Future<LoginResponse> login({
    required LoginRequest loginRequest,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.login,
      method: HttpMethod.post,
      requestBody: loginRequest.toJson(),
    );
    return LoginResponse.fromJson(response);
  }

  static Future<LoginResponse> loginWithOtp({
    required LogInWithOtpRequest loginRequest,
  }) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.loginWithOtp,
      method: HttpMethod.post,
      requestBody: loginRequest.toJson(),
    );
    return LoginResponse.fromJson(response);
  }
}
