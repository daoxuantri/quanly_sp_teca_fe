import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecurityStorage {
  static final _storage = const FlutterSecureStorage();
  static const _keyId = 'id';
  static const _keyFullname = 'fullname';
  static const _keyPassword = 'password';
  static const _keytoken = 'token';
  static const _keyemail = 'email';
  static const _role = 'role';
  static const _image = 'images';

  UserSecurityStorage._();

  static Future setId(String id) async =>
      await _storage.write(key: _keyId, value: id);

  static Future<String?> getId() async => await _storage.read(key: _keyId);

  static Future setFullname(String username) async =>
      await _storage.write(key: _keyFullname, value: username);

  static Future<String?> getFullname() async =>
      await _storage.read(key: _keyFullname);

  static Future setPassword(String password) async =>
      await _storage.write(key: _keyPassword, value: password);

  static Future<String?> getPassword() async =>
      await _storage.read(key: _keyPassword);
  // static Future setRole(String role) async =>
  //     await _storage.write(key: _keyRole, value: role);

  // static Future<String?> getRole() async =>
  //       await _storage.read(key: _keyRole);

  static Future setToken(String token) async =>
      await _storage.write(key: _keytoken, value: token);

  static Future<String?> getToken() async =>
      await _storage.read(key: _keytoken);

  static Future setEmail(String email) async =>
      await _storage.write(key: _keyemail, value: email);

  static Future<String?> getEmail() async =>
      await _storage.read(key: _keyemail);

  static Future setRole(String role) async =>
      await _storage.write(key: _role, value: role);

  static Future<String?> getRole() async => 
      await _storage.read(key: _role);


  static Future<String?> getImage() async => 
      await _storage.read(key: _image);
  static Future setImage(String image) async =>
      await _storage.write(key: _image, value: image);

  

  static Future deleteAll() async => await _storage.deleteAll();
}
