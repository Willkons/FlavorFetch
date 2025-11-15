import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

/// Service for handling pet photos.
///
/// This service manages photo selection from camera/gallery,
/// compression, and storage in the app's documents directory.
class PhotoService {
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  /// Maximum image size in pixels (width and height)
  static const int maxImageSize = 800;

  /// Maximum file size in bytes (1MB)
  static const int maxFileSize = 1024 * 1024;

  /// Gets a photo from the camera.
  ///
  /// Returns the path to the saved photo, or null if cancelled.
  /// Throws an exception if camera access fails.
  Future<String?> pickFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxImageSize.toDouble(),
        maxHeight: maxImageSize.toDouble(),
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _processAndSaveImage(photo.path);
    } catch (e) {
      throw Exception('Failed to capture photo: $e');
    }
  }

  /// Gets a photo from the gallery.
  ///
  /// Returns the path to the saved photo, or null if cancelled.
  /// Throws an exception if gallery access fails.
  Future<String?> pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxImageSize.toDouble(),
        maxHeight: maxImageSize.toDouble(),
        imageQuality: 85,
      );

      if (photo == null) return null;

      return await _processAndSaveImage(photo.path);
    } catch (e) {
      throw Exception('Failed to select photo: $e');
    }
  }

  /// Processes and saves an image to the app's documents directory.
  ///
  /// The image is:
  /// - Cropped to square aspect ratio
  /// - Resized to maxImageSize (800x800)
  /// - Compressed to ensure file size is under maxFileSize (1MB)
  /// - Saved with a UUID filename
  ///
  /// Returns the path to the saved image.
  Future<String> _processAndSaveImage(String sourcePath) async {
    try {
      // Read the source image
      final sourceFile = File(sourcePath);
      final bytes = await sourceFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Crop to square aspect ratio
      final size = image.width < image.height ? image.width : image.height;
      final xOffset = (image.width - size) ~/ 2;
      final yOffset = (image.height - size) ~/ 2;
      final croppedImage = img.copyCrop(
        image,
        x: xOffset,
        y: yOffset,
        width: size,
        height: size,
      );

      // Resize to maxImageSize
      final resizedImage = img.copyResize(
        croppedImage,
        width: maxImageSize,
        height: maxImageSize,
      );

      // Compress and save
      final directory = await getApplicationDocumentsDirectory();
      final filename = '${_uuid.v4()}.jpg';
      final filePath = path.join(directory.path, 'pet_photos', filename);

      // Ensure directory exists
      final photoDir = Directory(path.join(directory.path, 'pet_photos'));
      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      // Save with progressive quality reduction if needed
      int quality = 85;
      List<int> jpegBytes;
      File outputFile;

      do {
        jpegBytes = img.encodeJpg(resizedImage, quality: quality);
        outputFile = File(filePath);
        await outputFile.writeAsBytes(jpegBytes);

        // If file is still too large, reduce quality
        if (jpegBytes.length > maxFileSize && quality > 20) {
          quality -= 10;
        } else {
          break;
        }
      } while (quality > 20);

      return filePath;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }

  /// Deletes a photo file.
  ///
  /// Returns true if the file was deleted, false if it didn't exist.
  /// Throws an exception if deletion fails.
  Future<bool> deletePhoto(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  /// Gets the size of a photo file in bytes.
  Future<int?> getPhotoSize(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
