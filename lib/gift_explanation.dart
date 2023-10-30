import 'package:flutter/material.dart';

class GiftExplanationPage extends StatefulWidget {
  final String image;
  final String? name;
  final String? expireData;
  final String? cost;

  // 위의 인자들은 이전 페이지에서 호출받을 때 전달받을 것임
  const GiftExplanationPage(this.image, this.name, this.expireData, this.cost,{Key? key}):super(key: key);

  @override
  State<GiftExplanationPage> createState() => _GiftExplanationPageState();
}

class _GiftExplanationPageState extends State<GiftExplanationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GiftExplanation(image:widget.image, name:widget.name, expireData:widget.expireData, cost:widget.cost),
    );
  }
}

class GiftExplanation extends StatefulWidget {
  // 부모 클래스에서 매개변수 전달받음
  const GiftExplanation({
    super.key,
    this.image,
    this.name,
    this.expireData,
    this.cost,
});
  final String? image;
  final String? name;
  final String? expireData;
  final String? cost;
  //const GiftExplanation({super.key});

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
        ItemImageBox(image:widget.image),
        ItemExplanationBox(name:widget.name, expireData:widget.expireData),
        ExchangeButton(cost: widget.cost),
      ],),
    );
  }
}

class ItemImageBox extends StatefulWidget {
  // 부모 클래스에서 매개변수 전달받음
  const ItemImageBox({
    super.key,
    this.image,
  });
  final String? image;
  //const ItemImageBox({super.key});

  @override
  State<ItemImageBox> createState() => _ItemImageBoxState();
}

class _ItemImageBoxState extends State<ItemImageBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.green,
      child: Container(
        margin:const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10)),),
        child: Image.network('https://smartrecycler-bucket.s3.ap-northeast-2.amazonaws.com/Gifticons/${widget.image}'),
      ),
    );
  }
}

class ItemExplanationBox extends StatefulWidget {
  // 부모 클래스에서 매개변수 전달받음
  const ItemExplanationBox({
    super.key,
    this.name,
    this.expireData
  });
  final String? name;
  final String? expireData;
  //const ItemExplanationBox({super.key});

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
                Text('${widget.name}'),
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

                Text('${widget.expireData}'),//'2XXX.XX.XX'
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
              '주의 사항 내용 \n1. 포인트 결제 방식이기 때문에 구매 후 구매 취소/환불을 요청할 수 없습니다.'
                  '\n2. 유효기간 이후에는 사용이 불가능합니다.'
                  '\n3. 미성년자인 회원이 서비스를 이용하여 상품 등을 구매 시 법정 대리인이 해당 계약에 대하여 동의를 하여야 정상적인 상품 등의 구매계약이 체결될 수 있습니다.')
          ),
      ],),
    );
  }
}

class ExchangeButton extends StatefulWidget {

  const ExchangeButton({
    super.key,
    this.cost,
  });
  final String? cost;
  //const ExchangeButton({super.key});

  @override
  State<ExchangeButton> createState() => _ExchangeButtonState();
}

class _ExchangeButtonState extends State<ExchangeButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: ButtonTheme(
          child: ElevatedButton(
            onPressed: (){showDialog(
              context: context,
              builder: (context) {return ExchangeDialog(cost:widget.cost);},
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

class ExchangeDialog extends StatefulWidget {
  const ExchangeDialog({
    super.key,
    this.cost,
  });
  final String? cost;

  @override
  State<ExchangeDialog> createState() => _ExchangeDialogState();
}

class _ExchangeDialogState extends State<ExchangeDialog> {
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
              Text('${widget.cost} 포인트로 기프티콘을 \n교환하시겠습니까?',textAlign: TextAlign.center,),
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
