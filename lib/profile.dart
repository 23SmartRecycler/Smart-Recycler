import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smartrecycler/common/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Profile(),
    );
  }
}

  class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
  }

  class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
  appBar: AppBar(
    title: Text('프로필', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
    elevation: 0.0,
    backgroundColor: mainGreen,
    centerTitle: true,
    leadingWidth: 100,
    leading: TextButton(
      onPressed: () {},
      child: Text('내 기프티콘', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w500)),
    ),
    actions:<Widget>[
    TextButton(
      onPressed: () {},
      child: Text('로그아웃', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w500)),
    ),
    ]
  ),
  body: SingleChildScrollView(
    child: Stack( // 스택으로 child를 쌓음
      children:<Widget> [
        Container(
          height: 700,
        ),
        Positioned( // positioned로 top 높이에 따라서 child들을 겹치게 배치가 가능하다
            top:0,
            child: Container(
              height: 160,
              width: 450,
              color: mainGreen,
            )
        ),
        const Positioned( //프로필 사진
            top: 70,
            left: 0,
            right: 0,
          child: CircleAvatar(
            radius: 85.0,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.png"),
              radius: 80.0,
            ),
          )
        ),
        const Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Text('내 이름', style: TextStyle(color: Colors.black,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 30),textAlign: TextAlign.center,)
        ),
        const Positioned(
            top: 298,
            left: 0,
            right: 0,
            child: Text('칭호: 재활용 꿈나무', style: TextStyle(color: Colors.black,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16),textAlign: TextAlign.center,)
        ),
        Positioned(
            top: 380,
            left: 0,
            right: 0,
            child: CircularPercentIndicator(
              radius: 130.0,
              lineWidth: 10.0,
              percent: 1.0,
              center: const Text("50%",style: TextStyle(color: Colors.black,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  fontSize: 50),textAlign: TextAlign.center,),
              progressColor: mainGreen,)
        ),
        const Positioned(
            top: 650,
            left: 0,
            right: 0,
            child: Text('다음 칭호까지', style: TextStyle(color: Colors.black,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16),textAlign: TextAlign.center,)
        ),
      ],
    ),
  ),
  );
  }
}
