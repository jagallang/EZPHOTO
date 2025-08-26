import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/photo.dart';
import '../../domain/entities/layout_config.dart';
import '../../domain/entities/cover_page.dart';
import '../../domain/usecases/photo_usecases.dart';
import '../../domain/usecases/layout_usecases.dart';

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
  List<Photo> _photos = [];
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
    try {
      final photo = await pickPhotoUseCase(source: source);
      if (photo != null) {
        if (replaceIndex != null && replaceIndex < _photos.length) {
          _photos[replaceIndex] = photo;
        } else {
          _photos.add(photo);
        }
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickMultiplePhotos() async {
    _setLoading(true);
    try {
      final newPhotos = await pickMultiplePhotosUseCase();
      _photos.addAll(newPhotos);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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
    if (_photos.isEmpty) return false;
    
    _setLoading(true);
    try {
      // TODO: Implement screenshot capture and save
      // This would require integration with screenshot package
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> saveAsPdf() async {
    if (_photos.isEmpty) return false;
    
    _setLoading(true);
    try {
      final photoBytes = _photos
          .where((photo) => photo.bytes != null)
          .map((photo) => photo.bytes!)
          .toList();
      
      if (photoBytes.isNotEmpty) {
        return await savePhotosAsPdfUseCase(
          photoBytes,
          'photo_layout_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
      }
      return false;
    } catch (e) {
      _setError(e.toString());
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