import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiClient {
  ApiClient(this.baseUrl);

  final String baseUrl;

  String? _token() =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  Map<String, String> _headers({Map<String, String>? extra}) {
    final token = _token();
    if (token == null) {
      throw Exception('No session/accessToken. User is not logged in.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      if (extra != null) ...extra,
    };
  }

  Uri _u(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> getJson(String path) async {
    final res = await http.get(_u(path), headers: _headers());
    _throwIfError(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<List<dynamic>> getJsonList(String path) async {
    final res = await http.get(_u(path), headers: _headers());
    _throwIfError(res);
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> body) async {
    final res = await http.post(_u(path), headers: _headers(), body: jsonEncode(body));
    _throwIfError(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> putJson(String path, Map<String, dynamic> body) async {
    final res = await http.put(_u(path), headers: _headers(), body: jsonEncode(body));
    _throwIfError(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteJson(String path) async {
    final res = await http.delete(_u(path), headers: _headers());
    _throwIfError(res);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  void _throwIfError(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }
}