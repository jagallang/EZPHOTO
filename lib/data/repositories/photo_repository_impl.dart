import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gal/gal.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../datasources/photo_local_datasource.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoLocalDataSource localDataSource;
  final ImagePicker _picker = ImagePicker();

  PhotoRepositoryImpl({required this.localDataSource});

  @override
  Future<Photo?> pickPhoto({required ImageSource source}) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final bytes = await image.readAsBytes();
        return Photo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: kIsWeb ? 'data:image/jpeg;base64,${base64Encode(bytes)}' : image.path,
          bytes: bytes,
          addedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('Error picking photo: $e');
      return null;
    }
  }

  @override
  Future<List<Photo>> pickMultiplePhotos() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      final List<Photo> photos = [];
      
      for (final image in images) {
        final bytes = await image.readAsBytes();
        photos.add(Photo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          source: kIsWeb ? 'data:image/jpeg;base64,${base64Encode(bytes)}' : image.path,
          bytes: bytes,
          addedAt: DateTime.now(),
        ));
      }
      
      return photos;
    } catch (e) {
      print('Error picking multiple photos: $e');
      return [];
    }
  }

  @override
  Future<bool> savePhoto(Uint8List bytes, String filename) async {
    try {
      if (kIsWeb) {
        await localDataSource.savePhotoWeb(bytes, filename);
      } else {
        await Gal.putImageBytes(bytes, name: filename);
      }
      return true;
    } catch (e) {
      print('Error saving photo: $e');
      return false;
    }
  }

  @override
  Future<bool> savePhotosAsPdf(List<Uint8List> images, String filename) async {
    try {
      final pdf = pw.Document();
      
      for (final imageBytes in images) {
        final image = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ),
        );
      }
      
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: filename,
      );
      
      return true;
    } catch (e) {
      print('Error saving PDF: $e');
      return false;
    }
  }

  @override
  Future<void> sharePhoto(Uint8List bytes, String filename) async {
    try {
      await Printing.sharePdf(
        bytes: bytes,
        filename: filename,
      );
    } catch (e) {
      print('Error sharing photo: $e');
    }
  }
}