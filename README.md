<h1 align="center">💸 Budget Tracker Application 2 💸</h1>
<p align="center">
  <img width="379" height="835" alt="image" src="https://github.com/user-attachments/assets/fde7e3e8-44a7-44e1-a6f5-10352ad39362" />
  <img width="369" height="828" alt="image" src="https://github.com/user-attachments/assets/de8c3731-b189-405c-bed7-e70ea05ac3bf" />
  <img width="389" height="834" alt="image" src="https://github.com/user-attachments/assets/617cf9a0-6518-414a-a28f-092fb244e37d" />
  <img width="378" height="818" alt="image" src="https://github.com/user-attachments/assets/35cb3bdc-d521-470c-a771-8df68af90e64" />
  <img width="369" height="805" alt="image" src="https://github.com/user-attachments/assets/8cd309ba-132a-44c3-80be-520ad7710f82" />
  <img width="369" height="821" alt="image" src="https://github.com/user-attachments/assets/fa873f12-9ee1-4c02-a618-69665c68db49" />
  <img width="372" height="797" alt="image" src="https://github.com/user-attachments/assets/4905a61d-c42a-4bd3-8fdd-a1cadc96f9df" />
  <img width="370" height="783" alt="image" src="https://github.com/user-attachments/assets/a65689bf-1fc5-4124-af07-678a429409c5" />


  





  
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
