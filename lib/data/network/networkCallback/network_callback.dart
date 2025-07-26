import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

import '../../../core/utils/enums.dart';
import '../../../generated/l10n.dart';
import '../client/api_client.dart';

class NetworkCall {
  static Future<Map<String, dynamic>> makeCall(
      {required String endPoint,
      required HttpMethod method,
      dynamic requestBody,
      Map<String, dynamic>? queryParams,
      bool isMultipart = false,
      List<MultipartFile>? multiPartValues,
      Map<String, String>? headers}) async {
    try {
      late Response response;
      if (method == HttpMethod.get) {
        response = (await ApiClient.getRequest(endPoint, queryParams ?? {},));
      } else if (method == HttpMethod.post) {
        response = (await ApiClient.postRequest(endPoint, requestBody,
            isMultipart: isMultipart, multiPartValues: multiPartValues , headersValues: headers));
      } else if (method == HttpMethod.patch) {
        response = (await ApiClient.putRequest(endPoint, requestBody,
            isMultipart: isMultipart, multiPartValues: multiPartValues));
      } else if (method == HttpMethod.delete) {
        response = (await ApiClient.deleteRequest(endPoint, queryParams ?? {}));
      }

      if (response.statusCode == NetworkStatusCodes.ok200.value ||
          response.statusCode == NetworkStatusCodes.ok201.value) {
        //Api logger
        log("Api Response: ${response.body}");
        Map<String, dynamic> res = jsonDecode(response.body);
        res.addAll({'status': true});
        return res;
      } else if (response.statusCode ==
              NetworkStatusCodes.serverInternalError.value ||
          response.statusCode == NetworkStatusCodes.badRequest.value) {
        //Api logger
        log("API Error: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}");
        Map<String, dynamic> res = jsonDecode(response.body);

        return {
          "status": false,
          "statusCode": response.statusCode,
          "message": res["message"],
        };
      } else if (response.statusCode ==
          NetworkStatusCodes.unAuthorizedUser.value) {
        var result = jsonDecode(response.body) as Map<String, dynamic>;

        //Api logger
        log("API Error: ${response.statusCode} - ${response.reasonPhrase} - $result");
        return {
          "status": false,
          "statusCode": response.statusCode,
          "message": result['message']
        };
      } else {
        //Api logger
        log("API Error: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}");
        return {
          "status": false,
          "statusCode": response.statusCode,
          "message": response.reasonPhrase
        };
      }
    } on SocketException catch (e) {
      log("<><><><>>>>>>>>>> $e");
      return {
        "status": false,
        "statusCode": 0,
        "message": S.current.no_internet_connection
      };
    } on Exception catch (e) {
      return {"status": false, "statusCode": 0, "message": e.toString()};
    }
  }
}
