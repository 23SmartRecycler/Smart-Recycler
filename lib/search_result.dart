import 'package:flutter/material.dart';

import 'common/colors.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage

  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchResult(),
    );
  }
}
class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
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
            color: mainGreen,
          ),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child:Image(image: AssetImage("assets/images/can.png")),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 30.0),
              child: Text('우산 분리수거 방법', style: TextStyle(color: Colors.black,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 24)),
            ),
            Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 8.0),
                child: Text('2023.06.17', style: TextStyle(color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16)),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 8.0),
              child: Text('-먼저 가위나 칼을 이용해 우산 천(또는 비닐)과 우산대(우산살)를 분리해요.\n\n'
                  ' -우산대에 매듭지어져 있는 실과 우산 헤드의 접합 부분을 잘라내면 비교적 쉽게 분리됩니다.\n\n'
                  ' -우산대는 캔류(철) 로 분리배출해요.\n\n'
                  ' -분리한 우산 천은 일반쓰레기(종량제봉투)로 버리고, 비닐우산의 비닐은 비닐류로 배출해요.\n',
                  style: TextStyle(color: gray04,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 16)),
            ),
          ],
        ),
      ),
      );
  }
}


