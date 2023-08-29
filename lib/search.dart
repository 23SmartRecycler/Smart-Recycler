import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/search_result.dart';

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

  String searchText = '';

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.shopping_cart_outlined,
    Icons.settings,
    Icons.person
  ];

  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
  List<String> itemContents = [
    'Item 1 Contents',
    'Item 2 Contents',
    'Item 3 Contents',
    'Item 4 Contents'
  ];

  TextEditingController textController = TextEditingController();

  void cardClickEvent(BuildContext context, int index) {
    String content = itemContents[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        // 정의한 ContentPage의 폼 호출
        builder: (context) => SearchResultPage(),
      ),
    );
  }

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: widget.search,
                      hintStyle: TextStyle(color: gray03),
                      filled: true,
                      fillColor: gray01,
                      isDense: true,
                      contentPadding: EdgeInsets.all(16),//내부 padding값 설정
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color:gray02),
                          borderRadius: BorderRadius.circular(25)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color:Colors.black),
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16,right: 16),
                  height: 400,
                  child: ListView.builder(
                    // items 변수에 저장되어 있는 모든 값 출력
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      // 검색 기능, 검색어가 있을 경우
                      if (searchText.isNotEmpty &&
                          !items[index]
                              .toLowerCase()
                              .contains(searchText.toLowerCase())) {
                        return SizedBox.shrink();
                      }
                      // 검색어가 없을 경우, 모든 항목 표시
                      else {
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.elliptical(20, 20))),
                          child: ListTile(
                            title: Text(items[index]),
                            textColor: Colors.black,
                            onTap: () => cardClickEvent(context, index),
                          ),
                        );
                      }
                    },
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
