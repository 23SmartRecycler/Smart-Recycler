import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:smartrecycler/UserPage/login.dart';
import 'package:smartrecycler/common/colors.dart';
import 'package:smartrecycler/ContentPage/ContentPage.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'userRetrofit/UserRepository.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // debugShowCheckedModeBanner: false,
      // title: 'Login',
      // home: LogIn(),
      body: ChangePassword(uid: 0,),
    );
  }
}

class ChangePassword extends StatefulWidget {
  final int uid;
  const ChangePassword({Key? key,required this.uid}) : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late final UserRepository _UserRepository;

  @override
  void initState() {
    Dio dio = Dio();

    _UserRepository = UserRepository(dio);

    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _oriPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

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
        title: Text('비밀번호 번경', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
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
                  padding: EdgeInsets.all(16.0),
                  // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                  // SingleChildScrollView으로 감싸 줌
                  child: SingleChildScrollView(
                    key: _formKey,
                    child: Column(
                      children:<Widget> [
                        TextField(
                          controller: _oriPasswordController,
                          decoration: InputDecoration(
                            hintText: '기존 비밀번호를 입력해주세요',
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
                          controller: _newPasswordController,
                          decoration:
                          InputDecoration(
                            hintText: '새로운 비밀번호를 입력해주세요',
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
                              onPressed: () {update();},
                              child: Text('비밀번호 변경'),
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
  void update() async {
    final update = await  _UserRepository.updatePassword(widget.uid,_oriPasswordController.text, _newPasswordController.text);
    var logger = Logger();
    logger.d(update.toString());
    if(!update){
      Fluttertoast.showToast(
          msg: '기존 비밀번호가 일치하지않습니다.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }else{
      Fluttertoast.showToast(
          msg: '비밀번호 변경 성공!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
    }
  }
}