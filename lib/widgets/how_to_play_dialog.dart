import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';

void buildHowToDialog({bool isChameleon = false}) {
  List<String> howToPlayList = isChameleon
      ? [
          'Choose a category and set up the number of players and Chameleons. Everyone will get a secret word, but the Chameleon will only see "You are the Chameleon!".'
              .tr,
          'Pass the phone around so each player can secretly view their role. Make sure no one else sees your screen!'
              .tr,
          'Once everyone knows their role, each player takes turns saying exactly one word related to the secret word.'
              .tr,
          'The Chameleon doesn\'t know the word, so they must listen carefully and try to blend in by saying a word that fits with what others are saying.'
              .tr,
          'After everyone has said their word, discuss and vote on who you think the Chameleon is. Then reveal the roles to see if you were right!'
              .tr,
        ]
      : [
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
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    isScrollControlled: true,
  );
}

void buildHowToSelectionDialog() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: EdgeInsets.all(Dimensions.height20),
            decoration: BoxDecoration(
              color: AppColors.glassWhiteStrong,
              borderRadius: BorderRadius.circular(Dimensions.radius30),
              border: Border.all(color: AppColors.glassBorder, width: 1.4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'How to play'.tr,
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                _HowToSelectionTile(
                  title: 'Who Am I'.tr,
                  onTap: () {
                    Get.back();
                    buildHowToDialog(isChameleon: false);
                  },
                ),
                SizedBox(height: Dimensions.height10),
                _HowToSelectionTile(
                  title: 'Chameleon'.tr,
                  onTap: () {
                    Get.back();
                    buildHowToDialog(isChameleon: true);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    barrierColor: Colors.black.withValues(alpha: 0.45),
  );
}

class _HowToSelectionTile extends StatelessWidget {
  const _HowToSelectionTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height15,
        ),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          border: Border.all(color: AppColors.glassBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: Dimensions.iconSize16,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class HowToWidget extends StatefulWidget {
  const HowToWidget({super.key, required this.howToPlayList});

  final List<String> howToPlayList;

  @override
  State<HowToWidget> createState() => _HowToWidgetState();
}

class _HowToWidgetState extends State<HowToWidget> {
  final PageController _pageController = PageController(
    viewportFraction: 0.86,
  );

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      top: false,
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimensions.radius30),
          topLeft: Radius.circular(Dimensions.radius30),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: Dimensions.screenHeight * 0.48,
            width: Dimensions.screenWidth > 600
                ? Dimensions.screenWidth / 1.6
                : Dimensions.screenWidth,
            padding: EdgeInsets.fromLTRB(
              Dimensions.width20,
              Dimensions.height20,
              Dimensions.width20,
              Dimensions.height20 + bottomSafeArea,
            ),
            decoration: BoxDecoration(
              color: AppColors.glassWhiteStrong,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Dimensions.radius30),
                topLeft: Radius.circular(Dimensions.radius30),
              ),
              border: Border(
                top: BorderSide(color: AppColors.glassBorder, width: 1.4),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: Dimensions.width45,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Text(
                  'How to play'.tr,
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    clipBehavior: Clip.none,
                    itemCount: widget.howToPlayList.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width10,
                        ),
                        child: Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(Dimensions.height20),
                          decoration: BoxDecoration(
                            color: AppColors.glassWhite,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            border: Border.all(
                              color: AppColors.glassBorder,
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.howToPlayList[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.font20,
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                PageIndicatorDots(
                  length: widget.howToPlayList.length,
                  currentPage: _currentPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageIndicatorDots extends StatelessWidget {
  const PageIndicatorDots({
    super.key,
    required this.length,
    required int currentPage,
  }) : _currentPage = currentPage;

  final int length;
  final int _currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) {
          final isActive = index == _currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            margin: EdgeInsets.symmetric(horizontal: Dimensions.width5),
            width: isActive ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isActive
                  ? AppColors.greenColor.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.28),
            ),
          );
        },
      ),
    );
  }
}
