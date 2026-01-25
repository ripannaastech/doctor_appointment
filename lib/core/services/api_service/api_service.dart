import '../network/network_client.dart';
import '../session/session.dart';
import 'package:dio/dio.dart';

class NetworkService {
  late final NetworkClient client;

  NetworkService() {
    client = NetworkClient(
      baseUrl: 'http://104.237.9.168:9001',
      onUnAuthorize: _handleUnauthorized,
      commonHeaders: _buildHeaders,
    );
  }

  Map<String, String> _buildHeaders() {
    final h = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final t = Session.accessToken;        // <- sync from cache
    if (t != null && t.isNotEmpty) {
      h['Authorization'] = 'Bearer $t';
    }
    return h;
  }

  void _handleUnauthorized() {
    // optional: route to login, etc.
  }

  // Wrapper methods to expose NetworkClient functionality
  Future<NetworkResponse> getRequest(String url, {Map<String, dynamic>? query, CancelToken? cancelToken, String? bearerToken, Map<String, String>? headers}) {
    return client.getRequest(url, query: query, cancelToken: cancelToken, bearerToken: bearerToken, headers: headers);
  }

  Future<NetworkResponse> postRequest(String url, {Map<String, dynamic>? body, Map<String, dynamic>? query, CancelToken? cancelToken, String? bearerToken, Map<String, String>? headers}) {
    return client.postRequest(url, body: body, query: query, cancelToken: cancelToken, bearerToken: bearerToken, headers: headers);
  }

  Future<NetworkResponse> postRequestMultipart(String url, {required FormData formData, Map<String, dynamic>? query, CancelToken? cancelToken, String? bearerToken, Map<String, String>? headers}) {
    return client.postRequestMultipart(url, formData: formData, query: query, cancelToken: cancelToken, bearerToken: bearerToken, headers: headers);
  }

  Future<NetworkResponse> putRequest(String url, {dynamic body, Map<String, dynamic>? query, CancelToken? cancelToken}) {
    return client.putRequest(url, body: body, query: query, cancelToken: cancelToken);
  }

  Future<NetworkResponse> putRequestMultipart(String url, {required FormData formData, Map<String, dynamic>? query, CancelToken? cancelToken, String? bearerToken, Map<String, String>? headers}) {
    return client.putRequestMultipart(url, formData: formData, query: query, cancelToken: cancelToken, bearerToken: bearerToken, headers: headers);
  }

  Future<NetworkResponse> patchRequest(String url, {Map<String, dynamic>? body, Map<String, dynamic>? query, CancelToken? cancelToken}) {
    return client.patchRequest(url, body: body, query: query, cancelToken: cancelToken);
  }

  Future<NetworkResponse> deleteRequest(String url, {Map<String, dynamic>? body, Map<String, dynamic>? query, CancelToken? cancelToken}) {
    return client.deleteRequest(url, body: body, query: query, cancelToken: cancelToken);
  }
}