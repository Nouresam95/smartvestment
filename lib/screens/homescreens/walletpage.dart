import 'package:flutter/material.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart';
import 'package:smartvestment/localization/app_localizations.dart'; // ✅ استيراد الترجمة

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBarOther(),
        body: Stack(
          children: [
            Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        AppLocalizations.of(context).translate('payments'),
                        style: const TextStyle(
                          fontSize: 20, // ✅ تغيير الحجم
                          fontWeight: FontWeight.bold, // ✅ جعل الخط عريض
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('money_management'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      PaymentsTab(),
                      MoneyManagementTab(),
                    ],
                  ),
                ),
              ],
            ),
            // ✅ إضافة زرّي المساعد وجعلهم ثابتين في كل التبويبات
            const GlobalAssistantButtons(),
          ],
        ),
      ),
    );
  }
}

class PaymentsTab extends StatelessWidget {
  const PaymentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate('no_due_payments'),
            style: const TextStyle(
              fontSize: 24, // ✅ تغيير الحجم
              fontWeight: FontWeight.bold, // ✅ جعل الخط عريض
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              // الانتقال إلى الصفحة الرئيسية
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainPage()),
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(83, 0, 0, 0), // يجعل البوكس شفاف
                border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 2,
                ), // إطار خارجي
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                AppLocalizations.of(context).translate('explore_opportunities'),
                style: const TextStyle(
                  fontSize: 20, // ✅ تغيير الحجم
                  fontWeight: FontWeight.bold, // ✅ جعل الخط عريض
                  color: Color.fromARGB(255, 56, 31, 3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MoneyManagementTab extends StatelessWidget {
  const MoneyManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${AppLocalizations.of(context).translate('balance')}: EGP 0",
            style: const TextStyle(
              fontSize: 22, // ✅ تغيير الحجم
              fontWeight: FontWeight.bold, // ✅ جعل الخط عريض
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: null,
            child: Text(
              AppLocalizations.of(context).translate('manage_finances'),
              style: const TextStyle(
                fontSize: 24, // ✅ تغيير الحجم
                fontWeight: FontWeight.bold, // ✅ جعل الخط عريض
              ),
            ),
          ),
        ],
      ),
    );
  }
}
