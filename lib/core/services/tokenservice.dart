import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenServices {
  // Singleton pattern
  static final TokenServices _instance = TokenServices._internal();
  factory TokenServices() => _instance;
  TokenServices._internal();

  // Local variables
  String? _accessToken;
  String? _username;

  // Secure storage
  final _storage = const FlutterSecureStorage();

  // Keys
  static const _keyAccess = "x-auth-token";
  static const _keyRefresh = "refresh-token";
  static const _keyUsername = "username";
  static const _keyRole = "roleId";
  static const _keyLocationId = "locationId";
  static const _keyLocationName = "locationName";

  // Getters
  String? get accessToken => _accessToken;
  String? get username => _username;

  /// Store tokens
  Future<void> storeTokens({required String accessToken}) async {
    _accessToken = accessToken;
    await _storage.write(key: _keyAccess, value: accessToken);
  }

  /// Store username
  Future<void> storeUsername(String username) async {
    _username = username;
    await _storage.write(key: _keyUsername, value: username);
  }

  /// Store role
  Future<void> storeRole(String roleId) async {
    await _storage.write(key: _keyRole, value: roleId);
  }

  /// Store location
  Future<void> storeLocation({
    required int locationId,
    required String locationName,
  }) async {
    await _storage.write(key: _keyLocationId, value: locationId.toString());
    await _storage.write(key: _keyLocationName, value: locationName);
  }

  /// Load all tokens & user info
  Future<void> load() async {
    _accessToken = await _storage.read(key: _keyAccess);
    _username = await _storage.read(key: _keyUsername);
  }

  /// Clear everything (logout)
  Future<void> clear() async {
    _accessToken = null;
    _username = null;
    await _storage.deleteAll();
  }
}
