import 'dart:developer';
import 'package:MilanMandap/core/const/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbService {
  static final LocalDbService instance = LocalDbService._internal();
  LocalDbService._internal();
  factory LocalDbService() => instance;

  Box<Map>? _userBox;
  Box<dynamic>? _settingsBox;

  /// Initialize Hive & open boxes
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    _userBox = await Hive.openBox<Map>("user");
    _settingsBox = await Hive.openBox("settings");

    log("✅ Local DB Service Initialized");
  }

  Box<Map> get _userDataBox {
    if (_userBox == null) throw Exception("❌ User box not initialized");
    return _userBox!;
  }

  Box<dynamic> get _settingsDataBox {
    if (_settingsBox == null) throw Exception("❌ Settings box not initialized");
    return _settingsBox!;
  }

  /// Save user data (UserModel → Map)
  Future<void> saveUserData(UserModel user) async {
    await _userDataBox.put('userData', user.toJson());
    log("✅ User data saved in Hive");
  }

  /// Retrieve user data as typed UserModel
  UserModel? getUserData() {
    final data = _userDataBox.get('userData');
    if (data != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// Clear saved user data
  Future<void> clearUserData() async {
    await _userDataBox.delete('userData');
    log("✅ User data cleared from Hive");
  }

  /// Check first app launch
  Future<bool> checkUserComesFirstTime() async {
    bool? firstTime = _settingsDataBox.get('firstTime') as bool?;
    if (firstTime == null || firstTime == true) {
      await _settingsDataBox.put('firstTime', false);
      return true;
    }
    return false;
  }
}
