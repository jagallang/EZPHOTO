/// Layout configuration for photo grid
class LayoutConfig {
  final int columns;
  final int rows;
  final double spacing;
  final double borderWidth;
  final bool showPageNumbers;
  final int startingPageNumber;
  final PageNumberPosition pageNumberPosition;
  final double pageNumberFontSize;

  const LayoutConfig({
    this.columns = 2,
    this.rows = 2,
    this.spacing = 4.0,
    this.borderWidth = 1.0,
    this.showPageNumbers = false,
    this.startingPageNumber = 1,
    this.pageNumberPosition = PageNumberPosition.bottomRight,
    this.pageNumberFontSize = 12.0,
  });

  int get photosPerPage => columns * rows;

  LayoutConfig copyWith({
    int? columns,
    int? rows,
    double? spacing,
    double? borderWidth,
    bool? showPageNumbers,
    int? startingPageNumber,
    PageNumberPosition? pageNumberPosition,
    double? pageNumberFontSize,
  }) {
    return LayoutConfig(
      columns: columns ?? this.columns,
      rows: rows ?? this.rows,
      spacing: spacing ?? this.spacing,
      borderWidth: borderWidth ?? this.borderWidth,
      showPageNumbers: showPageNumbers ?? this.showPageNumbers,
      startingPageNumber: startingPageNumber ?? this.startingPageNumber,
      pageNumberPosition: pageNumberPosition ?? this.pageNumberPosition,
      pageNumberFontSize: pageNumberFontSize ?? this.pageNumberFontSize,
    );
  }
}

enum PageNumberPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}