import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  iconTheme: const IconThemeData(
  color: Colors.white, //뒤로가기 버튼 색상
  ),
  title: Text('프로필', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
  elevation: 0.0,
  backgroundColor: mainGreen,
  centerTitle: true,
  ),
  body: Container(
    child: Column(
      children: [
        Container(
          height: 200,
          color: mainGreen,
        )
      ],
    ),
  ),

  bottomNavigationBar: BottomAppBar(),
  );
  }
}
