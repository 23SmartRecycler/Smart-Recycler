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
      body: Column(children: [
        Flexible(flex:4, child:ItemImageBox()),
        Flexible(flex:7, child: ItemExplanationBox()),
      ],),
    );
  }
}

class ItemImageBox extends StatelessWidget {
  const ItemImageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Container(
        margin:EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      )
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


