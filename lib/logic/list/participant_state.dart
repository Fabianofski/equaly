class ParticipantState {
  final String id;
  final String name;
  final String avatarUrl;

  ParticipantState({
    required this.avatarUrl,
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "name": name,
        "avatarUrl": avatarUrl,
      };

  factory ParticipantState.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': String id,
      'name': String name,
      'avatarUrl': String avatarUrl,
      } =>
          ParticipantState(avatarUrl: avatarUrl, name: name, id: id),
    _ => throw const FormatException("Failed to load Participant from Json"),
    };
  }
}
