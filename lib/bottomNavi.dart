import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/common/colors.dart';
import 'package:smartrecycler/ContentPage/contentPage.dart';
import 'package:smartrecycler/gift.dart';
import 'package:smartrecycler/profile.dart';
import 'package:smartrecycler/setting.dart';

import 'choice_main.dart';


class BottomNaviPage extends StatelessWidget {
  const BottomNaviPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavi(),
    );
  }
}

class BottomNavi extends StatefulWidget {
  const BottomNavi({Key? key}) : super(key: key);

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  int _selectedIndex = 0;

  final List<Widget> _navIndex = [ //바텀 네비게이션 이벤트 index
    ContentPage(),
    GiftPage(),
    SettingPage(),
    ProfilePage()
  ];

  void _onNavTapped(int index) { // 바텀 네비게이션 클릭 시 이벤트
    setState(() {
      _selectedIndex = index;
    });
  }

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.shopping_cart_outlined,
    Icons.settings,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: _navIndex.elementAt(_selectedIndex),
    floatingActionButton: FloatingActionButton(
    child: Icon(
    Icons.center_focus_weak,
    size: 30,
    color: Colors.white,
    ),
    backgroundColor: mainGreen,
    onPressed: () {
       Navigator.push(context, MaterialPageRoute(builder: (context) => ChoicePage()));
    },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: AnimatedBottomNavigationBar.builder(
    itemCount: iconList.length,
    tabBuilder: (int index, bool isActive) {
    final color = isActive ? activeNavigationBarColor : notActiveNavigationBarColor;
    return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    iconList[index],
    size: 24,
    color: color,
    ),
    const SizedBox(height: 4),
    ],
    );
    },
    backgroundColor: Colors.white,
    activeIndex: _selectedIndex,
    splashColor: activeNavigationBarColor,
    splashSpeedInMilliseconds: 300,
    notchSmoothness: NotchSmoothness.softEdge,
    gapLocation: GapLocation.center,
    onTap: _onNavTapped,
    ),
    );
  }
}