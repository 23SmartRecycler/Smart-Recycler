import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:smartrecycler/search.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
import 'common/colors.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Content(),
    );
  }
}

  class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
  }

  class _ContentState extends State<Content> {

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
      'Down' : getScaleRightMatrix,
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
            Container(
              margin: EdgeInsets.all(12),
              child:AnimSearchBar(
                width: 400,
                searchIconColor: gray03,
                textFieldColor: gray01,
                textController: textController,
                onSuffixTap: () {
                  setState(() {
                    textController.clear();
                  });
                }, onSubmitted: (String s) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Search(search: s,)
                    )
                );
              },
              ),
            ),
            SizedBox(
              height: 200,
              child: IndexedStack(
                children: [
                  TransformableListView.builder(
                    controller: ScrollController(),
                    padding: EdgeInsets.zero,
                    getTransformMatrix: getScaleDownMatrix,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: index.isEven ? gray02 : mainGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(index.toString()),
                      );
                    },
                    itemCount: 10,
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.all(12),
                alignment: Alignment.bottomLeft,
                child: const Text('동네 소식', style: TextStyle(color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    fontSize: 24),)
            ),
            Container(
              margin: const EdgeInsets.only(top: 12,bottom:12),
              height: 400,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    height: 170,
                    width: 130,
                    color: gray02,
                    child:const Center(
                        child:Text('1번 이야기')
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                  ),
                  Container(
                    height: 170,
                    width: 130,
                    color: mainGreen,
                    child:const Center(
                        child:Text('2번 이야기')
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                  ),
                ],
              ),
            )

          ]
      ),
    ),
  );
    }
  }
