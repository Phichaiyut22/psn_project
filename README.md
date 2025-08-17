<h1 align="center">💸 Budget Tracker Application 2 💸</h1>
<p align="center">
  <img src="assets/icons/app_icon.png" width="120" alt="App Icon" />
</p>
<p align="center">
  <b>แอปพลิเคชันจัดการรายรับรายจ่ายส่วนบุคคล</b><br>
  <i>สร้างนิสัยทางการเงินที่ดี เริ่มต้นวันนี้!</i>
</p>

---

## ✨ คุณสมบัติเด่น

- 🔐 <b>ระบบล็อกอิน/สมัครสมาชิก</b> ด้วย Firebase Authentication
- 📊 <b>แดชบอร์ดสรุปยอด</b> รายรับ รายจ่าย กราฟวงกลม และกราฟเส้น
- 📝 <b>เพิ่ม/แก้ไข/ลบธุรกรรม</b> พร้อมเลือกหมวดหมู่และไอคอน
- 🗂️ <b>ดูประวัติย้อนหลัง</b> แยกตามเดือน/หมวดหมู่
- 💹 <b>ข้อมูลหุ้นเรียลไทม์</b> (Twelve Data API)
- 👤 <b>โปรไฟล์ผู้ใช้</b> แก้ไขข้อมูลและอัปโหลดรูป
- 🌈 <b>ดีไซน์สวยงาม</b> รองรับภาษาไทย ฟอนต์ Prompt สีสันสดใส

---

## 🛠️ เทคโนโลยีที่ใช้

- <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" /> Flutter (Cross-platform)
- <img src="https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=white" /> Firebase (Auth, Firestore, Storage)
- <img src="https://img.shields.io/badge/Twelve%20Data-000000?logo=data&logoColor=white" /> Twelve Data API (หุ้น)
- Google Fonts, Lottie, FontAwesome, intl, image_picker

---

## 🗄️ โครงสร้างฐานข้อมูล (Firestore)

```mermaid
erDiagram
    USERS ||--o{ TRANSACTIONS : has
    USERS {
      string username
      string email
      string phone
      double remainingAmount
      double totalCredit
      double totalDebit
      double salaryTotal
    }
    TRANSACTIONS {
      string title
      double amount
      string type
      string category
      timestamp timestamp
      string monthyear
    }
