import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smartrecycler/common/colors.dart';

import 'UserPage/login.dart';
import 'UserPage/userRetrofit/User.dart';
import 'UserPage/userRetrofit/UserRepository.dart';

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
  late final UserRepository _UserRepository;

  String profileName = '';

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = '';

  @override
  void initState() {
    Dio dio = Dio();

    _UserRepository = UserRepository(dio);

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    super.initState();
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');
    if (userInfo != null) {
      return userInfo;
    }
  }

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
      onPressed: () {
        showDialog(context: context, builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('로그아웃 하실 건가요?',style: TextStyle(color: Colors.black,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 20),),
            actions: [
              TextButton(
                child: Text('예',style: TextStyle(color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
                onPressed: (){
                  storage.delete(key: "login");
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
                },
              ),
              TextButton(
                child: Text('아니오',style: TextStyle(color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
        );
      },
      child: Text('로그아웃', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w500)),
    ),
    ]
  ),
  body: SingleChildScrollView(
    child: Column( // 스택으로 child를 쌓음
      children:<Widget> [
        FutureBuilder<User>(
            future: findUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final User result = snapshot.data;
              String nickname ='';
              int remain = 100 -result.exp!.toInt();
              if(result.exp!<=10){
                nickname="재활용 꿈나무";
              }else if(result.exp!>10&&result.exp!<=30){
                nickname="재활용 초보";
              }
              if (snapshot.hasData == false) {
                return const ListTile(
                    title: Center(child: CircularProgressIndicator()));
              }
              else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 15),
                  ),
                );
              }
              else {
                return Stack(
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
                    Positioned( //프로필 사진
                        top: 70,
                        left: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 85.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage('https://smartrecycler-bucket.s3.ap-northeast-2.amazonaws.com/Profile/${result.profileImage}'),
                            radius: 80.0,
                          ),
                        )
                    ),
                    Positioned(
                        top: 250,
                        left: 0,
                        right: 0,
                        child: Text('${result.profileName}', style: TextStyle(color: Colors.black,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 30),textAlign: TextAlign.center,)
                    ),
                    Positioned(
                        top: 298,
                        left: 0,
                        right: 0,
                        child: Text('칭호:$nickname', style: TextStyle(color: Colors.black,
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
                          percent: result.exp!.toDouble()/100,
                          center:  Text("${result.exp.toString()}%",style: TextStyle(color: Colors.black,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: 50),textAlign: TextAlign.center,),
                          progressColor: mainGreen,)
                    ),
                    Positioned(
                        top: 650,
                        left: 0,
                        right: 0,
                        child: Text('다음 칭호까지\n$remain' ,style: TextStyle(color: Colors.black,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 16),textAlign: TextAlign.center,)
                    ),
                  ],
                );
              }
            }
        ),

      ],
    ),
  ),
  );
  }
  Future<User> findUser() async {
    int uid = int.parse(await _asyncMethod());
    final User user = await _UserRepository.getUser(uid);
    return user;
  }
}
