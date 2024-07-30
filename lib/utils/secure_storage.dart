import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static Future<String?> read(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future<void> write(String key, String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<void> delete(String key) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
  }
}
