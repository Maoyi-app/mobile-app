import 'dart:convert';
import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fishapp/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// This class is responsible for storing data
/// to the normal (insecure) storage of a device.
/// It exposes methods to read or write data
///
class SharedStorage {
  Future<SharedPreferences> _storage = SharedPreferences.getInstance();

  final _currentUserKey = "user";

  SharedStorage._privateConstruct();
  static final SharedStorage _instance = SharedStorage._privateConstruct();

  factory SharedStorage() {
    return _instance;
  }
  Future<SharedPreferences> get storage {
    return this._storage;
  }

  Future<bool> saveUser(User user) async {
    SharedPreferences _prefs = await this._storage;
    bool saveOK =
        await _prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    return saveOK;
  }

  Future<User> loadUser() async {
    SharedPreferences _prefs = await this._storage;
    String storedJsonUser = _prefs.getString(_currentUserKey);
    if (storedJsonUser != null) {
      Map userMap = jsonDecode(storedJsonUser);
      return User.fromJson(userMap);
    } else {
      return null;
    }
  }

  Future<bool> removeUser() async {
    SharedPreferences _prefs = await this._storage;
    return _prefs.remove(_currentUserKey);
  }
}

///
/// This class is responsible for storing data
/// to the secure storage of a device.
/// It exposes methods to read or write data, e.q. a JWT
///
class SecureStorage {
  final _secureStorage = FlutterSecureStorage();

  SecureStorage._privateConstruct();
  static final SecureStorage _instance = SecureStorage._privateConstruct();

  factory SecureStorage() {
    return _instance;
  }

  final String _tokenKey = "jwt_token";

  Future<void> _writeSecure(String key, String value) async {
    return _secureStorage.write(key: key, value: value);
  }

  Future<String> _readSecure(String key) async {
    return _secureStorage.read(key: key);
  }

  Future<void> _deleteSecure(String key) async {
    var delete = await _secureStorage.delete(key: key);
    return delete;
  }

  Future<void> writeTokenString(String tokenStr) {
    return _writeSecure(_tokenKey, tokenStr);
  }

  Future<String> readTokenString() {
    return _readSecure(_tokenKey);
  }

  Future<void> removeTokenString() {
    _deleteSecure(_tokenKey);
  }
}
