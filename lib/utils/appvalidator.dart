class Appvalidator {
  // ตรวจสอบการกรอกข้อมูลของอีเมล
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกอีเมล";
    }

    // กำหนดค่า RegExp สำหรับการตรวจสอบรูปแบบของอีเมล (email)
    RegExp emailRegExp = RegExp(r'^[\w\-.]+@[a-zA-Z\d\-.]+\.[a-zA-Z]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return "กรุณากรอกอีเมลให้ถูกต้อง";
    }
    return null;
  }

  // ตรวจสอบว่ากรอกหมายเลขโทรศัพท์และต้องครบ 10 ตัว
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกหมายเลขโทรศัพท์";
    }
    if (value.length != 10) {
      return "กรุณากรอกหมายเลขโทรศัพท์ 10 หลัก";
    }
    return null;
  }

  // ตรวจสอบการกรอกข้อมูลของรหัสผ่าน
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกรหัสผ่าน";
    }
    if (value.length <= 5) {
      return "กรุณากรอกรหัสผ่าน 6 หลัก";
    }
    return null;
  }

  // ตรวจสอบการกรอกข้อมูลของชื่อผู้ใช้
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกชื่อผู้ใช้";
    }
    return null;
  }

  // ตรวจสอบว่าฟิลด์นั้นว่างหรือไม่
  String? isEmptyCheck(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกรายละเอียด";
    }
    return null;
  }
}
