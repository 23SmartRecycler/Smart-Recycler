import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartrecycler/ContentPage/contentRetrofit/Content.dart';
import 'package:smartrecycler/ContentPage/contentRetrofit/ContentRepository.dart';
import 'package:smartrecycler/SearchPage/search.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

import '../UserPage/userRetrofit/User.dart';
import '../UserPage/userRetrofit/UserRepository.dart';
import '../common/colors.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Cont(uid: 0,),
    );
  }
}

  class Cont extends StatefulWidget {
  final int uid;
  const Cont({Key? key, required this.uid}) : super(key: key);

  @override
  State<Cont> createState() => _ContentState();
  }

  class _ContentState extends State<Cont> {

    late final UserRepository _UserRepository;
    late final ContentRepository _contentRepository;

    String profileName = '';
    int _maxLength = 0;

    static final storage = FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
    dynamic userInfo = '';

    @override
    void initState() {
      Dio dio = Dio();

      _UserRepository = UserRepository(dio);
      _contentRepository = ContentRepository(dio);

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

    Matrix4 getScaleDownMatrix(TransformableListItem item) {
      /// final scale of child when the animation is completed
      const endScaleBound = 0.3;

      /// 0 when animation completed and [scale] == [endScaleBound]
      /// 1 when animation starts and [scale] == 1
      final animationProgress = item.visibleExtent / item.size.height;

      /// result matrix
      final paintTransform = Matrix4.identity();

      /// animate only if item is on edge
      if (item.position != TransformableListItemPosition.middle) {
        final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

        paintTransform
          ..translate(item.size.width / 2)
          ..scale(scale)
          ..translate(-item.size.width / 2);
      }

      return paintTransform;
    }

    Matrix4 getScaleRightMatrix(TransformableListItem item) {
      /// final scale of child when the animation is completed
      const endScaleBound = 0.1;

      /// 0 when animation completed and [scale] == [endScaleBound]
      /// 1 when animation starts and [scale] == 1
      final animationProgress = item.visibleExtent / item.size.height;

      /// result matrix
      final paintTransform = Matrix4.identity();

      /// animate only if item is on edge
      if (item.position != TransformableListItemPosition.middle) {
        final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

        paintTransform
          ..translate(item.size.width / 2)
          ..scale(scale)
          ..translate(-item.size.width / 2);
      }

      return paintTransform;
    }

    late final transformMatrices = {
      'Scale': getScaleDownMatrix,
      'Down': getScaleRightMatrix,
    };

    late String currentMatrix = transformMatrices.entries.first.key;

    String searchValue = '';


    TextEditingController textController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false, // bottom overflowed by pixel 방지 코드
        body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                FutureBuilder(
                    future: findUser(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
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
                        return Container(
                            margin: const EdgeInsets.only(top: 40),
                            alignment: Alignment.center,
                            child: Text(snapshot.data + "님 환영합니다",
                              style: TextStyle(color: Colors.black,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),)
                        );
                      }
                    }
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  child: AnimSearchBar(
                    width: 400,
                    searchIconColor: gray03,
                    textFieldColor: gray01,
                    textController: textController,
                    onSuffixTap: () {
                      setState(() {
                        textController.clear();
                      });
                    },
                    onSubmitted: (String s) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Search(search: s,)
                          )
                      );
                    },
                  ),
                ),
                FutureBuilder<List<Content>>(
                    future: getContents(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {

                      if (snapshot.data == null) {
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
                        final List<Content> result = snapshot.data;
                        return SizedBox(
                          height: 200,
                          child: IndexedStack(
                              children: [
                          TransformableListView.builder(
                          scrollDirection: Axis.vertical,
                            controller: ScrollController(),
                            getTransformMatrix: getScaleDownMatrix,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            itemCount: _maxLength == null ? 0 : _maxLength * 2,
                            itemBuilder: (context, index) {
                              final content = result![index ~/ 2];
                              if (index.isOdd) {
                                return const Divider();
                              }
                              return ListTile(
                                  title: Text(content.title.toString()),
                                  subtitle: Text(content.content.toString())
                              );
                            },
                          )]
                          )
                        );
                      }
                    }
                ),
                Container(
                    margin: const EdgeInsets.all(12),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      '동네 소식', style: TextStyle(color: Colors.black,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 24),)
                ),
                FutureBuilder<List<Content>>(
                    future: getContents(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {

                      if (snapshot.data == null) {
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
                        final List<Content> result = snapshot.data;
                        return SizedBox(
                            height: 200,
                            child: IndexedStack(
                                children: [
                                  ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(8.0),
                                    itemCount: _maxLength == null ? 0 : _maxLength * 2,
                                    itemBuilder: (context, index) {
                                      final content = result![index ~/ 2];
                                      if (index.isOdd) {
                                        return const Divider();
                                      }
                                      return Container(
                                        width: 150,
                                        color: mainGreen,//배경색
                                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                        child: ListTile(
                                            visualDensity: VisualDensity(vertical: -4, horizontal: 0),
                                            dense: true,
                                            tileColor: mainGreen,
                                            title:Text(content.title.toString()),
                                            subtitle:Text(content.content.toString()),
                                          onTap: () {},
                                        ),
                                      );
                                    },
                                  )]
                            )
                        );
                      }
                    }
                ),
              ]
          ),
        ),
      );
    }
    Future<String?> findUser() async {
    int uid = int.parse(await _asyncMethod());
    final User user = await _UserRepository.getUser(uid);
    return user.profileName;
    }

    Future<List<Content>> getContents() async{
    final List<Content> list = await _contentRepository.getContents();
    _maxLength = list.length;
    return list;
    }

  }
