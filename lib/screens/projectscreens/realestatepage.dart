import 'package:flutter/material.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/screens/homescreens/favoritespage.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart'; // ✅ استيراد الأزرار الثابتة
import 'package:smartvestment/localization/app_localizations.dart';

class RealestatePage extends StatefulWidget {
  const RealestatePage({super.key});

  @override
  State<RealestatePage> createState() => RealestatePageState();
}

class RealestatePageState extends State<RealestatePage> {
  bool isGridView = false; // لتحديد طريقة العرض (Grid أو List)
  final List<Map<String, dynamic>> favoriteProjects =
      []; // قائمة الإعلانات المفضلة

  final List<Map<String, dynamic>> projects = [
  {
    'image': 'assets/images/realestate_1.jpg',
    'name': 'shopping_mall',
    'location': 'fifth_settlement_cairo',
    'profit': '400_egp_monthly',
    'shareCost': '50_k_egp',
    'availableShares': '100',
    'details': [
      'project_capital_50m',
      'expected_roi_130',
      'founded_2023',
      'available_units_10_shops_20_offices_20_clinics',
      'area_1500_sqm_each',
    ],
  },
  {
    'image': 'assets/images/realestate_2.jpg',
    'name': 'residential_apartments',
    'location': 'badr_city_cairo',
    'profit': '1.5_million',
    'shareCost': '1_million_egp',
    'availableShares': '8',
    'details': [
      'project_capital_8m',
      'expected_roi_150',
      'expected_completion_2026',
      'units_available_8_apartments',
      'apartment_condition_not_crossed_out',
      'area_450_sqm_each',
      'market_middle_class',
    ],
  },
  {
    'image': 'assets/images/realestate_3.jpg',
    'name': 'medical_center',
    'location': 'new_heliopolis_cairo',
    'profit': '4_k_egp_monthly',
    'shareCost': '500_k_egp',
    'availableShares': '20',
    'details': [
      'project_capital_40m',
      'expected_roi_130',
      'founded_2024',
      'units_available_50_clinics',
      'area_700_sqm_each',
      'market_high_end_vacation',
    ],
  },
  {
    'image': 'assets/images/realestate_4.jpg',
    'name': 'workshop',
    'location': 'fifth_settlement_egypt',
    'profit': '500_egp_monthly',
    'shareCost': '50_k_egp',
    'availableShares': '40',
    'details': [
      'project_capital_5m',
      'expected_roi_130',
      'founded_2023',
      'area_150_sqm_each',
    ],
  },
  {
    'image': 'assets/images/realestate_5.jpg',
    'name': 'beachfront_resort',
    'location': 'north_coast_egypt',
    'profit': '10_k_egp_monthly',
    'shareCost': '1_million_egp',
    'availableShares': '10',
    'details': [
      'project_capital_100m',
      'expected_roi_130',
      'founded_2023',
      'units_available_50_chalets',
      'area_150_sqm_each',
      'location_direct_beachfront',
      'market_high_end_vacation',
    ],
  },
];

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CustomAppBarHome(), // استخدام نفس AppBar الخاص بالصفحة الرئيسية
    body: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      isGridView ? Icons.list : Icons.grid_view,
                      size: 35,
                    ),
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView; // تبديل طريقة العرض
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: isGridView ? _buildGridView(context) : _buildListView(context),
            ),
          ],
        ),
        // ✅ إضافة الأزرار الثابتة
        const GlobalAssistantButtons(),
      ],
    ),
  );
}

