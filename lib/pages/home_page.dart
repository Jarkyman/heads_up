import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/controllers/event_controller.dart';
import 'package:heads_up/controllers/settings_controller.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/app_constants.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/word_page.dart';
import 'package:heads_up/pages/settings_page.dart';
import 'package:heads_up/widgets/buy_dialog.dart';
import 'package:heads_up/widgets/icon_button.dart';

import '../helper/ad_helper.dart';
import '../widgets/buy_or_try_dialog.dart';
import '../widgets/show_consent_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RewardedAd? _rewardedAd;
  bool isAdLoaded = false;
  String gdprStatus = 'none';

  @override
  void initState() {
    showConsentForm(isForTest: false, testDeviceId: 'TEST_DEVICE_ID');
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
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          setState(() {
            isAdLoaded = false;
          });
          debugPrint('Failed to load a rewarded ad: ${err.message}');
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
                          // — Logo + title —
                          Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.height20,
                              bottom: Dimensions.height10,
                            ),
                            child: Hero(
                              tag: AppConstants.LOGO_TAG,
                              child: SizedBox(
                                height: 120,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimensions.width45),
                                  child: Image.asset('assets/images/Icon.png'),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Who Am I?',
                            style: TextStyle(
                              fontSize: Dimensions.font26 * 1.1,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              shadows: const [
                                Shadow(
                                  blurRadius: 12,
                                  color: Color(0x66000000),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20 * 1.5),

                          // — Category grid —
                          Padding(
                            padding: EdgeInsets.all(Dimensions.width10),
                            child: GetBuilder<CategoryController>(
                              builder: (categoryController) {
                                return GetBuilder<SettingsController>(
                                  builder: (settingsController) {
                                    List<CategoryModel> allCategories = [];
                                    allCategories
                                        .addAll(categoryController.categories);
                                    allCategories.addAll(
                                        categoryController.ownCategories);
                                    int listLength = allCategories.length;
                                    if (settingsController.isUnlockAll) {
                                      debugPrint('add one more (add)');
                                      //listLength += 1;
                                    }
                                    return Wrap(
                                      spacing: Dimensions.width10,
                                      runSpacing: Dimensions.width10,
                                      direction: Axis.horizontal,
                                      children:
                                          List.generate(listLength, (index) {
                                        bool isLocked = false;
                                        int amountOfFreeCategories = 7;
                                        if (index > amountOfFreeCategories &&
                                            !settingsController.isUnlockAll) {
                                          isLocked = true;
                                        }
                                        debugPrint('$index/$listLength');
                                        /*if (index + 1 == listLength &&
                                              !isLocked) {
                                            debugPrint('object');
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
                                                debugPrint('PopUp');
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

                          // — Event tile —
                          GetBuilder<CategoryController>(
                              builder: (categoryController) {
                            return GetBuilder<EventController>(
                                builder: (eventController) {
                              eventController.getDate();
                              bool showEvent = false;
                              CategoryModel? category;
                              if (eventController.getEventStatus !=
                                  EventStatus.none) {
                                category = categoryController.categoryForEvent(
                                    eventController.getEventStatus);
                                showEvent = category != null;
                              }
                              return showEvent
                                  ? Padding(
                                      padding:
                                          EdgeInsets.all(Dimensions.width20),
                                      child: EventTile(
                                        onTap: () => Get.to(
                                            () => const WordPage(),
                                            arguments: [category, true]),
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

              // — Settings button —
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: () => Get.to(() => const SettingsPage()),
                  icon: Icons.settings_outlined,
                ),
              ),

              // — Unlock / lock button —
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

// ─────────────────────────────────────────────
// EventTile
// ─────────────────────────────────────────────
class EventTile extends StatefulWidget {
  const EventTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              height: Dimensions.height20 * 10,
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(widget.category.colorHex).withValues(alpha: 0.55),
                    Color(widget.category.colorHex).withValues(alpha: 0.30),
                  ],
                ),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.2,
                ),
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
                        widget.category.iconUrl,
                        colorFilter: ColorFilter.mode(
                            Colors.white.withValues(alpha: 0.9),
                            BlendMode.srcIn),
                      ),
                    ),
                  ),
                  Center(
                      child: Text(
                    widget.category.category,
                    style: TextStyle(
                      fontSize: Dimensions.font26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 8, color: Color(0x55000000)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CategoryTile
// ─────────────────────────────────────────────
class CategoryTile extends StatefulWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
    required this.locked,
    this.isOwn = false,
  });

  final CategoryModel category;
  final VoidCallback onTap;
  final bool locked;
  final bool isOwn;

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        debugPrint('Edit');
      },
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: Dimensions.height10 * 16,
              width: Dimensions.height10 * 14,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(widget.category.colorHex).withValues(alpha: 0.55),
                    Color(widget.category.colorHex).withValues(alpha: 0.28),
                  ],
                ),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  if (widget.locked)
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Dimensions.iconSize32 * 2,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.height10 * 0.8),
                          child: SvgPicture.asset(
                            widget.category.iconUrl,
                            colorFilter: ColorFilter.mode(
                              Colors.white
                                  .withValues(alpha: widget.locked ? 0.35 : 0.9),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10 * 0.5),
                        child: Text(
                          widget.category.category.tr,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                                .withValues(alpha: widget.locked ? 0.4 : 1.0),
                            shadows: const [
                              Shadow(
                                blurRadius: 6,
                                color: Color(0x44000000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
