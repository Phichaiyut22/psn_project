// นำเข้าแพ็กเกจที่จำเป็น
// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart'; // สำหรับ Widgets และ Colors
import 'package:flutter_svg/flutter_svg.dart'; // สำหรับ SVG Icon

// คลาส AppIcons สำหรับเก็บรายการไอคอนและหมวดหมู่ค่าใช้จ่ายภายในบ้าน
class AppIcons {
  // รายการของหมวดหมู่ค่าใช้จ่าย โดยแต่ละรายการจะเก็บชื่อภาษาอังกฤษ ชื่อภาษาไทย ไอคอน และสี
  final List<Map<String, Object>> homeExpensesCategories = [
    {
      "name": "MySalary",
      "name_th": "เงินเดือนของฉัน",
      "icon": Image.asset('assets/icons/financial-goals.png'), // Custom Icon
      "color": Color(0xFFFF99CC),
    },
    {
      "name": "Gas Filling",
      "name_th": "เติมน้ำมัน",
      "icon": Image.asset('assets/icons/gas-station.png'), // Custom Icon
      "color": Colors.orange,
    },
    {
      "name": "Grocery",
      "name_th": "ของใช้ในบ้าน",
      "icon": Image.asset('assets/icons/grocery.png'), // Custom Icon
      "color": Colors.blue,
    },
    {
      "name": "Milk",
      "name_th": "นม",
      "icon": Image.asset('assets/icons/milk.png'), // Custom Icon
      "color": Colors.brown,
    },
    {
      "name": "Internet",
      "name_th": "อินเทอร์เน็ต",
      "icon": Image.asset('assets/icons/internet.png'), // Custom Icon
      "color": Colors.purple,
    },
    {
      "name": "Clothing",
      "name_th": "เสื้อผ้า",
      "icon": Image.asset('assets/icons/clothes.png'), // Custom Icon
      "color": Colors.pink,
    },
    {
      "name": "Insurance",
      "name_th": "ประกันภัย",
      "icon": Image.asset('assets/icons/insurance.png'), // Custom Icon
      "color": Colors.teal,
    },
    {
      "name": "Education",
      "name_th": "การศึกษา",
      "icon": Image.asset('assets/icons/graduation.png'), // Custom Icon
      "color": Colors.indigo,
    },
    {
      "name": "Transportation",
      "name_th": "การเดินทาง",
      "icon": Image.asset('assets/icons/logistic.png'), // Custom Icon
      "color": Colors.yellow,
    },
    {
      "name": "Healthcare",
      "name_th": "สุขภาพ",
      "icon": Image.asset('assets/icons/health-check.png'), // Custom Icon
      "color": Colors.red,
    },
    {
      "name": "Entertainment",
      "name_th": "ความบันเทิง",
      "icon": Image.asset('assets/icons/movie.png'), // Custom Icon
      "color": Colors.lightBlue,
    },
    {
      "name": "Dining Out",
      "name_th": "ทานอาหารนอกบ้าน",
      "icon": Image.asset('assets/icons/dining.png'), // Custom Icon
      "color": Colors.deepOrange,
    },
    {
      "name": "Phone Bill",
      "name_th": "ค่าโทรศัพท์",
      "icon": Image.asset('assets/icons/smartphone.png'), // Custom Icon
      "color": Colors.green,
    },
    {
      "name": "Rent",
      "name_th": "ค่าเช่า",
      "icon": Image.asset('assets/icons/house.png'), // Custom Icon
      "color": Colors.grey,
    },
    {
      "name": "Water",
      "name_th": "ค่าน้ำ",
      "icon": Image.asset('assets/icons/bill-payment.png'), // Custom Icon
      "color": Colors.blueAccent,
    },
    {
      "name": "Electricity",
      "name_th": "ค่าไฟฟ้า",
      "icon": Image.asset('assets/icons/electricity-bill.png'), // Custom Icon
      "color": Colors.amber,
    },
    {
      "name": "Others",
      "name_th": "อื่นๆ",
      "icon": Image.asset('assets/icons/delivery-box.png'), // Custom Icon
      "color": Colors.black,
    },
  ];
}
