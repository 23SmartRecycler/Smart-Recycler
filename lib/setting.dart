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
    );
  }
}
