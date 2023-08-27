import 'package:flutter/material.dart';

class GiftExplanationPage extends StatelessWidget {
  const GiftExplanationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GiftExplanation(),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}

class GiftExplanation extends StatefulWidget {
  const GiftExplanation({super.key});

  @override
  State<GiftExplanation> createState() => _GiftExplanationState();
}

class _GiftExplanationState extends State<GiftExplanation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.green,
        leading: SizedBox(
          width: 1000,
          child: TextButton(onPressed: (){Navigator.pop(context);},
            child: Text('뒤로 가기',style: TextStyle(color: Colors.white,),),
          ),
        ),
        title: Text('기프티콘',style: TextStyle(color: Colors.white,fontFamily: 'Pretendard',fontWeight: FontWeight.w600)),
      ),
      body: ListView(children: [
        ItemImageBox(),
        ItemExplanationBox(),
        ExchangeButton(),
      ],),
    );
  }
}

class ItemImageBox extends StatelessWidget {
  const ItemImageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 250,
      color: Colors.green,
      child: Container(
        margin:EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Text(''),
      ),
    );
  }
}

class ItemExplanationBox extends StatefulWidget {
  const ItemExplanationBox({super.key});

  @override
  State<ItemExplanationBox> createState() => _ItemExplanationBoxState();
}

class _ItemExplanationBoxState extends State<ItemExplanationBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('기프티콘 설명', style: TextStyle(fontSize: 26)),
          /*
          * 상품명
          * */
          Container(
            decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.black12))),
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 18,),
                Flexible(fit: FlexFit.tight, child: Container(
                      padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text('상품명', style: TextStyle(fontSize: 18))
                  ),),
                Text('기프티콘 이름'),
              ],
            ),
          ),
          /*
          * 유효기간
          * */
          Container(
            decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.black12))),
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 18,),
                Flexible(fit: FlexFit.tight, child: Container(
                    padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text('유효기간', style: TextStyle(fontSize: 18))
                ),),
                Text('2XXX.XX.XX'),
              ],
            ),
          ),
          /*
          * 주의 사항
          * */
          Container(
            decoration: BoxDecoration(border: BorderDirectional(bottom: BorderSide(color: Colors.black12))),
            child: Row(
                  children: [
                    Icon(Icons.circle, color: Colors.green, size: 18,),
                    Flexible(fit: FlexFit.tight, child: Container(
                        padding: EdgeInsets.only(left: 10), margin: EdgeInsets.symmetric(vertical: 10),
                        child: Text('주의 사항', style: TextStyle(fontSize: 18))
                    ),),
                    Text(''),
                  ],
                ),
            ),
          // 주의 사항 내용
          Container(margin: EdgeInsets.only(top: 10),
            child: Text(style: TextStyle(color: Colors.black54),
              '주의 사항 내용 \n주의 사항 내용 주의 사항 내용 주의 사항 내용 주의 사항 내용 주의 사항 내용')
          ),
      ],),
    );
  }
}

class ExchangeButton extends StatelessWidget {
  const ExchangeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),

        child: ButtonTheme(
          child: ElevatedButton(
            onPressed: (){showDialog(
                context: context,
                builder: (context) {return ExchangeDialog();},
                barrierDismissible: false ,);
            },
            child: Text('교환하기',style: TextStyle(fontSize: 18,color: Colors.white, fontWeight: FontWeight.w600,),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(343, 51),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              textStyle: TextStyle(fontFamily: 'Pretendard',fontWeight: FontWeight.w600),
            ),
          )
        ),
      );
  }
}



class ExchangeDialog extends StatelessWidget {
  const ExchangeDialog({super.key});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: Container(padding: EdgeInsets.all(10),
        child:Column(mainAxisSize: MainAxisSize.min,
          children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('기프티콘 교환', style: TextStyle(fontSize: 20),),
          ),
          Text('4700 포인트로 기프티콘을 \n교환하시겠습니까?',textAlign: TextAlign.center,),
      ],)),
      actions: [
        Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          /*
          * 교환하기 버튼
          * */
          Container(
           margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(color: Colors.green,
                borderRadius: BorderRadius.circular(90)
            ),
            child: TextButton(
              onPressed: (){Navigator.pop(context);},
              child: Center(
                child: Text('교환하기',
                  style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.w600,),),
              ),
            ),
          ),

          /*
          * 취소 버튼
          * */
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextButton(
              onPressed: (){Navigator.pop(context);},
              child: Center(
                child: Text('취소',
                  style: TextStyle(fontSize: 20,color: Colors.green, fontWeight: FontWeight.w600,),),
              ),
            ),
          ),

        ],)
      ],
    );
  }
}
