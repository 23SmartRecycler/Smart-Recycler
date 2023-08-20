import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/common/colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Setting(),
    );
  }
}

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.shopping_cart_outlined,
    Icons.settings,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //뒤로가기 버튼 색상
        ),
          title: Text('설정', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
          elevation: 0.0,
          backgroundColor: mainGreen,
          centerTitle: true,
          ),
      body: SingleChildScrollView(
        child:Container(
          margin: EdgeInsets.only(top: 50,right: 16,left: 16),
          padding: const EdgeInsets.all(28),
          color: gray01,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width:33,),
                  Text("프로필변경",style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600))
                ],
              ),
              SizedBox(height: 40,),
              Row(
                children: [
                  Icon(Icons.gpp_maybe),
                  SizedBox(width:33,),
                  Text("회원 탈퇴",style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600))
                ],
              ),
              SizedBox(height: 40,),
              Row(
                children: [
                  Icon(Icons.notifications_none),
                  SizedBox(width:33,),
                  Text("문의 사항",style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600))
                ],
              )
            ],
          ),
        )
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
