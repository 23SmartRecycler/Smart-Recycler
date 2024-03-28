import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../common/colors.dart';
import 'methodRetrofit/Rmethod.dart';
import 'methodRetrofit/RmethodRepository.dart';

class SearchResultPage extends StatelessWidget {
  const SearchResultPage

  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchResult(mid: 0,),
    );
  }
}
class SearchResult extends StatefulWidget {
  final int mid;
  const SearchResult({Key? key,required this.mid}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late final RmethodRepository _rmethodRepository;
  String img='';
  @override
  void initState() {
    Dio dio = Dio();

    _rmethodRepository = RmethodRepository(dio);

    super.initState();
  }

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
            FutureBuilder<Rmethod>(
              future: getMethod(widget.mid),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                final Rmethod result = snapshot.data;
                if(result.img!.isEmpty){
                  img = 'basic.jpg';
                }else{
                  img ='${result.img}';
                }
                if (snapshot.hasData == false) {
                  return const ListTile(
                      title: Center(child: CircularProgressIndicator()));
                }
                else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }else{
                  return Column(
                    children: <Widget>[
                      Center(
                        child:Image.network('https://smartrecycler-bucket.s3.ap-northeast-2.amazonaws.com/Rmethod/$img'),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 30.0),
                        child: Text('${result.title}', style: TextStyle(color: Colors.black,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 24)),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 8.0),
                        child: Text('${result.method}',
                            style: TextStyle(color: gray04,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ),
                    ],
                  );
                }
                }
            ),
          ],
        ),
      ),
      );
  }
  Future<Rmethod> getMethod(int mid) async{
    final Rmethod rmethod = await _rmethodRepository.getRmethod(mid);
    return rmethod;
  }
}


