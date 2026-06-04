import re

files_to_fix = [
    "lib/controllers/event_controller.dart",
    "lib/controllers/review_controller.dart",
    "lib/controllers/settings_controller.dart",
    "lib/pages/game pages/result_page.dart",
    "lib/pages/home_page.dart",
    "lib/pages/settings_page.dart",
    "lib/splash_page.dart",
    "lib/widgets/buy_or_try_dialog.dart"
]

for fp in files_to_fix:
    with open(fp, "r", encoding="utf-8") as f:
        content = f.read()

    # Remove unnecessary import
    content = content.replace("import 'package:flutter/foundation.dart';\n", "")

    # Fix debugPrint arguments
    content = content.replace("debugPrint(date);", "debugPrint(date.toString());")
    content = content.replace("debugPrint(e);", "debugPrint(e.toString());")
    content = content.replace("debugPrint(settingsController.getRoundTime);", "debugPrint(settingsController.getRoundTime.toString());")
    content = content.replace("debugPrint(settingsController.getTries);", "debugPrint(settingsController.getTries.toString());")

    # Fix PurchaseType -> ProductType
    content = content.replace("PurchaseType", "ProductType")
    
    with open(fp, "w", encoding="utf-8") as f:
        f.write(content)
