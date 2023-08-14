import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class GiftPage extends StatelessWidget {
  const GiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gift(),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
class gift extends StatefulWidget {
  const gift({super.key});

  @override
  State<gift> createState() => _giftState();
}

class _giftState extends State<gift> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 1000,
          child: TextButton(onPressed: (){Navigator.pop(context);},
            child: Text('뒤로 가기',style: TextStyle(color: Colors.green,),),
          ),
        ),
        title: Text('교환하기',style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
      ),
      body: ListView(//mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              point(),
              gifticon(),
            ],
          ),
    );
  }
}

/*
* point 정보를 저장할 클래스
* json에서 받아올 등급별 point 정보 = {등급.total, 회원.current}
* */
class Point{
  final int total;
  final int current;
  Point(this.total, this.current);

  Point.fromJson(Map<String, dynamic> json)
    : total = json['total'],
      current = json['current'];

  Map<String, dynamic> toJson() =>
      {
        'total': total,
        'current': current,
      };
}
final PointJson= {"total":10000, "current" : 4700,};


// 개인 잔여 포인트 박스
class point extends StatefulWidget {
  const point({super.key});

  @override
  State<point> createState() => _pointState();
}

class _pointState extends State<point> {

  Point? p = Point.fromJson(PointJson);

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center,
      margin: EdgeInsets.all(10),
      child: SizedBox(width: 300, height: 300,
        child: CircularStepProgressIndicator(
          totalSteps: 100,
          currentStep: 74,
          stepSize: 10,
          selectedColor: Colors.greenAccent,
          unselectedColor: Colors.grey[200],
          padding: 0,
          width: 150,
          height: 150,
          selectedStepSize: 15,
          roundedCap: (_, __) => true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${p!.current} Point', style: TextStyle(fontSize: 25, color: Colors.green, fontWeight: FontWeight.w700),),
              Text('${p!.current}/${p!.total}',style: TextStyle(color: Colors.grey,),),
            ],
          )
        ),
      ),
    );
  }
}

/*
* 기프티콘 그리드가 포함된 외부 박스
* */
class gifticon extends StatefulWidget {
  const gifticon({super.key});

  @override
  State<gifticon> createState() => _gifticonState();
}

class _gifticonState extends State<gifticon> {
  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,height: 800,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
        Text('기프티콘',style: TextStyle(fontSize: 20,),),
        GridItems(),
      ],),
    );
  }
}

/*
* json 형식의 기프티콘 정보
* ++++++++++++++++++++ img 정보 추가해야함.
* */
final GifticonList = [
  {"name": "1", "cost": "100"},
  {"name": "2", "cost": "200"},
  {"name": "3", "cost": "300"},
  {"name": "4", "cost": "400"},
  {"name": "5", "cost": "500"},
  {"name": "6", "cost": "600"},
  {"name": "7", "cost": "700"},
  {"name": "8", "cost": "800"},
  {"name": "9", "cost": "900"},
];

/*
* 기프티콘 정보를 받아서 그리드를 만드는 위젯
* 기프티콘 정보 = {name, cost}
* */
class GridItems extends StatefulWidget {
  const GridItems({super.key});

  @override
  State<GridItems> createState() => _GridItemsState();
}

class _GridItemsState extends State<GridItems> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        //그리드 뷰 자동 스크롤 없애기
        physics: const NeverScrollableScrollPhysics(),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,            // 1행에 보여줄 아이템 수
          childAspectRatio: 1/1.3,        // item 의 가로 1, 세로 1 의 비율
          mainAxisSpacing: 10,          // 수평 padding
          crossAxisSpacing: 10,         // 수직 padding
        ),

        itemCount: GifticonList.length,
        itemBuilder: (BuildContext context, int index) {
          return gifticonContainer(
            name: GifticonList[index]["name"] as String,
            cost: GifticonList[index]["cost"] as String,
          );
      },),
    );
  }

/*
* 기프티콘 하나의 컨테이너 위젯
* {기프티콘 이미지, 이름, 필요 포인트 표시}
* 이미지 클릭 후 상세 페이지로 이동
* */
  Widget gifticonContainer({String name = "0", String cost = "0"}){
    return Container(padding: EdgeInsets.all(10),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start,
        children: [InkWell(
          onTap: (){},
          child: Container(
            width: 100, height: 100,
            margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.black12,
            ),
          ),
        ),
        Text('기프티콘 $name'),
        Text('필요 포인트: $cost'),
      ],)
    );
  }

}
