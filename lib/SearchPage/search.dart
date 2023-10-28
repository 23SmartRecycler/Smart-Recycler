import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/SearchPage/methodRetrofit/RmethodParams.dart';
import 'package:smartrecycler/SearchPage/methodRetrofit/RmethodRepository.dart';
import 'package:smartrecycler/SearchPage/search_result.dart';

import '../common/colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Search(search: " ",),
    );
  }
}

class Search extends StatefulWidget {
  final String search;
  const Search({Key? key, required this.search}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}



class _SearchState extends State<Search> {

  late final RmethodRepository _rmethodRepository;
  String searchText = '';
  int _maxLength = 0;
  TextEditingController textController = TextEditingController();


  @override
  void initState() {
    Dio dio = Dio();
    if(!widget.search.isEmpty){
      textController.text=widget.search;
      searchText = textController.text;
    }
    _rmethodRepository = RmethodRepository(dio);

    super.initState();
  }



  void cardClickEvent(BuildContext context, int index,int mid) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // 정의한 ContentPage의 폼 호출
        builder: (context) => SearchResult(mid: mid),
      ),
    );
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
          actions:<Widget>[
          TextButton(
            onPressed: () {},
            child: Text('필터', style: TextStyle(color: mainGreen,fontFamily: 'Pretendard',fontWeight: FontWeight.w500)),
          ),
          ]
        ),
      body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "텍스트를 입력해주세요",
                      hintStyle: TextStyle(color: gray03),
                      filled: true,
                      fillColor: gray01,
                      isDense: true,
                      contentPadding: EdgeInsets.all(16),//내부 padding값 설정
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color:gray02),
                          borderRadius: BorderRadius.circular(25)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color:Colors.black),
                          borderRadius: BorderRadius.circular(25)
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                FutureBuilder<List<RmethodParams>>(
                    future: getMethods(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      final List<RmethodParams> result = snapshot.data;
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
                      }
                      else {
                        return SizedBox(
                            child: IndexedStack(
                                children: [
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    controller: ScrollController(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    itemCount: _maxLength == null ? 0 : _maxLength * 2,
                                    itemBuilder: (context, index) {
                                      final params = result![index ~/ 2];
                                      if (searchText.isNotEmpty &&
                                          !params.title
                                              !.toLowerCase()
                                              .contains(searchText.toLowerCase())) {
                                        return SizedBox.shrink();
                                      }else{
                                        if (index.isOdd) {
                                          return const Divider();
                                        }
                                        return ListTile(
                                          title: Text(params.title.toString()),
                                          onTap:()=> cardClickEvent(context,index,params.mid!.toInt()),
                                        );
                                      }
                                    },
                                  )]
                            )
                        );
                      }
                    }
                ),
              ],
            ),
          ),

    );
  }
  Future<List<RmethodParams>> getMethods() async{
    final List<RmethodParams> list = await _rmethodRepository.getRmethods();
    _maxLength = list.length;
    return list;
  }
}
