import 'package:http/http.dart';

class HttpAdapter {
  final Client httpClient;
  final Map<String, String> customHeaders = {
    'User-Agent': 'MoovBR.Mobile/1.0.0',
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  };

  HttpAdapter(this.httpClient);

  Future<void> request(String url, String method) async {
    await this.httpClient.post(Uri.parse(url), headers: customHeaders);
    return;
  }
}
