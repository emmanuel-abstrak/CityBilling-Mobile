import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:puc_app/core/constants/url_constants.dart';
import 'package:puc_app/core/utils/api_response.dart';
import 'package:puc_app/core/utils/logs.dart';
import 'package:puc_app/features/municipalities/models/municipality.dart';

class MunicipalityServices {
  /// Fetch the list of municipalities from the API
  static Future<APIResponse<List<Municipality>>> getMunicipalities() async {
    const String url = "${UrlConstants.baseUrl}/providers";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Log the response for debugging
      DevLogs.logInfo('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Decode and parse the response body
        final List<dynamic> jsonData = jsonDecode(response.body);
        final municipalities = jsonData
            .map((municipality) => Municipality.fromJson(municipality))
            .toList();

        return APIResponse<List<Municipality>>(
          success: true,
          data: municipalities,
          message: "Municipalities fetched successfully",
        );
      } else {
        // Handle unsuccessful status codes
        return APIResponse<List<Municipality>>(
          success: false,
          data: [],
          message: "Failed to fetch municipalities. Status code: ${response.statusCode}",
        );
      }
    } catch (e, stackTrace) {
      // Log detailed error information
      DevLogs.logError('Error fetching municipalities: $e\nStack Trace: $stackTrace');

      // Return an APIResponse with the error details
      return APIResponse<List<Municipality>>(
        success: false,
        data: [],
        message: "An error occurred: $e",
      );
    }
  }
}
