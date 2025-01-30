import 'dart:convert';
import 'package:puc_app/core/constants/url_constants.dart';
import 'package:puc_app/core/utils/api_response.dart';
import 'package:puc_app/core/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'package:puc_app/features/authentication/model/user.dart';

class AuthService {
  static Future<APIResponse<User>> login({
    required String email,
    required String password,
  }) async {
    const String url = "${UrlConstants.paymentsBaseUrl}/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        DevLogs.logSuccess(response.body);

        final responseData = jsonDecode(response.body)['result'];

        final user = User.fromJson(responseData);

        if (responseData['accessToken'] != null) {
          return APIResponse(
            success: true,
            message: 'Login successful',
            data: user,
          );
        } else {
          return APIResponse(
            success: false,
            message: 'Access token not found in response',
          );
        }
      } else {
        return APIResponse(
          success: false,
          message: 'Login failed with status code ${response.statusCode}',
        );
      }
    } catch (e, stacktrace) {
      DevLogs.logError("Error: $e, Stacktrace: $stacktrace");
      return APIResponse(
        success: false,
        message: e.toString(),
      );
    }
  }
}
