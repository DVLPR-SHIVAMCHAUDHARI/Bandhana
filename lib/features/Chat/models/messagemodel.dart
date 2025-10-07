// messagemodel.dart

class Messagemodel {
  String type; // "source" (me) or "destination" (other user)
  String message;
  String time; // Formatted time string (e.g., "09:41")

  Messagemodel({required this.message, required this.type, required this.time});

  // ----------------------------------------------------
  // HIVE/JSON SERIALIZATION
  // ----------------------------------------------------

  /// Converts the model instance into a JSON Map for local storage (Hive).
  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
    'time': time,
  };

  /// Creates a Messagemodel instance from a JSON Map retrieved from storage.
  factory Messagemodel.fromJson(Map<String, dynamic> json) => Messagemodel(
    type: json['type'] as String,
    message: json['message'] as String,
    time: json['time'] as String,
  );
}
