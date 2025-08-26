import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenServices {
  static final TokenServices _instance = TokenServices.internal();
  TokenServices.internal();
  factory TokenServices() => _instance;

  String? _accessToken;
  String? _username;
  String? _roleId;
  int? _locationId;
  String? _locationName;

  String? get username => _username;
  String? get accessToken => _accessToken;
  String? get roleId => _roleId;
  int? get locationId => _locationId;
  String? get locationName => _locationName;

  final storage = const FlutterSecureStorage();

  /// Store username
  Future<void> storeUsername({required String username}) async {
    _username = username;
    await storage.write(key: 'username', value: username);
  }

  /// Store token
  Future<void> storeToken({required String accessToken}) async {
    _accessToken = accessToken;
    await storage.write(key: "x-auth-token", value: accessToken);
  }

  /// Store role
  Future<void> storeRole({required String roleId}) async {
    _roleId = roleId;
    await storage.write(key: "roleId", value: roleId);
  }

  /// Store location
  Future<void> storeLocation({
    required int locationId,
    required String locationName,
  }) async {
    _locationId = locationId;
    _locationName = locationName;
    await storage.write(key: "locationId", value: locationId.toString());
    await storage.write(key: "locationName", value: locationName);
  }

  /// Load from secure storage
  Future<void> loadToken() async {
    _accessToken = await storage.read(key: "x-auth-token");
    _username = await storage.read(key: "username");

    final roleString = await storage.read(key: "roleId");
    _roleId = roleString;

    final locString = await storage.read(key: "locationId");
    _locationId = locString != null ? int.tryParse(locString) : null;

    _locationName = await storage.read(key: "locationName");
  }

  /// Delete all
  Future<void> deleteToken() async {
    _accessToken = null;
    _username = null;
    _roleId = null;
    _locationId = null;
    _locationName = null;

    await storage.delete(key: 'x-auth-token');
    await storage.delete(key: 'username');
    await storage.delete(key: 'roleId');
    await storage.delete(key: 'locationId');
    await storage.delete(key: 'locationName');
  }
}
