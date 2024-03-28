import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'ContentPage/contentPage.dart';
import 'UserPage/userRetrofit/User.dart';
import 'UserPage/userRetrofit/UserRepository.dart';

class ResultPage extends StatelessWidget {
  final List<List<Map<String, dynamic>>> result;
  final List<String> image;

  // 위의 인자들은 이전 페이지에서 호출받을 때 전달받을 것임
  const ResultPage(this.result, this.image, {Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {

    setPolluted();
    setResult();
    return Scaffold(
      body: Result(),
    );
  }
  void setPolluted(){
    result.forEach((element) {
      //한번 캡쳐할 때 있던 애들
      /**
       *  element = 한번 찍을 때 있던 요소들 [{box, tag, image} , {box, tag, image}]
       *  feachers = 하나의 바운딩 박스
       * **/

      element.forEach((feachers) {
        feachers["polluted"] = false;
        if (feachers["tag"] == "plastic") {
          element.forEach((others) {
            if (others["tag"] == "plastic_pollution" ||
                others["tag"] == "plastic_sticker" ||
                others["tag"] == "paper") {
              print("find ${others["tag"]}!!!!");
              print(others["box"]);
              double midx = (others["box"][2] + others["box"][0]) / 2;
              double midy = (others["box"][3] + others["box"][1]) / 2;
              print("midx : $midx  midy : $midy ");
              if (midx > feachers["box"][0] && midx < feachers["box"][2] &&
                  midy > feachers["box"][1] && midy < feachers["box"][3]) {
                feachers["polluted"] = true;
              }
            }
          });
        }
      });
    });

  }
  void setResult(){
    /**
    * 잘 전달 받았는지 확인
    **/
    if(result.isNotEmpty){
      print(result);
    }
    else {
      print("result is Empty");
    }
    if(image.isNotEmpty){
      print(image);
    }
    else{
      print("image is Empty");
    }


    MainList.clear();
    CanList.clear();
    GlassList.clear();
    PaperList.clear();
    ElseList.clear();
    /**
    * TrashList로 변경
    * */
    int idx = 0;
    result.forEach((element) {
      //한번 캡쳐할 때 있던 애들
      /**
       *  box, tag, image
       * **/
      String type = "";
      String i = image[idx];

      element.forEach((feachers) {
        String explanation = "NULL";
        List<double> box = [feachers["box"][0],feachers["box"][1],feachers["box"][2],feachers["box"][3],0.5, 0.6];
        if(feachers["tag"]!="plastic_pollution" && feachers["tag"] != "plastic_sticker"){

          if(feachers["polluted"] == true){
            explanation = "오염물을 제거해야 합니다.";
          }
          type = feachers["tag"];

          if(feachers["polluted"]){
            ElseList.add({"type": type, "explanation": explanation, "image" : i, "box": box});
          }
          else if (feachers["tag"] == "plastic"){
            MainList.add({"type": type, "explanation": explanation, "image" : i, "box": box});
          }
          else if (feachers["tag"] == "can"){
            CanList.add({"type": type, "explanation": explanation, "image" : i, "box": box});
          }
          else if (feachers["tag"] == "glass"){
            GlassList.add({"type": type, "explanation": explanation, "image" : i, "box": box});
          }
          else {
            PaperList.add({"type": type, "explanation": explanation, "image" : i, "box": box});
          }
        }
      });
      idx++;
    });
  }

}


class MyClipper extends CustomClipper<Path>{
  late List<double> box = [];
  late double width;
  late double height;
  MyClipper(this.box, this.width, this.height);

  @override
  Path getClip(Size size){
    double factorX = size.width/width;
    double factorY = size.height/height;

    print("getClip :::: box:");
    print(box);
    Path path  = Path();

    if(height ==0){
      path.moveTo(box[0]*factorX/2, 0.0);
      path.lineTo(box[0]*factorX/2, size.height);
      path.lineTo(box[2]*factorX/2, size.height);
      path.lineTo(box[2]*factorX/2, 0.0);
      path.close();
    }
    else{
      path.moveTo(box[0]*factorX/2, box[1]*factorY*0.6);
      path.lineTo(box[0]*factorX/2, box[3]*factorY*0.6);
      path.lineTo(box[2]*factorX/2, box[3]*factorY*0.6);
      path.lineTo(box[2]*factorX/2, box[1]*factorY*0.6);
      path.close();

    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper){
    return true;
  }

}


class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = '';

  late final UserRepository _UserRepository;

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
      appBar: AppBar(
        leadingWidth: 70,
        leading: SizedBox(
          child: TextButton(onPressed: (){Navigator.pop(context);},
            child: Text('back',style: TextStyle(color: Colors.green,),),
          ),
        ),
        title: Text('결과',style: TextStyle(color: Colors.black,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
        actions: [TextButton(onPressed: (){
          goMain();
        }, child: Text('New', style: TextStyle(color: Colors.green),))],
      ),
      body: ListView(children: [
        ResultBars(),
        ResultDetails(),
        ResultPoints(),
      ],)
    );
  }
  void goMain() async {
    int uid = int.parse(await _asyncMethod());
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Cont(uid: uid,)),);
  }
}



