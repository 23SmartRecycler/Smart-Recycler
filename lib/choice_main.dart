import 'package:flutter/material.dart';


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
      body: Grid_box(),
    );
  }
}

// RecycleItems
final List<String> names = ['플라스틱','종이','유리병','캔'];
final List<String> images = [
  'assets/images/plastic.png',
  'assets/images/paper.png',
  'assets/images/glass.png',
  'assets/images/can.png'
];


class Grid_box extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
      child: GridView.builder(
        //그리드 뷰 자동 스크롤 없애기
        //physics: const NeverScrollableScrollPhysics(),
        
        itemCount: 4,                   // 전체 아이템 수
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,            // 1행에 보여줄 아이템 수
          childAspectRatio: 1/1,        // item 의 가로 1, 세로 1 의 비율
          mainAxisSpacing: 10,          // 수평 padding
          crossAxisSpacing: 10,         // 수직 padding
        ),

        itemBuilder: (BuildContext context, int index) {
          return InkWell( // 클릭하면 애니매이션 효과 나옴(필요없으면 GestureDetector사용)

            onTap:() {
            },  //클릭했을 때 해당 카메라 촬영(detection)으로 이동해야 함

            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('${images[index]}'),
                ),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(
                '${names[index]}',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900)
              ),
            ),
          );
        },
      ),
    );
  }
}

