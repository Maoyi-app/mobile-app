import 'dart:convert';

import 'package:fishapp/utils/state/appstate.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiException implements Exception {
  final http.Response response;

  get statusCode => response.statusCode;

  ApiException(this.response);

  void dump() {
    print("############## API EXEP ##############");
    print("URL ${this.response.request.url}");
    print("URL ${this.response.statusCode}");
    print("## body ##");
    print(this.response.body);

    print("############## EXEP END ##############");
  }
}

class FishappRestClient {
  var _client = http.Client();

  Future<Map<String, String>> _addAuthToHeaders(
      BuildContext context, Map<String, String> headers) async {
    final token =
        Provider.of<AppState>(context, listen: false).jwtTokenData.tokenString;
    headers ??= new Map<String, String>();
    return headers..addAll({"Authorization": token});
  }

  Future<http.Response> get(BuildContext context, dynamic url,
      {Map<String, String> headers, bool addAuth = true}) async {
    return _client.get(url,
        headers: addAuth ? await _addAuthToHeaders(context, headers) : headers);
  }

  Future<http.Response> post(BuildContext context, dynamic url,
      {Map<String, String> headers,
      dynamic body,
      Encoding encoding,
      bool addAuth = true}) async {
    return _client.post(url,
        headers: addAuth ? await _addAuthToHeaders(context, headers) : headers,
        body: body,
        encoding: encoding);
  }

  Future<http.Response> put(BuildContext context, dynamic url,
      {Map<String, String> headers,
      dynamic body,
      Encoding encoding,
      bool addAuth = true}) async {
    return _client.put(url,
        headers: addAuth ? await _addAuthToHeaders(context, headers) : headers,
        body: body,
        encoding: encoding);
  }

  Future<http.Response> delete(BuildContext context, dynamic url,
      {Map<String, String> headers, bool addAuth = true}) async {
    return _client.delete(url,
        headers: addAuth ? await _addAuthToHeaders(context, headers) : headers);
  }
}
