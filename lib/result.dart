import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';

class ResultPage extends StatelessWidget {
  final List<List<Map<String, dynamic>>> result;
  final List<String> image;

  // 위의 인자들은 이전 페이지에서 호출받을 때 전달받을 것임
  const ResultPage(this.result, this.image, {Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    setResult();
    return Scaffold(
      body: Result(),
    );
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
    ElseList.clear();
    /**
    * TrashList로 변경
    * */
    result.forEach((element) {
      int idx = 0;
      //한번 캡쳐할 때 있던 애들
      /**
       *  box, tag, image
       * **/
      bool isPolluted = false;
      String type = "";
      String explanation = "NULL";
      //CameraImage image = element[0]["image"];
      String i = image[idx++];

      element.forEach((element) {
        if(element["tag"]=="plastic"){
          type = element["tag"];
          //image = element["image"];
        }
        else{
          isPolluted = true;
          explanation = "오염물을 제거해야 합니다.";
        }
      });
      if(isPolluted){
        ElseList.add({"type": type, "explanation": explanation, "image" : i});
      }
      else{
        MainList.add({"type": type, "explanation": explanation, "image" : i});
      }
    });

  }
}

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
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
        actions: [TextButton(onPressed: (){}, child: Text('New', style: TextStyle(color: Colors.green),))],
      ),
      body: ListView(children: [
        ResultBars(),
        ResultDetails(),
        ResultPoints(),
      ],)
    );
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
    return Container(
      margin: EdgeInsets.all(30), padding: EdgeInsets.all(10),
      height: 250,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black38.withOpacity(0.6), spreadRadius: 0.0, blurRadius: 5, offset: Offset(0, 4))],
        color: Color(0xFFFFFBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, style: BorderStyle.solid)
      ),
      child: const Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          /*
          * 기준 분류와 동일한 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Flexible(
              flex: 8,
              child: StepProgressIndicator(
                roundedEdges: Radius.circular(10),
                size: 10,
                totalSteps: 10,
                currentStep: 6,
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
          * 기준 분류와 다르게 분류된 쓰레기 Bar
          * */
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Flexible(
              flex: 8,
              child: StepProgressIndicator(
                roundedEdges: Radius.circular(10),
                size: 10,
                totalSteps: 10,
                currentStep: 4,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 100),
      child: Text('230 Point획득!!',
        style: TextStyle(color: Colors.green,fontSize: 23),)
    );
  }
}

/*
* json 형식의 detecting 한 쓰레기들 정보
* ++++++++++++++++++++ img 정보 추가해야함.
* */
final TrashList = [
  {"type": "plastic", "explanation": "NULL"},
  {"type": "plastic", "explanation": "NULL"},
  {"type": "plastic", "explanation": "NULL"},
  {"type": "plastic", "explanation": "NULL"},
  {"type": "plastic", "explanation": "NULL"},
  {"type": "plastic", "explanation": "NULL"},
  {"type": "can", "explanation": "잘못된 분류입니다."},
  {"type": "can", "explanation": "잘못된 분류입니다."},
  {"type": "plastic", "explanation": "오염물을 제거해야 합니다."},
  {"type": "glass", "explanation": "잘못된 분류입니다."},
];
// 위의 리스트가 아래 두개로 분류됨.
// explanation == NULL
final MainList = [
  // {"type": "plastic", "explanation": "NULL", "image": "assets/images/paper.png"},
  // {"type": "plastic", "explanation": "NULL", "image": "assets/images/paper.png"},
  // {"type": "plastic", "explanation": "NULL", "image": "assets/images/paper.png"},
  // {"type": "plastic", "explanation": "NULL", "image": "assets/images/paper.png"},
  // {"type": "plastic", "explanation": "NULL", "image": "assets/images/paper.png"},
  // {"type": "plastic", "explanation": "NULL", "image": "assets/images/paper.png"},
];
final ElseList = [
  // {"type": "can", "explanation": "잘못된 분류입니다.", "image": "assets/images/paper.png"},
  // {"type": "can", "explanation": "잘못된 분류입니다.", "image": "assets/images/paper.png"},
  // {"type": "plastic", "explanation": "오염물을 제거해야 합니다.", "image": "assets/images/paper.png"},
  // {"type": "glass", "explanation": "잘못된 분류입니다.", "image": "assets/images/paper.png"},
];

class CorrectPanel extends StatefulWidget {
  const CorrectPanel({super.key});

  @override
  State<CorrectPanel> createState() => _CorrectPanelState();
}

class _CorrectPanelState extends State<CorrectPanel> {
  bool _expanded1 = false;
  bool _expanded2 = false;

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
            body: CorrectContainer(),
            isExpanded: _expanded1,
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
            isExpanded: _expanded2,
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
  const CorrectContainer({super.key});

  @override
  State<CorrectContainer> createState() => _CorrectContainerState();
}

class _CorrectContainerState extends State<CorrectContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MainList.length / 3).ceil() * (MediaQuery.of(context).size.width/3), // 한 행에 들어가는 위젯이 3개일 때
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: MainList.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,        // 한 행에 들어갈 위젯 수
          childAspectRatio: 1/2,    // 위젯의 가로 세로 비율
          crossAxisSpacing: 20,     // 한 행의 위젯 간 간격 -> 이걸로 위젯 크기 조절
          mainAxisSpacing: 20,      // 한 열의 위젯 간 간격
        ),

        itemBuilder: (context, index) => AspectRatio(
          aspectRatio: 1/1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(20),

            ),
            child: Column(
              children: [
                Text('${MainList[index]["type"]}'),
                Image.file(
                  File(MainList[index]["image"]!),
                ),
              ],
            ),
          ),
        ),
      )
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
                Container(margin: EdgeInsets.all(10),width: (MediaQuery.of(context).size.width/3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12
                    ),
                  child: Image.file(File(ElseList[index]["image"]!)),
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


