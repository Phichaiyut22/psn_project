import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineMonth extends StatefulWidget {
  const TimeLineMonth({
    super.key,
    required this.onChange,
  });
  final ValueChanged<DateTime?> onChange;

  @override
  State<TimeLineMonth> createState() => _TimeLineMonthState();
}

class _TimeLineMonthState extends State<TimeLineMonth> {
  DateTime currentMonth = DateTime.now();
  List<DateTime> months = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Generate list of months (12 เดือนย้อนหลัง + เดือนปัจจุบัน)
    for (int i = 12; i >= 0; i--) {
      months.add(DateTime(currentMonth.year, currentMonth.month)
          .subtract(Duration(days: 30 * i)));
    }

    // ส่งค่าเดือนปัจจุบันกลับไปยัง onChange
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChange(currentMonth);
      scrollToSelectedMonth();
    });
  }

  // Scroll ไปที่เดือนปัจจุบัน
  void scrollToSelectedMonth() {
    final selectedIndex = months.indexWhere((month) =>
        month.year == currentMonth.year && month.month == currentMonth.month);
    if (selectedIndex != -1) {
      const double itemWidth = 96.0;
      final scrollOffset = (selectedIndex * itemWidth) -
          (MediaQuery.of(context).size.width / 2 - itemWidth / 2);

      scrollController.animateTo(
        scrollOffset.clamp(0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  // จัดการเลือกเดือน
  void handleMonthSelection(DateTime selectedMonth) {
    setState(() {
      currentMonth = selectedMonth;
    });
    widget.onChange(currentMonth); // ส่งค่า DateTime กลับไปยังหน้าหลัก
    scrollToSelectedMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          final isSelected = currentMonth.year == month.year &&
              currentMonth.month == month.month;

          return GestureDetector(
            onTap: () => handleMonthSelection(month),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5DADE2)
                    : const Color(0xFFD5DBDB),
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF5DADE2).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  DateFormat('MMM y').format(month), // แสดงผลเดือน
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF424949),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
