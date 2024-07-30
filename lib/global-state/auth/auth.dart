import 'package:blocsol_loan_application/utils/errors.dart';
import 'package:blocsol_loan_application/utils/secure_storage.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'auth.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<String?> build() async {
    String? token = await SecureStorage.read('token');
    ref.keepAlive();
    return token;
  }

  Future<(String, ErrorInstance?)> getAuthToken() async {
    String? token = state.value;

    if (token == null) {
      String? storageToken = await SecureStorage.read('token');

      if (storageToken != null) {
        token = storageToken;
      } else {
        await invalidateProviders();
        return (
          "",
          ErrorInstance(
            message: 'Token not found',
          )
        );
      }
    }

    bool isTokenExpired = JwtDecoder.isExpired(token);

    if (isTokenExpired) {
      await invalidateProviders();
      return (
        "",
        ErrorInstance(
          message: 'Token expired',
        )
      );
    } else {
      return (token, null);
    }
  }

  (String, ErrorInstance?) getAuthTokenSync() {
    String? token = state.value;

    if (token == null) {
      return (
        "",
        ErrorInstance(
          message: 'Token not found',
        )
      );
    }

    bool isTokenExpired = JwtDecoder.isExpired(token);

    if (isTokenExpired) {
      return (
        "",
        ErrorInstance(
          message: 'Token expired',
        )
      );
    } else {
      return (token, null);
    }
  }

  Future<void> setAuthToken(String token) async {
    await SecureStorage.write('token', token);
    state = AsyncValue.data(token);
  }

  Future<ErrorInstance?> invalidateProviders() async {
    await SecureStorage.delete("token");

    return null;
  }

  Future<void> logout() async {
    await invalidateProviders();
    state = const AsyncValue.data(null);
  }
}
