import 'dart:convert';

import 'package:http/http.dart';

import '../../http/http.dart';

class HttpAdapter implements CustomHttpClient {
  final Client httpClient;
  final Map<String, String> customHeaders = {
    'User-Agent': 'MoovBR.Mobile/1.0.0',
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  HttpAdapter(this.httpClient);

  Future<Map?> request(String url, String method,
      {Map<String, dynamic>? body}) async {
    final response = await this.httpClient.post(Uri.parse(url),
        headers: customHeaders, body: body != null ? jsonEncode(body) : null);
    return _handleHttpResponse(response);
  }

  Map? _handleHttpResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        if (response.body.isEmpty) return null;
        return jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 500:
      default:
        throw HttpError.serverError;
    }
  }
}
