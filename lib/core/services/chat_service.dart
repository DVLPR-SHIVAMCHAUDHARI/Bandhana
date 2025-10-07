import 'dart:developer';
import 'package:MilanMandap/core/const/globals.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;
  final String serverUrl =
      "http://3.110.183.40:4015"; // e.g., "http://192.168.1.5:3000"

  // 1. Initialize and Connect to the Server
  void connect() {
    try {
      // Configuration for the Socket.IO connection
      socket = IO.io(
        serverUrl,
        IO.OptionBuilder()
            .setTransports([
              'websocket',
            ]) // Use WebSocket for better performance
            .enableForceNew()
            .disableAutoConnect() // Disable auto-connect to manually call connect()
            .setExtraHeaders({
              'token': token.accessToken,
            }) // Optional: For authentication
            .build(),
      );

      // Manually initiate the connection
      socket.connect();

      // 2. Set up event listeners
      _setupListeners();
    } catch (e) {
      log("Error during socket connection: $e");
    }
  }

  void _setupListeners() {
    socket.onConnect((_) {
      log('Socket connected: ${socket.id}');
      // You can emit an event here to join a chat room, e.g.,
      // socket.emit('joinRoom', {'userId': 'user123', 'roomId': 'roomA'});
    });

    socket.onDisconnect((_) => log('Socket disconnected'));
    socket.onError((data) => log('Socket error: $data'));
    socket.onConnect((data) => log('Socket attempting to connect...'));

    // 3. Listener for incoming messages (must match the event name from your backend)
    socket.on('newMessage', (data) {
      log('New message received: $data');
      // TODO: Update your UI (e.g., add to a list of messages)
      // This usually involves a Stream or a State Management solution (Provider/Bloc/Riverpod)
    });
  }

  // 4. Send a Message
  void sendMessage(String message, String roomId) {
    if (socket.connected) {
      socket.emit('sendMessage', {
        'roomId': roomId,
        'message': message,
        'senderId': 'user123', // Replace with actual user ID
        'timestamp': DateTime.now().toIso8601String(),
      });
      log('Message sent: $message to room $roomId');
    } else {
      log('Cannot send message: Socket is not connected.');
    }
  }

  // 5. Disconnect when no longer needed
  void disconnect() {
    socket.offAny(); // Remove all listeners
    socket.disconnect();
    log('Chat service explicitly disconnected.');
  }
}