class ResultBars extends StatefulWidget {
  const ResultBars({super.key});

  @override
  State<ResultBars> createState() => _ResultBarsState();
}

class _ResultBarsState extends State<ResultBars> {

  @override
  Widget build(BuildContext context) {
    int total = calcTotal();
    return Container(
      margin: EdgeInsets.all(30), padding: EdgeInsets.all(10),
      height: 250,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black38.withOpacity(0.6), spreadRadius: 0.0, blurRadius: 5, offset: Offset(0, 4))],
        color: Color(0xFFFFFBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, style: BorderStyle.solid)
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          /*
          * 플라스틱으로 분류된 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Flexible(
              flex: 8,
              child: StepProgressIndicator(
                roundedEdges: Radius.circular(10),
                size: 10,
                totalSteps: total,
                currentStep: MainList.length,
                unselectedColor: Color(0x28000000),
                selectedColor: Colors.green,
                direction: Axis.vertical,
                progressDirection: TextDirection.rtl,
                padding: 0,
              ),
            ),
            Flexible(flex: 2, child: Text('플라스틱',)),
          ],),
          /*
          * 캔으로 분류된 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Flexible(
              flex: 8,
              child: StepProgressIndicator(
                roundedEdges: Radius.circular(10),
                size: 10,
                totalSteps: total,
                currentStep: CanList.length,
                unselectedColor: Color(0x28000000),
                selectedColor: Colors.green,
                direction: Axis.vertical,             // 막대가 세로로
                progressDirection: TextDirection.rtl, // 선택된 색이 아래로
                padding: 0,
              ),
            ),
            Flexible(flex: 2, child: Text('캔',textAlign: TextAlign.center,)),
          ],),
          /*
          * 유리병으로 분류된 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 8,
                child: StepProgressIndicator(
                  roundedEdges: Radius.circular(10),
                  size: 10,
                  totalSteps: total,
                  currentStep: GlassList.length,
                  unselectedColor: Color(0x28000000),
                  selectedColor: Colors.green,
                  direction: Axis.vertical,             // 막대가 세로로
                  progressDirection: TextDirection.rtl, // 선택된 색이 아래로
                  padding: 0,
                ),
              ),
              Flexible(flex: 2, child: Text('유리병',textAlign: TextAlign.center,)),
            ],),
          /*
          * 종이로 분류된 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 8,
                child: StepProgressIndicator(
                  roundedEdges: Radius.circular(10),
                  size: 10,
                  totalSteps: total,
                  currentStep: PaperList.length,
                  unselectedColor: Color(0x28000000),
                  selectedColor: Colors.green,
                  direction: Axis.vertical,             // 막대가 세로로
                  progressDirection: TextDirection.rtl, // 선택된 색이 아래로
                  padding: 0,
                ),
              ),
              Flexible(flex: 2, child: Text('종이',textAlign: TextAlign.center,)),
            ],),
          /*
          * 기준 분류와 다르게 분류된 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                flex: 8,
                child: StepProgressIndicator(
                  roundedEdges: Radius.circular(10),
                  size: 10,
                  totalSteps: total,
                  currentStep: ElseList.length,
                  unselectedColor: Color(0x28000000),
                  selectedColor: Colors.green,
                  direction: Axis.vertical,             // 막대가 세로로
                  progressDirection: TextDirection.rtl, // 선택된 색이 아래로
                  padding: 0,
                ),
              ),
              Flexible(flex: 2, child: Text('else',textAlign: TextAlign.center,)),
            ],),

      ],),
    );
  }
}

int calcTotal(){
  int sum = MainList.length + ElseList.length + CanList.length + GlassList.length + PaperList.length;
  if(sum > 0){
    return sum;
  }
  else{
    return 1;
  }
}


class ResultDetails extends StatefulWidget {
  const ResultDetails({super.key});

  @override
  State<ResultDetails> createState() => _ResultDetailsState();
}

class _ResultDetailsState extends State<ResultDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      //padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('상세내용', style: TextStyle(fontSize: 23)),
          ),
          /*
          * 기준 분류와 동일한 쓰레기들, 개수
          * */
          CorrectPanel(),
        ],),
    );
  }
}

