import 'package:flutter/material.dart';
import 'package:smartrecycler/detection.dart';

import 'common/colors.dart';


class ChoicePage extends StatelessWidget {
  const ChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Choice_main(),
    );
  }
}

class Choice_main extends StatelessWidget {
  const Choice_main({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //뒤로가기 버튼 색상
        ),
        title: Text('분리수거 선택', style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
        //elevation: 0.0,
        backgroundColor: Colors.green,
        //centerTitle: true,
      ),
      body: Align(
          alignment: Alignment.center,
        child:SingleChildScrollView(
          child:Column(
            children:<Widget> [
              TextButton.icon(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp(id: 0)));},
                icon: Icon(Icons.recycling),
                label: Text('pollution detection'),
                style: TextButton.styleFrom(primary: mainGreen, textStyle: TextStyle(fontSize: 20,fontFamily: 'Pretendard',fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 30.0,),
              TextButton.icon(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp(id: 1)));},
                icon: Icon(Icons.delete),
                label: Text('class detection'),
                style: TextButton.styleFrom(primary: mainGreen, textStyle: TextStyle(fontSize: 20, fontFamily: 'Pretendard',fontWeight: FontWeight.w600),),
              ),
            ],
          ),
        )
      ),
    );
  }
}

