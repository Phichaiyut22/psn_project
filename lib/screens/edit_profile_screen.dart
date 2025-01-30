// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime selectedDate = DateTime(1995, 5, 23);
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final StorageService _storageService = StorageService();

  bool isLoading = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _emailController.text = user.email ?? '';
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _nameController.text = userDoc.data()?['username'] ?? '';
        _profileImageUrl = userDoc.data()?['profileImageUrl'];
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        String? profileImageUrl;
        if (_profileImage != null) {
          profileImageUrl = await _storageService.uploadProfileImage(
              user.uid, _profileImage!);
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'username': _nameController.text,
          if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("บันทึกการเปลี่ยนแปลงเรียบร้อยแล้ว")));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาดในการบันทึก")));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('ถ่ายรูป'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context)
                      .pop(); // ปิด BottomSheet เมื่อเลือกแหล่งรูปภาพ
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('เลือกรูปจากแกลเลอรี'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context)
                      .pop(); // ปิด BottomSheet เมื่อเลือกแหล่งรูปภาพ
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFFFAFA),
      appBar: AppBar(
        title: Text("แก้ไขโปรไฟล์",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFAEDFF2),
        // leading: IconButton(
        //   icon: Image.asset(
        //     'assets/icons/back_arrow.png',
        //     width: 35,
        //     height: 35,
        //   ),
        //   onPressed: () =>
        //       Navigator.of(context).popUntil((route) => route.isFirst),
        // ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.18,
                    backgroundColor: Color(0xFFAEDFF2),
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : _profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!) as ImageProvider
                            : null,
                    child: _profileImage == null && _profileImageUrl == null
                        ? Image.asset(
                            'assets/icons/personal.png',
                            width: screenWidth * 0.18,
                            height: screenWidth * 0.18,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5)
                        ],
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/icons/camra.png',
                          // color: Color(0xFF6495ED),
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () => _showImageSourceActionSheet(context),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04),
              _buildTextField(_nameController, 'ชื่อ', 'assets/icons/user.png',
                  fontSize: 16, hintText: 'กรอกชื่อของคุณ'),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                  _emailController, 'อีเมล', 'assets/icons/email.png',
                  fontSize: 16, isEditable: false),
              SizedBox(height: screenHeight * 0.02),
              _buildTextField(
                  _passwordController, 'รหัสผ่าน', 'assets/icons/lock.png',
                  obscureText: true,
                  fontSize: 16,
                  hintText: 'ตั้งรหัสผ่านใหม่'),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        await _saveChanges();
                        FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ด
                        setState(() {
                          // ถ้ามีการอัปเดตข้อมูลที่ต้องการรีเฟรชใน UI สามารถตั้งค่าใหม่ที่นี่
                          _loadUserData(); // โหลดข้อมูลใหม่จาก Firebase
                        });
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.8, 50),
                  backgroundColor: Color(0xFFAEDFF2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("บันทึกการเปลี่ยนแปลง",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String iconPath,
      {bool obscureText = false,
      double fontSize = 16,
      bool isEditable = true,
      String? hintText}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: isEditable,
      style: TextStyle(color: Color(0xFF4A4A4A), fontSize: fontSize),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: SizedBox(
          width: 24, // กำหนดความกว้างของไอคอนให้พอดี
          height: 24, // กำหนดความสูงของไอคอนให้พอดี
          child: Padding(
            padding:
                const EdgeInsets.all(8.0), // กำหนด padding ถ้าต้องการระยะห่าง
            child: Image.asset(
              iconPath,
              // color: Color(0xFFFF99CC), // หากต้องการกำหนดสี สามารถเปิดคอมเมนต์บรรทัดนี้ได้
            ),
          ),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Color(0xFFFFFAFA),
      ),
    );
  }
}