class ResultPoints extends StatefulWidget {
  const ResultPoints({super.key});

  @override
  State<ResultPoints> createState() => _ResultPointsState();
}

class _ResultPointsState extends State<ResultPoints> {

  static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  dynamic userInfo = '';

  late final UserRepository _UserRepository;

  @override
  void initState() {
    Dio dio = Dio();

    _UserRepository = UserRepository(dio);

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
      update();
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
  int cntCorrect = MainList.length + CanList.length + GlassList.length + PaperList.length;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 100),
      child: Text('${(cntCorrect - ElseList.length)*100} Point획득!!',
        style: TextStyle(color: Colors.green,fontSize: 23),)
    );
  }

  void update() async { // 포인트 갱신하기
    int uid = int.parse(await _asyncMethod());
    final update = await _UserRepository.updatePoint(uid, -(cntCorrect-ElseList.length)*100);
    var logger = Logger();
    logger.d(update.toString());
    if(!update){
      Fluttertoast.showToast(
          msg: '포인트 갱신 실패',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }else{
      Fluttertoast.showToast(
          msg: '포인트 갱신 성공!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

}

/*
* json 형식의 detecting 한 쓰레기들 정보
* ++++++++++++++++++++ img 정보 추가해야함.
* */
final MainList = [];
final ElseList = [];
final CanList = [];
final GlassList = [];
final PaperList = [];

class CorrectPanel extends StatefulWidget {
  const CorrectPanel({super.key});

  @override
  State<CorrectPanel> createState() => _CorrectPanelState();
}

class _CorrectPanelState extends State<CorrectPanel> {
  bool _expanded1 = false;
  bool _expanded2 = false;
  bool _expanded3 = false;
  bool _expanded4 = false;
  bool _expanded5 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26))
      ),
      child: ExpansionPanelList(
        elevation: 0,
        children: [
          ExpansionPanel(
            canTapOnHeader: true, // 아래 화살표 이외의 부분을 눌러도 가능하게
            headerBuilder: (context, isExpanded) {return
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(margin:EdgeInsets.only(left: 20),
                        child: Icon(Icons.circle, color: Colors.green, size: 18,)),
                    Flexible(fit: FlexFit.tight, child: Container(
                        padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text('플라스틱', style: TextStyle(fontSize: 18))
                    ),),

                    Text('${MainList.length}개'),
                  ],
                ),
              );
            },
            body: CorrectContainer(MainList),
            isExpanded: _expanded1,
          ),
          ExpansionPanel(
            canTapOnHeader: true, // 아래 화살표 이외의 부분을 눌러도 가능하게
            headerBuilder: (context, isExpanded) {return
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(margin:EdgeInsets.only(left: 20),
                        child: Icon(Icons.circle, color: Colors.green, size: 18,)),
                    Flexible(fit: FlexFit.tight, child: Container(
                        padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text('캔', style: TextStyle(fontSize: 18))
                    ),),

                    Text('${CanList.length}개'),
                  ],
                ),
              );
            },
            body: CorrectContainer(CanList),
            isExpanded: _expanded2,
          ),
          ExpansionPanel(
            canTapOnHeader: true, // 아래 화살표 이외의 부분을 눌러도 가능하게
            headerBuilder: (context, isExpanded) {return
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(margin:EdgeInsets.only(left: 20),
                        child: Icon(Icons.circle, color: Colors.green, size: 18,)),
                    Flexible(fit: FlexFit.tight, child: Container(
                        padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text('유리병', style: TextStyle(fontSize: 18))
                    ),),

                    Text('${GlassList.length}개'),
                  ],
                ),
              );
            },
            body: CorrectContainer(GlassList),
            isExpanded: _expanded3,
          ),
          ExpansionPanel(
            canTapOnHeader: true, // 아래 화살표 이외의 부분을 눌러도 가능하게
            headerBuilder: (context, isExpanded) {return
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(margin:EdgeInsets.only(left: 20),
                        child: Icon(Icons.circle, color: Colors.green, size: 18,)),
                    Flexible(fit: FlexFit.tight, child: Container(
                        padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text('종이', style: TextStyle(fontSize: 18))
                    ),),

                    Text('${PaperList.length}개'),
                  ],
                ),
              );
            },
            body: CorrectContainer(PaperList),
            isExpanded: _expanded4,
          ),
          ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(margin:EdgeInsets.only(left: 20),
                      child: Icon(Icons.circle, color: Colors.green, size: 18,)),
                  Flexible(fit: FlexFit.tight, child: Container(
                      padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text('else', style: TextStyle(fontSize: 18))
                  ),),
                  Text('${ElseList.length}개'),
                ],
              ),
            );},
            body: IncorrectContainer(),
            isExpanded: _expanded5,
          ),
        ],
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            if(panelIndex == 0){
              _expanded1 = !_expanded1;
            }
            if(panelIndex == 1){
              _expanded2 = !_expanded2;
            }
            if(panelIndex == 2){
              _expanded3 = !_expanded3;
            }
            if(panelIndex == 3){
              _expanded4 = !_expanded4;
            }
            if(panelIndex == 4){
              _expanded5 = !_expanded5;
            }
          });
        },
      ),
    );
  }
}


