import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartrecycler/gift_explanation.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'GifticonPage/Gifticon.dart';
import 'GifticonPage/GifticonRepository.dart';
import 'UserPage/userRetrofit/User.dart';
import 'UserPage/userRetrofit/UserRepository.dart';

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          width: 1000,
          child: TextButton(onPressed: (){Navigator.pop(context);},
            child: const Text('뒤로 가기',style: TextStyle(color: Colors.green,),),
          ),
        ),
        title: const Text('교환하기',style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
        actions: [TextButton(onPressed: (){}, child: const Text('추가 하기',style: TextStyle(color: Colors.green,),))],
      ),
      body: const SingleChildScrollView(
        child: Column(//mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            point(),
            gifticon(),
          ],
        ),
      ),
    );
  }
}


// 개인 잔여 포인트 박스
class point extends StatefulWidget {
  const point({super.key});


  @override
  State<point> createState() => _pointState();
}

class _pointState extends State<point> with WidgetsBindingObserver {
  //future 데이터 캐싱
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  // userRepository
  late final UserRepository _userRepository;
  static const storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = '';

  @override
  void initState(){
    WidgetsBinding.instance.addObserver(this);
    Dio dio = Dio();
    _userRepository = UserRepository(dio);

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
  Future<int> findUsersPoint() async{
    int uid = int.parse(await _asyncMethod());
    final User user = await _userRepository.getUser(uid);
    return user.point!.toInt();
  }

  findUserPoint() {
    return _memoizer.runOnce(() async {
      int uid = int.parse(await _asyncMethod());
      final User user = await _userRepository.getUser(uid);
      return user.point!.toInt();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: findUsersPoint(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData == false){
          return const CircularProgressIndicator();
        }
        else if(snapshot.hasError){
          return Padding(
            padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 15),
              ),
          );
        }
        else {
          int curPoint = snapshot.data;
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            child: SizedBox(
              width: 300,
              height: 300,
              child: CircularStepProgressIndicator(
                  totalSteps: 10000,
                  currentStep: curPoint,
                  stepSize: 10,
                  selectedColor: Colors.greenAccent,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 150,
                  height: 150,
                  selectedStepSize: 15,
                  //roundedCap: (_, __) => true, // 이거 엄청 느려짐
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$curPoint Point',
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.green,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '$curPoint/10000',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )),
            ),
          );
          }
        }
    );
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
    return Container(width: double.infinity, height: 1000, margin: const EdgeInsets.only(left: 10),padding: EdgeInsets.all(2.0),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('기프티콘',style: TextStyle(fontSize: 20,),),
        GridItems(),
      ],),
    );
  }
}

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
  // 기프티콘 리포지토리 생성
  late final GifticonRepository _gifticonRepository;
  dynamic gifticonInfo = ' ';

  @override
  void initState(){
    Dio dio = Dio();
    _gifticonRepository = GifticonRepository(dio);

    super.initState();
  }

  Future<List<GifticonItem>> list() async {

    final List<GifticonItem> list = await _gifticonRepository.list();

    return list;
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: FutureBuilder<List<GifticonItem>>(
        future: list(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //데이터가 없으면
          if(snapshot.data == null){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError){
            return Padding(
              padding : const EdgeInsets.all(8.0),
              child: Text('Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 15),
              ),
            );
          }
          else{
            final List<GifticonItem> result = snapshot.data;
            return GridView.builder(
              //그리드 뷰 자동 스크롤 없애기
              physics: const NeverScrollableScrollPhysics(),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 1행에 보여줄 아이템 수
                childAspectRatio: 1 / 1.5, // item 의 가로 1, 세로 1 의 비율
                mainAxisSpacing: 8, // 수평 padding
                crossAxisSpacing: 5, // 수직 padding
              ),

              itemCount: result.length,
              itemBuilder: (BuildContext context, int index) {
                final content = result[index];
                return gifticonContainer(
                  image : content.gimage.toString(),
                  name: content.gname.toString(),
                  cost: content.price.toString(),
                  expireData: content.expireData.toString(),
                );
              },
            );
          }
        }
      ),
    );
  }

/*
* 기프티콘 하나의 컨테이너 위젯
* {기프티콘 이미지, 이름, 필요 포인트 표시}
* 이미지 클릭 후 상세 페이지로 이동
* */
  Widget gifticonContainer({String image = "0", String name = "0", String cost = "0", String expireData= "0"}){
    return Column( crossAxisAlignment: CrossAxisAlignment.start,
      children: [InkWell(
        onTap: () {
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => GiftExplanationPage(image,name,expireData,cost))
          );
        },
        child: Container(
          width: 100, height: 100,
          margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black12,
          ),
          child: Ink.image(image: NetworkImage('https://smartrecycler-bucket.s3.ap-northeast-2.amazonaws.com/Gifticons/${image}')),
        ),
      ),
      Text('$name'),
      Text('필요 포인트: $cost'),
    ],);
  }

}
