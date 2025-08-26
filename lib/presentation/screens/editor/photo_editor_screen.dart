import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../bloc/photo_editor_bloc.dart';
import '../../widgets/common/smart_image.dart';
import '../../widgets/editor/photo_grid.dart';
import '../../widgets/dialogs/photo_source_dialog.dart';
import '../../widgets/dialogs/layout_settings_dialog.dart';
import '../settings/settings_screen.dart';

class PhotoEditorScreen extends StatefulWidget {
  const PhotoEditorScreen({super.key});

  @override
  State<PhotoEditorScreen> createState() => _PhotoEditorScreenState();
}

class _PhotoEditorScreenState extends State<PhotoEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoEditorBloc>(
      builder: (context, bloc, child) {
        return Scaffold(
          backgroundColor: AppTheme.grey50,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context, bloc),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.mediumPadding),
                  child: Column(
                    children: [
                      _buildActionButtons(context, bloc),
                      const SizedBox(height: AppConstants.mediumPadding),
                      _buildPhotoGrid(context, bloc),
                      const SizedBox(height: AppConstants.mediumPadding),
                      _buildBottomActions(context, bloc),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, PhotoEditorBloc bloc) {
    return SliverAppBar(
      expandedHeight: AppConstants.appBarHeight,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'app_title'.tr(),
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppTheme.white),
                    onPressed: () => _navigateToSettings(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PhotoEditorBloc bloc) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showPhotoSourceDialog(context, bloc),
            icon: const Icon(Icons.add_photo_alternate),
            label: Text('add_photo'.tr()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showLayoutSettingsDialog(context, bloc),
            icon: const Icon(Icons.grid_view),
            label: Text('layout_settings'.tr()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoGrid(BuildContext context, PhotoEditorBloc bloc) {
    if (bloc.photoPages.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: bloc.photoPages.asMap().entries.map((entry) {
        final pageIndex = entry.key;
        final photos = entry.value;
        
        return Column(
          children: [
            if (pageIndex > 0) 
              const SizedBox(height: AppConstants.largePadding),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.mediumPadding),
                child: PhotoGrid(
                  photos: photos,
                  layoutConfig: bloc.layoutConfig,
                  onPhotoTap: (index) => _onPhotoTap(
                    context, 
                    bloc, 
                    pageIndex * bloc.layoutConfig.photosPerPage + index,
                  ),
                  onPhotoLongPress: (index) => _onPhotoLongPress(
                    context, 
                    bloc, 
                    pageIndex * bloc.layoutConfig.photosPerPage + index,
                  ),
                ),
              ),
            ),
            if (bloc.layoutConfig.showPageNumbers)
              Padding(
                padding: const EdgeInsets.only(top: AppConstants.smallPadding),
                child: Text(
                  'page_number'.tr(namedArgs: {
                    'number': (bloc.layoutConfig.startingPageNumber + pageIndex).toString(),
                  }),
                  style: TextStyle(
                    fontSize: bloc.layoutConfig.pageNumberFontSize,
                    color: AppTheme.grey600,
                  ),
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: AppTheme.grey400,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            Text(
              'no_photos_added'.tr(),
              style: TextStyle(
                fontSize: 18,
                color: AppTheme.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'tap_add_photo_to_start'.tr(),
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, PhotoEditorBloc bloc) {
    if (bloc.photos.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: bloc.isLoading ? null : () => _saveLayout(bloc),
                icon: const Icon(Icons.save),
                label: Text('save_layout'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: bloc.isLoading ? null : () => _saveAsPdf(bloc),
                icon: const Icon(Icons.picture_as_pdf),
                label: Text('save_as_pdf'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        TextButton(
          onPressed: bloc.isLoading ? null : () => _clearAllPhotos(context, bloc),
          child: Text('clear_all_photos'.tr()),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.error,
          ),
        ),
      ],
    );
  }

  void _showPhotoSourceDialog(BuildContext context, PhotoEditorBloc bloc) {
    PhotoSourceDialog.show(
      context,
      (source) => bloc.pickPhoto(source),
    );
  }

  void _showLayoutSettingsDialog(BuildContext context, PhotoEditorBloc bloc) {
    LayoutSettingsDialog.show(
      context,
      bloc.layoutConfig,
      (config) => bloc.updateLayoutConfig(config),
    );
  }

  void _onPhotoTap(BuildContext context, PhotoEditorBloc bloc, int index) {
    if (index < bloc.photos.length) {
      // Show photo options (replace, remove, etc.)
      _showPhotoOptions(context, bloc, index);
    } else {
      // Add new photo
      _showPhotoSourceDialog(context, bloc);
    }
  }

  void _onPhotoLongPress(BuildContext context, PhotoEditorBloc bloc, int index) {
    if (index < bloc.photos.length) {
      _showPhotoOptions(context, bloc, index);
    }
  }

  void _showPhotoOptions(BuildContext context, PhotoEditorBloc bloc, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text('replace_photo'.tr()),
              onTap: () {
                Navigator.pop(context);
                PhotoSourceDialog.show(
                  context,
                  (source) => bloc.pickPhoto(source, replaceIndex: index),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text('remove_photo'.tr()),
              onTap: () {
                Navigator.pop(context);
                bloc.removePhoto(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _saveLayout(PhotoEditorBloc bloc) async {
    final success = await bloc.saveCurrentLayout();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('layout_saved_successfully'.tr())),
      );
    }
  }

  void _saveAsPdf(PhotoEditorBloc bloc) async {
    final success = await bloc.saveAsPdf();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pdf_saved_successfully'.tr())),
      );
    }
  }

  void _clearAllPhotos(BuildContext context, PhotoEditorBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('confirm_clear_all'.tr()),
        content: Text('clear_all_photos_warning'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              bloc.clearPhotos();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: Text('clear_all'.tr()),
          ),
        ],
      ),
    );
  }
}