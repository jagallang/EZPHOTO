import 'package:equatable/equatable.dart';

/// Cover page data entity for managing cover page information
class CoverPageData extends Equatable {
  final String title;
  final String subtitle;
  final String date;
  final String authorName;
  final String companyName;
  final List<String> textLines;
  final String backgroundImage;

  const CoverPageData({
    this.title = '',
    this.subtitle = '',
    this.date = '',
    this.authorName = '',
    this.companyName = '',
    List<String>? textLines,
    this.backgroundImage = '',
  }) : textLines = textLines ?? const [];

  CoverPageData copyWith({
    String? title,
    String? subtitle,
    String? date,
    String? authorName,
    String? companyName,
    List<String>? textLines,
    String? backgroundImage,
  }) {
    return CoverPageData(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      date: date ?? this.date,
      authorName: authorName ?? this.authorName,
      companyName: companyName ?? this.companyName,
      textLines: textLines ?? this.textLines,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }

  /// Create an empty cover page with default values
  factory CoverPageData.empty() {
    return const CoverPageData(
      title: 'Photo Album',
      subtitle: 'Collection of Memories',
      date: '',
      authorName: '',
      companyName: '',
      textLines: [],
      backgroundImage: '',
    );
  }

  /// Check if cover page has any content
  bool get hasContent =>
      title.isNotEmpty ||
      subtitle.isNotEmpty ||
      date.isNotEmpty ||
      authorName.isNotEmpty ||
      companyName.isNotEmpty ||
      textLines.isNotEmpty;

  /// Get formatted text lines for display
  List<String> get formattedTextLines {
    final lines = <String>[];
    if (title.isNotEmpty) lines.add(title);
    if (subtitle.isNotEmpty) lines.add(subtitle);
    if (date.isNotEmpty) lines.add(date);
    if (authorName.isNotEmpty) lines.add('By: $authorName');
    if (companyName.isNotEmpty) lines.add(companyName);
    lines.addAll(textLines);
    return lines;
  }

  @override
  List<Object?> get props => [
        title,
        subtitle,
        date,
        authorName,
        companyName,
        textLines,
        backgroundImage,
      ];
}