/*
* 기준과 같은 쓰레기 정보를 받아서 그리드를 만드는 위젯
* 쓰레기 정보 = {type, explanation, img}
* */
class CorrectContainer extends StatefulWidget {
  final List<dynamic> list;
  const CorrectContainer(this.list, {Key? key}):super(key: key);
  @override
  State<CorrectContainer> createState() => _CorrectContainerState();
}

class _CorrectContainerState extends State<CorrectContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: (widget.list.length / 1.5).ceil() * (MediaQuery.of(context).size.width / 1.7), // 한 행에 들어가는 위젯이 3개일 때
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.list.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,        // 한 행에 들어갈 위젯 수
          childAspectRatio: 1/1.9,    // 위젯의 가로 세로 비율
          crossAxisSpacing: 20,     // 한 행의 위젯 간 간격 -> 이걸로 위젯 크기 조절
          mainAxisSpacing: 20,      // 한 열의 위젯 간 간격

        ),

        itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
                children: [
                  Text('${widget.list[index]["type"]}'),
                  ClipPath(
                    clipper: MyClipper(widget.list[index]["box"], width, height),
                    child: Container(margin: EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width/4),
                      child: Image.file(
                        File(widget.list[index]["image"]!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}


/*
* 기준과 다른 쓰레기 정보를 받아서 그리드를 만드는 위젯
* 쓰레기 정보 = {type, explanation, img}
* */
class IncorrectContainer extends StatefulWidget {
  const IncorrectContainer({super.key});

  @override
  State<IncorrectContainer> createState() => _IncorrectContainerState();
}

class _IncorrectContainerState extends State<IncorrectContainer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: (ElseList.length) * (MediaQuery.of(context).size.width/3), // 한 행에 들어가는 위젯이 3개일 때
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),

        itemCount: ElseList.length,

        itemBuilder: (context, index){
          return Container(height: (MediaQuery.of(context).size.width/3),
              child: Row(children: [
                /*
                * 이미지가 들어갈 컨테이너
                * */
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipPath(
                      clipper: MyClipper(ElseList[index]["box"], width, 0),
                    child: Container(
                      width: (MediaQuery.of(context).size.width/3),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(ElseList[index]["image"]!))
                        ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                /*
                * 분류와 설명
                * */
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('분류: ${ElseList[index]['type']}'),
                  Text('원인: ${ElseList[index]['explanation']}'),
                ],)
              ],)
          );
        })
    );
  }
}