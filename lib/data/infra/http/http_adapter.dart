import 'package:http/http.dart';

class HttpAdapter {
  final Client httpClient;

  HttpAdapter(this.httpClient);

  Future<void> request(String url, String method) async {
    await this.httpClient.post(Uri.parse(url));
    return;
  }
}
