import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import 'userRetrofit/UserRepository.dart';
import '../common/colors.dart';

class FindPasswordPage extends StatelessWidget {
  const FindPasswordPage

  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // debugShowCheckedModeBanner: false,
      // title: 'Login',
      // home: LogIn(),
      body: FindPassword(),
    );
  }
}

  class FindPassword extends StatefulWidget {
    @override
    State<FindPassword> createState() => _FindPasswordState();

  }

  class _FindPasswordState extends State<FindPassword> {
    late final UserRepository _UserRepository;

    @override
    void initState() {
      Dio dio = Dio();

      _UserRepository = UserRepository(dio);

      super.initState();
    }
  var _bottomNavIndex = 0;

  final iconList = <IconData>[
  Icons.home_filled,
  Icons.shopping_cart_outlined,
  Icons.settings,
  Icons.person
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
       appBar: AppBar(
         title: Text('비밀번호 찾기', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
         elevation: 0.0,
         backgroundColor: Colors.white,
         centerTitle: true,
         automaticallyImplyLeading: false,//자동으로 백버튼 생성 방지
     ),
      body: SingleChildScrollView(
        child:
        Form(
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.white,
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
              child: Container(
                  padding: EdgeInsets.all(16.0), // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                  // SingleChildScrollView으로 감싸 줌
                  child: SingleChildScrollView(
                    key: _formKey,
                    child: Column(
                      children:<Widget> [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: '이메일',
                            hintStyle: TextStyle(color: gray03),
                            filled: true,
                            fillColor: gray01,
                            isDense: true,
                            contentPadding: EdgeInsets.all(16),//내부 padding값 설정
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color:gray02),
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 16)
                        ),
                        TextField(
                          controller: _nameController,
                          decoration:
                          InputDecoration(
                            hintText: '이름',
                            hintStyle: TextStyle(color:gray03),
                            filled: true,
                            fillColor: gray01,
                            isDense: true,
                            contentPadding: EdgeInsets.all(16),//내부 padding값 설정
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1,color:gray02),
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true, // 비밀번호 안보이도록 하는 것
                           ),
                           SizedBox(height: 132.0,),
                        ButtonTheme(
                            padding: EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {getTmpPassword();},
                              child: Text('임시 비밀번호 발급'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                minimumSize: Size(343, 51),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                textStyle: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                      ],
                    ),
                  )),
            )),
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
    void getTmpPassword() async {
    var logger = Logger();
      final tmp = await _UserRepository.getPassword(_emailController.text, _nameController.text);
    logger.d('tmp'+tmp.toString());
      if(!tmp){
        Fluttertoast.showToast(
            msg: '존재하지 않는 이메일이거나 이메일과 사용자 이름이 일치하지 않습니다.',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            fontSize: 20,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT);
      }
    }
 }
