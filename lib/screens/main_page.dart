import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartvestment/screens/homescreens/favoritespage.dart';
import 'package:smartvestment/screens/home_page.dart';
import 'package:smartvestment/screens/projectscreens/industrialpage.dart';
import 'package:smartvestment/screens/homescreens/morepage.dart';
import 'package:smartvestment/screens/homescreens/portfoliopage.dart';
import 'package:smartvestment/screens/projectscreens/realestatepage.dart';
import 'package:smartvestment/screens/homescreens/walletpage.dart';
import 'package:smartvestment/localization/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // الحصول على المستخدم الحالي
    final User? currentUser = FirebaseAuth.instance.currentUser;

    final List<Widget> pages = [
      HomePage(),
      PortfolioPage(),
      WalletPage(),
      MorePage(currentUser: currentUser), // تمرير currentUser هنا
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 193, 156, 78),
        unselectedItemColor: const Color.fromARGB(255, 71, 49, 10),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context).translate('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: AppLocalizations.of(context).translate('nav_my_investments'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: AppLocalizations.of(context).translate('nav_wallet'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: AppLocalizations.of(context).translate('nav_more'),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> favorites = [];

class CustomAppBarHomeMain extends StatelessWidget {
  const CustomAppBarHomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/appbar.jpg'),
                  fit: BoxFit.cover,
                ),
                color: const Color.fromARGB(255, 11, 5, 5).withAlpha(10),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Row(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Color.fromARGB(255, 236, 236, 235),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Text(
                    AppLocalizations.of(context).translate('Smartvestment'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color.fromARGB(255, 0, 0, 0),
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesPage()),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 200,
              left: 10,
              right: 10,
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('search_opportunities'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(205, 255, 255, 255),
                ),
              ),
            ),
            Positioned(
              top: 160,
              left: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 74, 74, 74).withAlpha(70),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('discover_marketplace'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        shadows: [
                          Shadow(
                            offset: const Offset(1, 1),
                            blurRadius: 5,
                            color: Colors.black.withAlpha(120),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const IndustrialPage(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.factory,
                                  size: 65,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 50,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('industrial_investment'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 9,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 90,
                          width: 2,
                          color: const Color.fromARGB(255, 241, 241, 241),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RealestatePage(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.home,
                                  size: 65,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 50,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('realestate_investment'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 5,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
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
          ],
        ),
      ],
    );
  }
}

class CustomAppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 1.0,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),

      // ✅ زر الرجوع (Back)
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black), // لون الزر
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      // ✅ تقليل المسافة بين زر Back واللوجو
      title: Row(
        children: [
          const SizedBox(width: 0.001), // ✅ قلل هذه القيمة لتقليل المسافة
          Image.asset(
            'assets/images/logo1.png', // ✅ استبدال النص باللوجو
            height: 45,
            width: 45,
          ),
        ],
      ),

      actions: [
        IconButton(
          icon: const Icon(
            Icons.favorite,
            color: Color.fromARGB(255, 0, 0, 0),
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesPage()),
            );
          },
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: TextField(
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)
                  .translate('search_opportunities'),
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class CustomAppBarOther extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarOther({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/appbar.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                color: const Color.fromARGB(255, 237, 206, 157).withAlpha(10),
              ),
            ),
          ],
        ),
      ),

      // ✅ تثبيت النص على اليسار و الأيقونة على اليمين بغض النظر عن اللغة
      title: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // ✅ توزيع العناصر بين الطرفين
        children: [
          /// ✅ النص يبقى في أقصى اليسار دائمًا
          Text(
            AppLocalizations.of(context).translate('Smartvestment'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),

          /// ✅ زر Favorite يبقى في أقصى اليمين دائمًا
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 0, 0, 0),
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),

      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
