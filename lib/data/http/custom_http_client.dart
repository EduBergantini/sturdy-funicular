abstract class CustomHttpClient {
  Future<Map?> request(String url, String method, {Map<String, dynamic> body});
}
