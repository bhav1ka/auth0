import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mpsc_demo/globalvariables/config.dart';

class Authentication {
  static FlutterAppAuth appAuth = FlutterAppAuth();
  static FlutterSecureStorage secureStorage = FlutterSecureStorage();
  static Future<AuthorizationTokenResponse> loginAction() async {
    print('authentication');
    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(authClientId, authRedirectUri,
            issuer: 'https://$authDomain',
            scopes: ['openid', 'profile', 'offline_access'],
            promptValues: ['login']),
      );
      return result;
    } catch (e) {
      throw e;
    }
  }

  static Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);
    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  static Future<void> logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
  }

  static Future<Map> getUserDetails(String accessToken) async {
    final Uri url = Uri.parse('https://$authDomain/userinfo');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }
}
