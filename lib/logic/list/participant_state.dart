import 'package:equaly/logic/config.dart';

class ParticipantState {
  final String id;
  final String name;
  String avatarUrl;

  ParticipantState({
    required this.avatarUrl,
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "avatarUrl": avatarUrl,
      };

  factory ParticipantState.fromJson(
      Map<String, dynamic> json, String expenseListId) {
    return switch (json) {
      {
        'id': String id,
        'name': String name,
      } =>
        ParticipantState(
            avatarUrl: Uri.http(
                    AppConfig.hostUrl, "/v1/static/profile/$expenseListId/$id")
                .toString(),
            name: name,
            id: id),
      _ => throw const FormatException("Failed to load Participant from Json"),
    };
  }
}
