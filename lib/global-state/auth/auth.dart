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

  String getAuthToken() {
    String? token = state.value;

    if (token == null) {
      return "";
    }

    bool isTokenExpired = JwtDecoder.isExpired(token);

    if (isTokenExpired) {
      return "";
    } else {
      return token;
    }
  }

  Future<void> setAuthToken(String token) async {
    await SecureStorage.write('token', token);
    state = AsyncValue.data(token);
  }

  Future<void> invalidateProviders() async {
    await SecureStorage.delete("token");
  }

  Future<void> logout() async {
    await invalidateProviders();
    state = const AsyncValue.data(null);
  }
}
