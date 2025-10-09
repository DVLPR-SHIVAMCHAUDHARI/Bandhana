import 'package:MilanMandap/core/const/globals.dart';
import 'package:MilanMandap/core/services/tokenservice.dart';
import 'package:dio/dio.dart';

abstract class Repository {
  final String host = "http://3.110.183.40:4015/Bandhana/api/v1";
  // final String host = "http://192.168.1.13:4015/Bandhana/api/v1";
  late final Dio dio;

  Repository() {
    dio = Dio(
      BaseOptions(
        baseUrl: host,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.d("➡️ REQUEST: ${options.uri}");

          final token = TokenServices().accessToken;
          if (token != null && token.isNotEmpty) {
            options.headers["x-auth-token"] = token;
          }

          if (options.data != null) {
            logger.d("📦 PAYLOAD: ${options.data}");
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.d(
            "✅ RESPONSE: ${response.statusCode} ${response.realUri.path}",
          );
          logger.d(response.data);

          if (response.headers.map.containsKey('x-auth-token')) {
            final token = response.headers.value('x-auth-token');
            if (token != null && token.isNotEmpty) {
              TokenServices().storeTokens(accessToken: token);
              logger.d("🔑 x-auth-token stored successfully from header");
            }
          }

          final bodyToken =
              response.data?['Response']?['ResponseData']?['x_auth_token'];
          if (bodyToken != null && bodyToken.isNotEmpty) {
            TokenServices().storeTokens(accessToken: bodyToken);
            logger.d("🔑 x-auth-token stored successfully from body");
          }

          return handler.next(response);
        },

        onError: (error, handler) {
          logger.e("❌ ERROR: ${error.requestOptions.uri}");
          logger.e("STATUS: ${error.response?.statusCode}");
          logger.e("MESSAGE: ${error.message}");
          if (error.response?.data != null) {
            logger.e("BODY: ${error.response?.data}");
          }

          return handler.next(error);
        },
      ),
    );
  }
}
