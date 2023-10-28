import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartrecycler/UserPage/findPassword.dart';
import 'package:smartrecycler/UserPage/sign_up.dart';
import 'package:smartrecycler/common/colors.dart';

import '../bottomNavi.dart';
import 'userRetrofit/UserRepository.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // debugShowCheckedModeBanner: false,
      // title: 'Login',
      // home: LogIn(),
      body: LogIn(),
    );
  }
}

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late final UserRepository _UserRepository;
  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();
    Dio dio = Dio();

    _UserRepository = UserRepository(dio);

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavi()));
    } else {
      Fluttertoast.showToast(
          msg: '로그인이 필요합니다',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
      appBar: AppBar(
        title: Text('로그인', style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
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
                            controller: _passwordController,
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
                          SizedBox(height: 132.0,),
                          ButtonTheme(
                              padding: EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                  onPressed: () {login();},
                                child: Text('로그인'),
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
                            style: TextButton.styleFrom(primary: mainGreen, textStyle: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600),),
                          ),
                          SizedBox(height: 10.0,),
                          TextButton(onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUpPage()));},
                                child: Text('회원가입'),
                            style: TextButton.styleFrom(primary: mainGreen, textStyle: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600),),
                          ),
                        ],
                      ),
                    )),
              )),
      ),
    );
  }
  void login() async {
    final login = await  _UserRepository.login(_emailController.text, _passwordController.text);
    if(login==-1){
      Fluttertoast.showToast(
          msg: '이메일 혹은 비밀번호가 일치하지 않습니다.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }else{
      var val = login.toString();
      await storage.write(
        key: 'login',
        value: val,
      );
      Fluttertoast.showToast(
          msg: '로그인 성공\n 환영합니다!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavi())) ;
    }
  }
}