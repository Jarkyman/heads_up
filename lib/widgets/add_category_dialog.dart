import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heads_up/controllers/categories_controller.dart';
import 'package:heads_up/models/category_model.dart';

import '../../controllers/settings_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';

final _colors = [
  0xFF35A3ED,
  0xFFE21D60,
  0xFFF09200,
  0xFFF1BA08,
  0xFF49A94D,
  0xFFD83DF3,
  0xFF2A9283,
  0xFF5656EA,
  0xFFD84001,
];

final _icons = [
  'assets/icons/animal.svg',
  'assets/icons/music.svg',
  'assets/icons/movie.svg',
  'assets/icons/food.svg',
  'assets/icons/electronic.svg',
  'assets/icons/star.svg',
  'assets/icons/sport.svg',
  'assets/icons/world.svg',
  'assets/icons/all.svg',
];

String categoryName = "";
int color = _colors[0];
String icon = _icons[0];

void addCategoryDialog() {
  final myController = TextEditingController();
  color = _colors[Random().nextInt(_colors.length)];
  icon = _icons[Random().nextInt(_icons.length)];

  Get.bottomSheet(
    Container(
      height: Dimensions.screenHeight * 0.8,
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
            height: Dimensions.height45,
          ),
          Container(
            height: Dimensions.width45 * 3,
            width: Dimensions.width45 * 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.width45 * 2),
              color: AppColors.greenColor,
            ),
            child: const Center(
              child: Icon(
                Icons.monetization_on_outlined,
                color: Colors.white,
                size: 80,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.width10,
                right: Dimensions.width10,
                top: Dimensions.width20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                  height: 60,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      labelText: "Category Name".tr,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: AppColors.lightGrayColor,
                      focusColor: AppColors.greenColor,
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 14.0,
                        bottom: 6.0,
                        top: 8.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.greenColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onSubmitted: (name) {
                      categoryName = name;
                    },
                  ),
                ),
                IconAndColorRow(),
              ],
            ),
          ),
          Expanded(child: Container()),
          GetBuilder<CategoryController>(builder: (categoryController) {
            return CustomIconButton(
              onTap: () {
                if (categoryName != "") {
                  CategoryModel newCategory = CategoryModel(
                      category: categoryName, iconUrl: icon, colorHex: color);
                  categoryController.saveOwnCategory(newCategory);
                  categoryName = "";
                  Get.back(); //TODO: Skal føre til en ny popup hvor man udfylder ord
                } else {
                  //TODO: Måske en fejl meddelse;
                }
              },
              title: 'Add Category'.tr,
              color: AppColors.greenColor,
              textColor: Colors.white,
            );
          }),
          SizedBox(
            height: Dimensions.height45,
          ),
        ],
      ),
    ),
  );
}

void buildColorDialog() {
  Get.defaultDialog(
    title: 'Choose color'.tr,
    middleText: "",
    backgroundColor: AppColors.lightGreen,
    content: SizedBox(
      height: Dimensions.screenHeight / 2,
      width: Dimensions.width45 * 6,
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(_colors.length, (index) {
              return ColorSelectCircle(
                index: index,
              );
            }),
          ),
        ),
      ),
    ),
  );
}

void buildIconDialog() {
  Get.defaultDialog(
    title: 'Choose icon'.tr,
    middleText: "",
    backgroundColor: AppColors.lightGreen,
    content: SizedBox(
      height: Dimensions.screenHeight / 2,
      width: Dimensions.width45 * 6,
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: List.generate(_icons.length, (index) {
              return IconSelectCircle(
                index: index,
              );
            }),
          ),
        ),
      ),
    ),
  );
}

class ColorSelectCircle extends StatefulWidget {
  const ColorSelectCircle({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<ColorSelectCircle> createState() => _ColorSelectCircleState();
}

class _ColorSelectCircleState extends State<ColorSelectCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          color = _colors[widget.index];
        });
        Get.back();
      },
      child: CircleAvatar(
        backgroundColor: Color(_colors[widget.index]),
      ),
    );
  }
}

class IconSelectCircle extends StatefulWidget {
  const IconSelectCircle({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<IconSelectCircle> createState() => _IconSelectCircleState();
}

class _IconSelectCircleState extends State<IconSelectCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          icon = _icons[widget.index];
        });
        Get.back();
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(_icons[widget.index]),
      ),
    );
  }
}

class IconAndColorRow extends StatefulWidget {
  const IconAndColorRow({
    Key? key,
  }) : super(key: key);

  @override
  State<IconAndColorRow> createState() => _IconAndColorRowState();
}

class _IconAndColorRowState extends State<IconAndColorRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Icon: '),
        GestureDetector(
          onTap: () {
            buildIconDialog();
          },
          child: CircleAvatar(
            child: SvgPicture.asset(icon),
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(
          width: Dimensions.width30,
        ),
        Text('Color: '),
        GestureDetector(
          onTap: () {
            buildColorDialog();
          },
          child: CircleAvatar(
            backgroundColor: Color(color),
          ),
        ),
      ],
    );
  }
}

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.color,
    this.textColor = Colors.black,
    this.isTimer = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Color color;
  final Color textColor;
  final bool isTimer;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  Timer? _countdownTimer;
  Duration myDuration = Duration();

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer!.cancel();
    super.dispose();
  }

  void startTimer() async {
    myDuration = await Get.find<SettingsController>().getTimeToNewTry();
    _countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        _countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');

    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: Dimensions.height30 * 2,
        width: Dimensions.width45 * 6.5,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: Dimensions.width10, right: Dimensions.width10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: Dimensions.font16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.isTimer)
                '$hours:$minutes:$seconds' != '00:00:00'
                    ? Text(
                        ' $hours:$minutes:$seconds',
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Stack(
                        children: [
                          Text(
                            ' 22:22:22 ',
                            style: TextStyle(
                              color: Colors.transparent,
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: Dimensions.width20,
                              ),
                              CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 4.0,
                              ),
                            ],
                          ),
                        ],
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
