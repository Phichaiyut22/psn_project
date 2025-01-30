// service/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ฟังก์ชันสำหรับอัพโหลดรูปภาพโปรไฟล์ไปยัง Firebase Storage
  Future<String?> uploadProfileImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }
}
