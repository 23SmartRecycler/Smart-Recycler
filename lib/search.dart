import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'common/colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Search(search: " ",),
    );
  }
}

class Search extends StatefulWidget {
  final String search;
  const Search({Key? key, required this.search}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.shopping_cart_outlined,
    Icons.settings,
    Icons.person
  ];

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);//뒤로가기
            },
            color: mainGreen,
          ),
          actions:<Widget>[
          TextButton(
            onPressed: () {},
            child: Text('필터', style: TextStyle(color: mainGreen,fontFamily: 'Pretendard',fontWeight: FontWeight.w500)),
          ),
          ]
        ),
      body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Text("data: ${widget.search}",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.center_focus_weak,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: mainGreen,
        onPressed: () {
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
        activeIndex: _bottomNavIndex,
        splashColor: activeNavigationBarColor,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}
