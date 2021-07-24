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
    if (response.body.isEmpty || response.statusCode == 204) return null;
    return jsonDecode(response.body);
  }
}
