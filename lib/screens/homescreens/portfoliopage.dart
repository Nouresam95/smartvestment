import 'package:flutter/material.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart';
import 'package:smartvestment/localization/app_localizations.dart'; // ✅ استيراد الترجمة

class PortfolioPage extends StatelessWidget {
  final String? projectName;

  const PortfolioPage({super.key, this.projectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('no_investments'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(83, 0, 0, 0),
                      border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('explore_opportunities'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromARGB(255, 56, 31, 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ✅ إضافة الأزرار الثابتة أعلى المحتوى
          const GlobalAssistantButtons(),
        ],
      ),
    );
  }
}
