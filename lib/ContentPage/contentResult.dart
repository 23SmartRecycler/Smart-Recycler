import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/colors.dart';
import 'contentRetrofit/Content.dart';
import 'contentRetrofit/ContentRepository.dart';

class ContentResultPage extends StatelessWidget {
  const ContentResultPage

  ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentResult(cid: 0,),
    );
  }
}
class ContentResult extends StatefulWidget {
  final int cid;
  const ContentResult({Key? key,required this.cid}) : super(key: key);

  @override
  State<ContentResult> createState() => _ContentResultState();
}

class _ContentResultState extends State<ContentResult> {
  late final ContentRepository _contentRepository;
  String url ='';
  @override
  void initState() {
    Dio dio = Dio();

    _contentRepository= ContentRepository(dio);

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
            FutureBuilder<Content>(
                future: getContent(widget.cid),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  final Content result = snapshot.data;
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
                          child: Text('${result.content}',
                              style: TextStyle(color: gray04,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(left: 16.0,right: 16.0,top: 8.0),
                          child: RichText(
                            text: TextSpan(
                              text: '출처:  ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${result.slink}',
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                  ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                    url = '${result.slink}';
                                    _launch(Uri.parse(url));
                                    }
                                ),
                              ],
                            ),
                          ),
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
  Future<Content> getContent(int cid) async{
    final Content content = await _contentRepository.getContent(cid);
    return content;
  }
  Future<void> _launch(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }
}