Widget _buildListView(BuildContext context) {
  return ListView.builder(
    padding: const EdgeInsets.all(5),
    itemCount: projects.length,
    itemBuilder: (context, index) {
      final project = projects[index];
      return GestureDetector(
        onTap: () => _navigateToDetailsPage(context, project),
        child: Card(
          color: const Color.fromARGB(235, 244, 242, 146).withAlpha(50), // خلفية شفافة بلون بيج فاتح
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Image.asset(
                  project['image']!,
                  fit: BoxFit.cover,
                  width: 130,
                  height: 130,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context).translate("product")}: ${AppLocalizations.of(context).translate(project["name"])}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${AppLocalizations.of(context).translate("location")}: ${AppLocalizations.of(context).translate(project["location"])}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${AppLocalizations.of(context).translate("expected_profit")}: ${AppLocalizations.of(context).translate(project["profit"])}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${AppLocalizations.of(context).translate("investment_share_cost")}: ${AppLocalizations.of(context).translate(project["shareCost"])}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${AppLocalizations.of(context).translate("available_shares")}: ${AppLocalizations.of(context).translate(project["availableShares"])}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildGridView(BuildContext context) {
  return GridView.builder(
    padding: const EdgeInsets.all(10),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 3 / 4, // تكبير حجم الصور
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: projects.length,
    itemBuilder: (context, index) {
      final project = projects[index];
      return GestureDetector(
        onTap: () => _navigateToDetailsPage(context, project),
        child: Card(
          color: const Color.fromARGB(235, 244, 242, 146).withAlpha(50), // خلفية شفافة بلون بيج فاتح
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    project['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context).translate("product")}: ${AppLocalizations.of(context).translate(project["name"])}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context).translate("location")}: ${AppLocalizations.of(context).translate(project["location"])}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context).translate("expected_profit")}: ${AppLocalizations.of(context).translate(project["profit"])}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context).translate("investment_share_cost")}: ${AppLocalizations.of(context).translate(project["shareCost"])}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context).translate("available_shares")}: ${AppLocalizations.of(context).translate(project["availableShares"])}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  void _navigateToDetailsPage(
      BuildContext context, Map<String, dynamic> project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealestateDetailsPage(project: project),
      ),
    );
  }
}

class RealestateDetailsPage extends StatelessWidget {
  final Map<String, dynamic> project;

  const RealestateDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300, // ارتفاع الصور
                  child: PageView.builder(
                    itemCount: 3, // عدد الصور لكل مشروع
                    itemBuilder: (context, index) {
                      return Image.asset(
                        '${project['image']!.replaceAll(".jpg", "")}/image${index + 1}.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate(project['name']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color.fromARGB(255, 67, 47, 4)),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context).translate(project['location']),
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Color.fromARGB(255, 67, 47, 4)),
                          const SizedBox(width: 8),
                          Text(
                            '${AppLocalizations.of(context).translate("expected_profit")}: ${AppLocalizations.of(context).translate(project['profit'])}',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Color.fromARGB(255, 67, 47, 4)),
                          const SizedBox(width: 8),
                          Text(
                            '${AppLocalizations.of(context).translate("investment_share_cost")}: ${AppLocalizations.of(context).translate(project['shareCost'])}',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.pie_chart, color: Color.fromARGB(255, 67, 47, 4)),
                          const SizedBox(width: 8),
                          Text(
                            '${AppLocalizations.of(context).translate("available_shares")}: ${AppLocalizations.of(context).translate(project['availableShares'])}',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context).translate("additional_details"),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ...project['details'].map<Widget>(
                        (detail) => Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.info, color: Color.fromARGB(255, 67, 47, 4)),
                            title: Text(AppLocalizations.of(context).translate(detail)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // إضافة الإعلان إلى قائمة المفضلات
                          if (!favorites.contains(project)) {
                            favorites.add(project);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppLocalizations.of(context).translate("added_to_favorites")),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 67, 47, 4).withAlpha(100),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate("interested"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showInvestmentDialog(context, project['shareCost']);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 67, 47, 4).withAlpha(100),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            AppLocalizations.of(context).translate("invest_here"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const GlobalAssistantButtons(),
        ],
      ),
    );
  }
}



  void _showInvestmentDialog(BuildContext context, String shareCost) {
  int selectedShares = 1;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate("choose_shares")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (selectedShares > 1) {
                        setState(() {
                          selectedShares--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$selectedShares',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (selectedShares < 5) {
                        setState(() {
                          selectedShares++;
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${AppLocalizations.of(context).translate("cost_per_share")}: $shareCost',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).translate("cancel")),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showConfirmationDialog(context, selectedShares);
              },
              child: Text(AppLocalizations.of(context).translate("ok")),
            ),
          ],
        );
      },
    ),
  );
}

void _showConfirmationDialog(BuildContext context, int selectedShares) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context).translate("confirmation")),
      content: Text(
        '${AppLocalizations.of(context).translate("confirm_purchase")} $selectedShares ${AppLocalizations.of(context).translate("shares")}',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context).translate("no")),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentsPage(),
              ),
            );
          },
          child: Text(AppLocalizations.of(context).translate("yes")),
        ),
      ],
    ),
  );
}
