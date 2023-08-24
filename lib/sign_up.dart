import 'package:flutter/material.dart';
import 'package:smartrecycler/common/colors.dart';
import 'common/colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'findPassword.dart';

bool _isChecked=false;
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // debugShowCheckedModeBanner: false,
      // title: 'Login',
      // home: LogIn(),
      body: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignupState();
}

class _SignupState extends State<SignUp> {

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
          title: Text('회원가입', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false), //자동으로 백버튼 생성 방지)
      body: SingleChildScrollView(
        child:
        Form(
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.grey,
                  inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.teal, fontSize: 15.0))),
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                  // SingleChildScrollView으로 감싸 줌
                  child: SingleChildScrollView(
                    child: Column(
                      children:<Widget> [
                        TextField(
                          decoration: InputDecoration(
                            hintText: '이름',
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
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 16,),
                        TextField(
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
                        SizedBox(height: 16,),
                        TextField(
                          decoration:
                          InputDecoration(
                            hintText: '비밀번호',
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
                        SizedBox(height: 32.0,),
                        Padding(
                          padding:const EdgeInsets.only(left: 0.0),
                          child: Row(
                            children: <Widget> [
                              Transform.scale(
                                scale: 1.0,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3)),
                                  activeColor: Colors.white,
                                  checkColor: mainGreen,
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value!;
                                    });
                                  },
                                ),
                              ),
                              Text('개인정보 수집 및 이용에 동의합니다.',style: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w400,color: gray04),),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.0,),
                        ButtonTheme(
                            padding: EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              onPressed: () {;},
                              child: Text('회원가입'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainGreen,
                                minimumSize: Size(343, 51),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                textStyle: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                        SizedBox(height: 19.0,),
                        TextButton(onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => FindPasswordPage()));},
                          child: Text('비밀번호 찾기'),
                          style: TextButton.styleFrom(primary: mainGreen,textStyle: const TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),

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
}

