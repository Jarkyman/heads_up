import os
import re

files_to_fix = [
    "lib/controllers/event_controller.dart",
    "lib/controllers/review_controller.dart",
    "lib/controllers/settings_controller.dart",
    "lib/controllers/word_controller.dart",
    "lib/data/api/api_client.dart",
    "lib/pages/game pages/result_page.dart",
    "lib/pages/home_page.dart",
    "lib/pages/settings_page.dart",
    "lib/splash_page.dart",
    "lib/widgets/buy_or_try_dialog.dart",
    "lib/widgets/show_consent_form.dart"
]

for file_path in files_to_fix:
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Add foundation import if debugPrint will be used and it's not already imported
    if "print(" in content and "import 'package:flutter/foundation.dart';" not in content:
        # insert after first import or at top
        if "import " in content:
            content = content.replace("import ", "import 'package:flutter/foundation.dart';\nimport ", 1)
        else:
            content = "import 'package:flutter/foundation.dart';\n" + content

    # Replace print( with debugPrint(
    content = re.sub(r'\bprint\(', 'debugPrint(', content)

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content)
