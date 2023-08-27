import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/choice_main.dart';
import 'package:smartrecycler/detection.dart';
import 'package:smartrecycler/gift.dart';
import 'package:smartrecycler/gift_explanation.dart';
import 'package:smartrecycler/gift_explanation_button_clicked.dart';
import 'package:smartrecycler/login.dart';
import 'package:smartrecycler/content.dart';
import 'package:smartrecycler/profile.dart';
import 'package:smartrecycler/result.dart';
import 'package:smartrecycler/result_detail.dart';
import 'package:smartrecycler/search.dart';
import 'package:smartrecycler/search_result.dart';
import 'package:smartrecycler/setting.dart';
import 'package:smartrecycler/sign_up.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:smartrecycler/common/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key,});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _bottomNavIndex = 0;

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.shopping_cart_outlined,
    Icons.settings,
    Icons.person
  ];

  static List<Widget> pages = <Widget>[
    ContentPage(),
    GiftPage(),
    SettingPage(),
    ProfilePage(),
  ];

  void _onTap(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: //pages[_bottomNavIndex], 바텀 네비게이션 구현함. 실행하려면 아래 container 코드만 지우고 pages[] 주석 해제하면 됨
      Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            UseableIcon(),
            Pages(),
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
        activeIndex: _bottomNavIndex,
        splashColor: activeNavigationBarColor,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        onTap: _onTap,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class Pages extends StatelessWidget {
  const Pages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
        Text('(아래 구현페이지 나누고 바꾸기)'),
        Text('진혁'),
        Row(children: [
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));}, child: Text('login')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ContentPage()));}, child: Text('content')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));}, child: Text('profile')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));}, child: Text('setting')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));}, child: Text('sign_up')),
        ],),
        Text('혁준'),
        Row(children: [
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ChoicePage()));}, child: Text('Choice')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => DetectionPage()));}, child: Text('Detection')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GiftPage()));}, child: Text('Gift')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GiftExplanationPage()));}, child: Text('GiftEx')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => GiftExplanationButtonClickPage()));}, child: Text('GiftExBC')),
        ],),
        Text('민수'),
        Row(children: [
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));}, child: Text('Result')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ResultDetailPage()));}, child: Text('ResultDetail')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));}, child: Text('Search')),
          TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage()));}, child: Text('SearchResult')),
        ],),
      ]),
    );
  }
}


class UseableIcon extends StatelessWidget {
  const UseableIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black)
        ),
        child: Column(
          children: [
            Text('사용 아이콘 통일'),
            Container(
              padding: EdgeInsets.all(5),
              child:
              Row(children: [
                Icon(Icons.home_filled),
                Icon(Icons.shopping_cart_outlined),
                Icon(Icons.center_focus_weak),
                Icon(Icons.settings),
                Icon(Icons.person),
                Icon(Icons.arrow_back_ios),
              ],),
            ),
          ],
        )
    );
  }
}
