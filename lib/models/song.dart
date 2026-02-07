class Song {
  final String id;
  final String title;
  final String path;
  final String? artist;
  final String? album;
  final Duration? duration;
  final DateTime addedDate;

  Song({
    required this.id,
    required this.title,
    required this.path,
    this.artist,
    this.album,
    this.duration,
    required this.addedDate,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
      artist: json['artist'] as String?,
      album: json['album'] as String?,
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      addedDate: DateTime.parse(json['addedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'artist': artist,
      'album': album,
      'duration': duration?.inMilliseconds,
      'addedDate': addedDate.toIso8601String(),
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? path,
    String? artist,
    String? album,
    Duration? duration,
    DateTime? addedDate,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      path: path ?? this.path,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}
