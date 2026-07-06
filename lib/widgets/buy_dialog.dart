import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../controllers/settings_controller.dart';
import '../../helper/app_colors.dart';
import '../../helper/dimensions.dart';
import 'premium_dialog_components.dart';

void buildBuyDialog() {
  Get.bottomSheet(
    PremiumBottomSheet(
      child: Column(
        children: [
          const PremiumSheetHandle(),
          SizedBox(height: Dimensions.height25),
          const PremiumHeroIcon(
            icon: Icons.monetization_on_outlined,
          ),
          SizedBox(height: Dimensions.height20),
          PremiumTextPanel(
            children: [
              PremiumBodyText(
                'Buy the full version, and unlock all the features.'.tr,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: Dimensions.height10),
              PremiumBodyText('Unlock all categories.'.tr),
              SizedBox(height: Dimensions.height10),
              PremiumBodyText('Remove advertisements.'.tr),
              SizedBox(height: Dimensions.height10),
              PremiumBodyText(
                'Experience the full functionality of the game.'.tr,
              ),
            ],
          ),
          const Spacer(),
          const BuyButton(),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    isScrollControlled: true,
  );
}

class BuyButton extends StatefulWidget {
  const BuyButton({
    super.key,
  });

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      StoreProduct? product;
      if (settingsController.products.isNotEmpty) {
        product = settingsController.products[0];
      }

      return PremiumActionButton(
        onTap: () async {
          if (!settingsController.isUnlockAll) {
            try {
              if (product != null) {
                PurchaseResult result = await Purchases.purchase(
                  PurchaseParams.storeProduct(product),
                );
                CustomerInfo customerInfo = result.customerInfo;
                debugPrint('Purchase info: $customerInfo');
                settingsController.unlockAllSave(true);
                debugPrint('Levels unlocked');
                Get.back();
              }
            } on PlatformException catch (e) {
              var errorCode = PurchasesErrorHelper.getErrorCode(e);
              if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                debugPrint('Failed to purchase product. ');
                //purchaseErrorSnackbar();
              }
            }
          }
        },
        title: product == null ? 'TRY AGAIN LATER'.tr : 'BUY FULL VERSION'.tr,
        price: product == null ? '' : product.priceString,
        accentColor: AppColors.greenColor,
        textColor: Colors.white,
        icon: Icons.monetization_on_outlined,
        enabled: product != null,
      );
    });
  }
}
