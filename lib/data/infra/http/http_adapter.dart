import 'dart:convert';

import 'package:http/http.dart';

class HttpAdapter {
  final Client httpClient;
  final Map<String, String> customHeaders = {
    'User-Agent': 'MoovBR.Mobile/1.0.0',
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  HttpAdapter(this.httpClient);

  Future<void> request(String url, String method,
      {Map<String, dynamic>? body}) async {
    await this.httpClient.post(Uri.parse(url),
        headers: customHeaders, body: body != null ? jsonEncode(body) : null);
    return;
  }
}
