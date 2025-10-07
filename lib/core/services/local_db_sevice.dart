// local_db_service.dart

import 'dart:developer';
import 'package:MilanMandap/core/const/user_model.dart'; // Ensure this path is correct
import 'package:MilanMandap/features/Chat/models/messagemodel.dart'; // Ensure this path is correct
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class LocalDbService {
  static final LocalDbService instance = LocalDbService._internal();
  LocalDbService._internal();
  factory LocalDbService() => instance;

  Box<Map>? _userBox; // Stores single UserModel as a Map
  Box<List<dynamic>>? _messageBox; // Stores List<Messagemodel> as List<Map>
  Box<dynamic>? _settingsBox; // Stores settings like 'firstTime'

  /// Initialize Hive & open boxes
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    _userBox = await Hive.openBox<Map>("user");
    _settingsBox = await Hive.openBox("settings");
    // Open the new messages box using List<dynamic> for list of maps
    _messageBox = await Hive.openBox<List<dynamic>>("messages");

    log("✅ Local DB Service Initialized");
  }

  // ----------------------------------------------------
  // Box Getters (Safe Access)
  // ----------------------------------------------------

  Box<Map> get _userDataBox {
    if (_userBox == null) throw Exception("❌ User box not initialized");
    return _userBox!;
  }

  Box<List<dynamic>> get _messagesDataBox {
    if (_messageBox == null) throw Exception("❌ Messages box not initialized");
    return _messageBox!;
  }

  Box<dynamic> get _settingsDataBox {
    if (_settingsBox == null) throw Exception("❌ Settings box not initialized");
    return _settingsBox!;
  }

  // ----------------------------------------------------
  // USER DATA MANAGEMENT
  // ----------------------------------------------------

  /// Save user data (UserModel → Map)
  Future<void> saveUserData(UserModel user) async {
    await _userDataBox.put('userData', user.toJson());
    log("✅ User data saved in Hive");
  }

  /// Retrieve user data as typed UserModel
  UserModel? getUserData() {
    final data = _userDataBox.get('userData');
    if (data != null) {
      // Ensure the map is correctly cast before using fromJson
      return UserModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  /// Clear saved user data
  Future<void> clearUserData() async {
    await _userDataBox.delete('userData');
    log("✅ User data cleared from Hive");
  }

  // ----------------------------------------------------
  // SETTINGS MANAGEMENT
  // ----------------------------------------------------

  /// Check first app launch
  Future<bool> checkUserComesFirstTime() async {
    bool? firstTime = _settingsDataBox.get('firstTime') as bool?;
    if (firstTime == null || firstTime == true) {
      await _settingsDataBox.put('firstTime', false);
      return true;
    }
    return false;
  }

  // ----------------------------------------------------
  // CHAT MESSAGE HISTORY MANAGEMENT
  // ----------------------------------------------------

  /// Creates a consistent room key by sorting and combining user IDs.
  String _getChatRoomKey(int userId1, int userId2) {
    // Sorts IDs numerically and joins them with an underscore.
    final sortedIds = [userId1, userId2].toList()..sort();
    return sortedIds.join('_');
  }

  /// Saves the full list of messages for a specific chat room.
  /// It stores a List of Map<String, dynamic> (Messagemodel.toJson()).
  Future<void> saveChatMessages(
    int currentUserId,
    int targetUserId,
    List<Messagemodel> messages,
  ) async {
    final key = _getChatRoomKey(currentUserId, targetUserId);

    // Convert List<Messagemodel> to List<Map<String, dynamic>> for storage
    final messageMaps = messages.map((m) => m.toJson()).toList();

    await _messagesDataBox.put(key, messageMaps);
    log("✅ Chat history for key $key saved (${messages.length} messages)");
  }

  /// Retrieves the message list for a specific chat room.
  List<Messagemodel> getChatMessages(int currentUserId, int targetUserId) {
    final key = _getChatRoomKey(currentUserId, targetUserId);

    // Retrieve the list of maps
    final rawData = _messagesDataBox.get(key);

    if (rawData == null) {
      log("ℹ️ No saved chat history found for key $key");
      return [];
    }

    // Convert List<dynamic> (List<Map>) back to List<Messagemodel>
    try {
      return rawData
          .cast<Map>() // Cast to List<Map>
          .map(
            (map) => Messagemodel.fromJson(Map<String, dynamic>.from(map)),
          ) // Convert map to Messagemodel
          .toList();
    } catch (e) {
      log("❌ Error converting stored chat data for key $key: $e");
      return [];
    }
  }

  /// Clears the message history for a specific chat room.
  Future<void> clearChatMessages(int currentUserId, int targetUserId) async {
    final key = _getChatRoomKey(currentUserId, targetUserId);
    await _messagesDataBox.delete(key);
    log("✅ Chat history for key $key cleared.");
  }
}
