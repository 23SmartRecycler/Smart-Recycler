import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:smartrecycler/UserPage/changePassword.dart';
import 'package:smartrecycler/common/colors.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:smartrecycler/UserPage/login.dart';

import 'UserPage/userRetrofit/UserRepository.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Setting(uid: 0,),
    );
  }
}

class Setting extends StatefulWidget {
  final int uid;
  const Setting({Key? key,required this.uid}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  late final UserRepository _UserRepository;

  @override
  void initState() {
    Dio dio = Dio();

    _UserRepository = UserRepository(dio);

    super.initState();
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
          color: Colors.white,
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
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(uid: widget.uid)));
                  },child: Text("비밀번호 변경"),
                    style: TextButton.styleFrom(primary: Colors.black,textStyle: const TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              Row(
                children: [
                  Icon(Icons.gpp_maybe),
                  SizedBox(width:33,),
                  TextButton(onPressed: (){
                    deleteUser();
                  },child: Text("회원 탈퇴"),
                      style: TextButton.styleFrom(primary: Colors.black,textStyle: const TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
                  ),
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
    );
  }
  void deleteUser()async {
    try{
      final delete = await _UserRepository.deleteUser(widget.uid);
      Fluttertoast.showToast(
          msg: '회원탈퇴 성공! 감사합니다.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
    }on DioError catch(e){
      var logger = Logger();
      logger.d('error log: ${e.response?.statusCode}');
    }

  }
}
