import 'dart:io';

HttpClient getCustomHttpClient() {
  HttpClient client = HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    // Optional: Kiểm tra cert.issuer hoặc cert.pem nếu bạn muốn cụ thể hơn
    print('Bypassing SSL for $host');
    return true;
  };
  return client;
}