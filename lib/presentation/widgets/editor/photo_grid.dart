import 'package:flutter/material.dart';
import '../../../domain/entities/photo.dart';
import '../../../domain/entities/layout_config.dart';
import '../common/smart_image.dart';

/// Photo grid widget for displaying photos in a grid layout
class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;
  final LayoutConfig layoutConfig;
  final Function(int index)? onPhotoTap;
  final Function(int index)? onPhotoLongPress;
  final bool showBorder;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.layoutConfig,
    this.onPhotoTap,
    this.onPhotoLongPress,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layoutConfig.columns,
        crossAxisSpacing: layoutConfig.spacing,
        mainAxisSpacing: layoutConfig.spacing,
        childAspectRatio: 1.0,
      ),
      itemCount: layoutConfig.photosPerPage,
      itemBuilder: (context, index) {
        final photo = index < photos.length ? photos[index] : null;
        
        return PhotoGridItem(
          photo: photo,
          showBorder: showBorder,
          borderWidth: layoutConfig.borderWidth,
          onTap: () => onPhotoTap?.call(index),
          onLongPress: () => onPhotoLongPress?.call(index),
        );
      },
    );
  }
}

class PhotoGridItem extends StatelessWidget {
  final Photo? photo;
  final bool showBorder;
  final double borderWidth;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PhotoGridItem({
    super.key,
    this.photo,
    this.showBorder = true,
    this.borderWidth = 1.0,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: showBorder
              ? Border.all(
                  color: Colors.grey[400]!,
                  width: borderWidth,
                )
              : null,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(showBorder ? 3 : 4),
          child: photo != null
              ? SmartImage(
                  imageSource: photo!.source,
                  fit: BoxFit.cover,
                )
              : _EmptySlot(),
        ),
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Icon(
          Icons.add_photo_alternate,
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}