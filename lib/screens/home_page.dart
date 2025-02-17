// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:smartvestment/screens/homescreens/morepage.dart';
import 'package:smartvestment/screens/homescreens/submit_project.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart'; // ✅ استيراد الأزرار الثابتة
import 'package:smartvestment/localization/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const CustomAppBarHomeMain(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubmitProjectPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/submit.png'),
                          fit: BoxFit.cover,
                          opacity: 0.9,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(255, 1, 0, 0).withAlpha(50),
                      ),
                      width: double.infinity,
                      height: 250,
                      padding: const EdgeInsets.all(10.0),

                      /// ✅ تعديل المحاذاة لجعل النص في **أعلى البوكس** بدلًا من أسفله
                      child: Align(
                        alignment: Alignment.topCenter, // 🔹 نقل النص للأعلى
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5), // 🔹 إضافة مسافة علوية لتحسين الشكل
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('submit_project'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Color.fromARGB(255, 0, 0, 0),
                              shadows: [
                                Shadow(
                                  offset: Offset(5, 5),
                                  blurRadius: 10,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 253, 239, 200)
                            .withAlpha(50),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('welcome_smartvestment'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 29,
                              color: Color.fromARGB(255, 0, 0, 0),
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 5,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            AppLocalizations.of(context)
                                .translate('smartvestment_intro'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color.fromARGB(255, 0, 0, 0),
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AboutUsPage(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('see_more'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const GlobalAssistantButtons(), // ✅ الأزرار الثابتة فوق كل المحتوى
        ],
      ),
    );
  }
}
