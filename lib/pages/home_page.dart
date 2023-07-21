import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/app_constants.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/word_page.dart';
import 'package:heads_up/pages/settings_page.dart';
import 'package:heads_up/widgets/buy_dialog.dart';
import 'package:heads_up/widgets/icon_button.dart';

import '../helper/ad_helper.dart';
import '../widgets/buy_or_try_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RewardedAd? _rewardedAd;
  bool isAdLoaded = false;
  String gdprStatus = 'none';

  @override
  void initState() {
    //GdprDialog.instance.resetDecision(); //For test only
    GdprDialog.instance
        .showDialog(isForTest: false, testDeviceId: '')
        .then((onValue) {
      setState(() {
        gdprStatus = 'dialog result == $onValue';
        print('RESULT = ' + gdprStatus);
      });
    });

    _loadRewardedAd();
    /*SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      //DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.initState();
  }

  @override
  dispose() {
    /*SystemChrome.setPreferredOrientations([
      //DeviceOrientation.landscapeRight,
      //DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );
          setState(() {
            isAdLoaded = true;
          });

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          setState(() {
            isAdLoaded = false;
          });
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: BackgroundImage(
        showAnimation: true,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        children: [
                          Hero(
                            tag: AppConstants.LOGO_TAG,
                            child: SizedBox(
                              height: 145,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width45),
                                child: Image.asset('assets/images/Icon.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.width20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width10),
                            child: GetBuilder<CategoryController>(
                              builder: (_categoryController) {
                                return GetBuilder<SettingsController>(
                                  builder: (settingsController) {
                                    List<CategoryModel> allCategories = [];
                                    allCategories
                                        .addAll(_categoryController.categories);
                                    allCategories.addAll(
                                        _categoryController.ownCategories);
                                    int listLength = allCategories.length;
                                    if (settingsController.isUnlockAll) {
                                      print('add one more (add)');
                                      //listLength += 1;
                                    }
                                    return Wrap(
                                      spacing: Dimensions.width10,
                                      runSpacing: Dimensions.width10,
                                      direction: Axis.horizontal,
                                      children:
                                          List.generate(listLength, (index) {
                                        bool isLocked = false;
                                        int amountOfFreeCategories = 3;
                                        if (index > amountOfFreeCategories &&
                                            !settingsController.isUnlockAll) {
                                          isLocked = true;
                                        }
                                        print('$index/$listLength');
                                        /*if (index + 1 == listLength &&
                                              !isLocked) {
                                            print('object');
                                            return CategoryTile(
                                                locked: false,
                                                category: CategoryModel(
                                                  category: 'Add',
                                                  iconUrl:
                                                      'assets/icons/add.svg',
                                                  colorHex: 0xFFE6B400,
                                                ),
                                                onTap: () {
                                                  addCategoryDialog();
                                                });
                                          } else {*/
                                        return CategoryTile(
                                            locked: isLocked,
                                            category: allCategories[index],
                                            onTap: () {
                                              if (!isLocked) {
                                                Get.to(() => const WordPage(),
                                                    arguments: [
                                                      allCategories[index],
                                                      true,
                                                    ]);
                                              } else {
                                                buildBuyOrTryDialog(
                                                  _rewardedAd,
                                                  isAdLoaded,
                                                  allCategories[index],
                                                );
                                                print('PopUp');
                                              }
                                            });
                                      }
                                              //},
                                              ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          GetBuilder<CategoryController>(
                              builder: (_categoryController) {
                            return GetBuilder<EventController>(
                                builder: (eventController) {
                              eventController.getDate();
                              bool showEvent = false;
                              CategoryModel? category;
                              int index = 0;
                              if (eventController.getEventStatus !=
                                  EventStatus.none) {
                                //TODO: Det her kan gøres mere dynamisk
                                switch (eventController.getEventStatus) {
                                  case EventStatus.christmas:
                                    category =
                                        _categoryController.eventCategories[1];
                                    index = 1;
                                    break;
                                  case EventStatus.halloween:
                                    category =
                                        _categoryController.eventCategories[0];
                                    index = 0;
                                    break;
                                  case EventStatus.valentine:
                                    category =
                                        _categoryController.eventCategories[2];
                                    index = 2;
                                    break;
                                  case EventStatus.none:
                                    showEvent = false;
                                    break;
                                }
                                showEvent = true;
                              }
                              return showEvent
                                  ? Padding(
                                      padding:
                                          EdgeInsets.all(Dimensions.width20),
                                      child: EventTile(
                                        onTap: () => Get.to(
                                            () => const WordPage(),
                                            arguments: [
                                              _categoryController
                                                  .eventCategories[index],
                                              true
                                            ]),
                                        category: category!,
                                      ),
                                    )
                                  : Container();
                            });
                          }),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: () => Get.to(() => const SettingsPage()),
                  icon: Icons.settings_outlined,
                ),
              ),
              GetBuilder<SettingsController>(builder: (settingsController) {
                if (!settingsController.isUnlockAll) {
                  return Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        buildBuyDialog();
                      },
                      child: SizedBox(
                        height: Dimensions.width10 * 3.2,
                        child: Image.asset('assets/icons/lock.png'),
                      ),
                    ),
                  );
                } else {
                  /*return Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        //TODO: Add new word dialog
                      },
                      child: SizedBox(
                        height: Dimensions.width10 * 3.2,
                        child: Image.asset('assets/icons/plus.png'),
                      ),
                    ),
                  );*/
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  const EventTile({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Dimensions.height20 * 10,
        width: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(category.colorHex).withOpacity(0.4),
              Color(category.colorHex).withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(Dimensions.height10),
              child: SizedBox(
                height: Dimensions.iconSize32 * 3,
                width: Dimensions.iconSize32 * 3,
                child: SvgPicture.asset(
                  category.iconUrl,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Center(
                child: Text(
              category.category,
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    Key? key,
    required this.category,
    required this.onTap,
    required this.locked,
    this.isOwn = false,
  }) : super(key: key);

  final CategoryModel category;
  final VoidCallback onTap;
  final bool locked;
  final bool isOwn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print('Edit');
        //TODO: Open edit popup
      },
      onTap: onTap,
      child: Container(
        height: Dimensions.height10 * 16,
        width: Dimensions.height10 * 14,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(category.colorHex).withOpacity(0.4),
              Color(category.colorHex).withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        child: Stack(
          children: [
            if (locked)
              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.lock_outline,
                  size: 100,
                  color: Colors.grey.withOpacity(0.6),
                ),
              ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(Dimensions.height10),
                  child: SizedBox(
                    height: Dimensions.iconSize32 * 2,
                    width: Dimensions.iconSize32 * 2,
                    child: SvgPicture.asset(
                      category.iconUrl,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                Center(
                    child: Text(
                  category.category.tr,
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
