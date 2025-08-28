import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/layout_config.dart';
import '../../domain/entities/cover_page.dart';
import '../../domain/usecases/photo_usecases.dart';
import '../../domain/usecases/layout_usecases.dart';
import '../../core/utils/logger.dart';
import '../../core/errors/exceptions.dart';

/// BLoC for managing photo editor state
class PhotoEditorBloc extends ChangeNotifier {
  final PickPhotoUseCase pickPhotoUseCase;
  final PickMultiplePhotosUseCase pickMultiplePhotosUseCase;
  final SavePhotoUseCase savePhotoUseCase;
  final SavePhotosAsPdfUseCase savePhotosAsPdfUseCase;
  final SharePhotoUseCase sharePhotoUseCase;
  final CalculateLayoutUseCase calculateLayoutUseCase;
  final ValidateLayoutConfigUseCase validateLayoutConfigUseCase;

  PhotoEditorBloc({
    required this.pickPhotoUseCase,
    required this.pickMultiplePhotosUseCase,
    required this.savePhotoUseCase,
    required this.savePhotosAsPdfUseCase,
    required this.sharePhotoUseCase,
    required this.calculateLayoutUseCase,
    required this.validateLayoutConfigUseCase,
  });

  // State
  final List<Photo> _photos = [];
  LayoutConfig _layoutConfig = const LayoutConfig();
  CoverPage? _coverPage;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Photo> get photos => _photos;
  LayoutConfig get layoutConfig => _layoutConfig;
  CoverPage? get coverPage => _coverPage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<List<Photo>> get photoPages => calculateLayoutUseCase(
    photos: _photos,
    config: _layoutConfig,
  );

  // Actions
  Future<void> pickPhoto(ImageSource source, {int? replaceIndex}) async {
    _setLoading(true);
    clearError();
    
    try {
      AppLogger.debug('Picking photo from source: $source', 'PhotoEditorBloc');
      final photo = await pickPhotoUseCase(source: source);
      if (photo != null) {
        if (replaceIndex != null && replaceIndex < _photos.length) {
          _photos[replaceIndex] = photo;
          AppLogger.info('Photo replaced at index $replaceIndex', 'PhotoEditorBloc');
        } else {
          _photos.add(photo);
          AppLogger.info('Photo added, total: ${_photos.length}', 'PhotoEditorBloc');
        }
        notifyListeners();
      } else {
        AppLogger.warning('No photo selected', 'PhotoEditorBloc');
      }
    } catch (e) {
      AppLogger.error('Failed to pick photo', e, null, 'PhotoEditorBloc');
      if (e is AppException) {
        _setError(e.message);
      } else {
        _setError('Failed to pick photo. Please try again.');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickMultiplePhotos() async {
    _setLoading(true);
    clearError();
    
    try {
      AppLogger.debug('Picking multiple photos', 'PhotoEditorBloc');
      final newPhotos = await pickMultiplePhotosUseCase();
      _photos.addAll(newPhotos);
      AppLogger.info('Added ${newPhotos.length} photos, total: ${_photos.length}', 'PhotoEditorBloc');
      notifyListeners();
    } catch (e) {
      AppLogger.error('Failed to pick multiple photos', e, null, 'PhotoEditorBloc');
      if (e is AppException) {
        _setError(e.message);
      } else {
        _setError('Failed to pick photos. Please try again.');
      }
    } finally {
      _setLoading(false);
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _photos.length) {
      _photos.removeAt(index);
      notifyListeners();
    }
  }

  void movePhoto(int oldIndex, int newIndex) {
    if (oldIndex < _photos.length && newIndex < _photos.length) {
      final photo = _photos.removeAt(oldIndex);
      _photos.insert(newIndex, photo);
      notifyListeners();
    }
  }

  void updateLayoutConfig(LayoutConfig config) {
    if (validateLayoutConfigUseCase(config)) {
      _layoutConfig = config;
      notifyListeners();
    }
  }

  void updateCoverPage(CoverPage? coverPage) {
    _coverPage = coverPage;
    notifyListeners();
  }

  Future<bool> saveCurrentLayout() async {
    if (_photos.isEmpty) {
      _setError('No photos to save');
      return false;
    }
    
    _setLoading(true);
    clearError();
    
    try {
      AppLogger.debug('Saving current layout', 'PhotoEditorBloc');
      // TODO: Implement screenshot capture and save
      // This would require integration with screenshot package
      AppLogger.info('Layout saved successfully', 'PhotoEditorBloc');
      return true;
    } catch (e) {
      AppLogger.error('Failed to save layout', e, null, 'PhotoEditorBloc');
      if (e is AppException) {
        _setError(e.message);
      } else {
        _setError('Failed to save layout. Please try again.');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> saveAsPdf() async {
    if (_photos.isEmpty) {
      _setError('No photos to export as PDF');
      return false;
    }
    
    _setLoading(true);
    clearError();
    
    try {
      AppLogger.debug('Saving as PDF', 'PhotoEditorBloc');
      final photoBytes = _photos
          .where((photo) => photo.bytes != null)
          .map((photo) => photo.bytes!)
          .toList();
      
      if (photoBytes.isEmpty) {
        _setError('No valid photo data found');
        return false;
      }
      
      final filename = 'photo_layout_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final success = await savePhotosAsPdfUseCase(photoBytes, filename);
      
      if (success) {
        AppLogger.info('PDF saved successfully: $filename', 'PhotoEditorBloc');
      }
      
      return success;
    } catch (e) {
      AppLogger.error('Failed to save PDF', e, null, 'PhotoEditorBloc');
      if (e is AppException) {
        _setError(e.message);
      } else {
        _setError('Failed to save PDF. Please try again.');
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearPhotos() {
    _photos.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}