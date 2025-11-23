import 'package:http/http.dart' as http;
import 'dart:convert';

/// Servicio centralizado para comunicación HTTP con el backend
///
/// URLs por entorno:
/// - Android Emulator: http://10.0.2.2:3000/api
/// - iOS Simulator: http://localhost:3000/api
/// - Dispositivo físico: http://TU_IP_LOCAL:3000/api (ej: 192.168.1.100)
class ApiService {
  // TODO: Cambiar según tu entorno de desarrollo
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  /// GET request genérico
  static Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('[ApiService] GET $url');

      final response = await http.get(url, headers: _headers);

      print('[ApiService] Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        // El backend retorna { "success": true, "data": {...} }
        // Extraemos el campo "data"
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('data')) {
          return jsonResponse['data'];
        }
        return jsonResponse;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      print('[ApiService] Error en GET $endpoint: $e');
      rethrow;
    }
  }

  /// POST request genérico
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('[ApiService] POST $url');
      print('[ApiService] Body: ${json.encode(body)}');

      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );

      print('[ApiService] Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        // El backend retorna { "success": true, "data": {...} }
        // Extraemos el campo "data"
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('data')) {
          return jsonResponse['data'];
        }
        return jsonResponse;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      print('[ApiService] Error en POST $endpoint: $e');
      rethrow;
    }
  }

  /// PATCH request genérico
  static Future<dynamic> patch(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('[ApiService] PATCH $url');
      print('[ApiService] Body: ${json.encode(body)}');

      final response = await http.patch(
        url,
        headers: _headers,
        body: json.encode(body),
      );

      print('[ApiService] Response status: ${response.statusCode}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        // El backend retorna { "success": true, "data": {...} }
        // Extraemos el campo "data"
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('data')) {
          return jsonResponse['data'];
        }
        return jsonResponse;
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Error ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      print('[ApiService] Error en PATCH $endpoint: $e');
      rethrow;
    }
  }
}

/// Excepción personalizada para errores de API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
