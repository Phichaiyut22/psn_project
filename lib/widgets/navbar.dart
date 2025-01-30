import 'package:budget_tracker_application_2/screens/edit_profile_screen.dart';
import 'package:budget_tracker_application_2/screens/home_screen.dart';
import 'package:budget_tracker_application_2/screens/stock_screen.dart';
import 'package:budget_tracker_application_2/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    (HomeScreenUI()), // แทนที่ด้วยหน้าจอจริง
    (TransactionScreenUI()), // แทนที่ด้วยหน้าจอจริง
    (StockScreenUI()), // แทนที่ด้วยหน้าจอจริง
    (EditProfileScreen()), // แทนที่ด้วยหน้าจอจริง
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // ป้องกันการเลื่อนด้วยการปัด
        children: _pages,
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.5, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            iconPath: 'assets/icons/bank.png',
            index: 0,
            selectedIndex: selectedIndex,
            onTap: onDestinationSelected,
            label: 'Home',
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/icons/financial-goals.png',
            index: 1,
            selectedIndex: selectedIndex,
            onTap: onDestinationSelected,
            label: 'Transaction',
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/icons/stock.png',
            index: 2,
            selectedIndex: selectedIndex,
            onTap: onDestinationSelected,
            label: 'Stocks',
          ),
          _buildNavItem(
            context,
            iconPath: 'assets/icons/advisor.png',
            index: 3,
            selectedIndex: selectedIndex,
            onTap: onDestinationSelected,
            label: 'EditProfile',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String iconPath,
    required int index,
    required int selectedIndex,
    required ValueChanged<int> onTap,
    required String label,
  }) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5DADE2) : const Color(0xFFFAF9F6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath.endsWith('.svg'))
              SvgPicture.asset(
                iconPath,
                width: 44.0,
                height: 44.0,
              )
            else
              Image.asset(
                iconPath,
                width: 44.0,
                height: 44.0,
              ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  label,
                  style: TextStyle(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
