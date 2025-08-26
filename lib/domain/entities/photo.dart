import 'dart:typed_data';

/// Photo entity representing a single photo in the editor
class Photo {
  final String id;
  final String source;
  final Uint8List? bytes;
  final DateTime? addedAt;
  final PhotoType type;

  Photo({
    required this.id,
    required this.source,
    this.bytes,
    this.addedAt,
    this.type = PhotoType.userPhoto,
  });

  bool get isEmpty => source.startsWith('local_gradient_');
  bool get isDataUrl => source.startsWith('data:image/');
  bool get isNetworkUrl => source.startsWith('http');

  Photo copyWith({
    String? id,
    String? source,
    Uint8List? bytes,
    DateTime? addedAt,
    PhotoType? type,
  }) {
    return Photo(
      id: id ?? this.id,
      source: source ?? this.source,
      bytes: bytes ?? this.bytes,
      addedAt: addedAt ?? this.addedAt,
      type: type ?? this.type,
    );
  }
}

enum PhotoType {
  userPhoto,
  placeholder,
  gradient,
}