import '../http/custom_http_client.dart';

class RemoteAuthentication {
  final CustomHttpClient httpClient;
  final String url;

  RemoteAuthentication(this.httpClient, this.url);

  Future<void> auth() async {
    return await this.httpClient.request(this.url, 'POST');
  }
}
