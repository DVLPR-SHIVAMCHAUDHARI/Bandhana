import 'dart:developer';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbService {
  static final LocalDbService instance = LocalDbService._internal();
  LocalDbService._internal();
  factory LocalDbService() => instance;

  Box? userBox;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    userBox = await Hive.openBox("user");
    log("✅ Local DB Service Initialized");
  }

  /// Async because Hive read might be delayed
  Future<bool> checkUserComesFirstTime() async {
    final box = userBox ?? await Hive.openBox("user");

    bool? firstTime = box.get('firstTime');
    if (firstTime == null || firstTime == true) {
      await box.put('firstTime', false);
      return true; // 🔑 first launch
    } else {
      return false; // not first launch
    }
  }
}
