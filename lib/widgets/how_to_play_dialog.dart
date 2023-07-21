import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';

void buildHowToDialog() {
  List<String> howToPlayList = [
    'Choose a category, such as food, animals, technology, etc. Then select a person to hold the phone to their forehead.'
        .tr,
    'The other players give hints about the word without saying the word directly. The person holding the phone tries to guess the word using the hints.'
        .tr,
    'If the word is guessed correctly, the person holding the phone tilts the phone down to get points. The person can skip the word by tilting the phone up.'
        .tr,
    'The game continues with new words until time runs out. At the end of the game, you can see all the words and see how many correct guesses you got.'
        .tr,
    'It\'s a simple but fun and challenging game that can be played by people of all ages and can be a fun activity with friends and family or a challenging competition with a group of colleagues or classmates.'
        .tr,
  ];

  Get.bottomSheet(
    HowToWidget(howToPlayList: howToPlayList),
  );
}

class HowToWidget extends StatefulWidget {
  const HowToWidget({Key? key, required this.howToPlayList}) : super(key: key);

  final List<String> howToPlayList;

  @override
  State<HowToWidget> createState() => _HowToWidgetState();
}

class _HowToWidgetState extends State<HowToWidget> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.screenHeight / 2.5,
      width: Dimensions.width45 * 6,
      decoration: BoxDecoration(
        color: AppColors.lightPurpleColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimensions.radius30),
          topLeft: Radius.circular(Dimensions.radius30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Dimensions.height30,
          ),
          Text(
            'How to play'.tr,
            style: TextStyle(
                fontSize: Dimensions.font26, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          Expanded(
            child: SizedBox(
                child: PageView.builder(
              itemCount: widget.howToPlayList.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width15),
                  child: Text(
                    widget.howToPlayList[index],
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                    ),
                  ),
                );
              },
            )),
          ),
          PageIndicatorDots(
              length: widget.howToPlayList.length, currentPage: _currentPage),
          SizedBox(
            height: Dimensions.height30,
          ),
        ],
      ),
    );
  }
}

class PageIndicatorDots extends StatelessWidget {
  const PageIndicatorDots({
    Key? key,
    required this.length,
    required int currentPage,
  })  : _currentPage = currentPage,
        super(key: key);

  final int length;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.width5),
              child: Container(
                width: index == _currentPage ? 16 : 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: index == _currentPage
                    ? Container(
                        width: 16,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.darkPurpleColor,
                        ),
                      )
                    : Container(),
              ));
        },
      ),
    );
  }
}
