import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartvestment/screens/signin_screen.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart';
import 'package:smartvestment/localization/app_localizations.dart';
import 'package:smartvestment/providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MorePage extends StatefulWidget {
  final User? currentUser;

  const MorePage({super.key, required this.currentUser});

  @override
  MorePageState createState() => MorePageState();
}

class MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: Stack(
        children: [
          ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppLocalizations.of(context).translate('account')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPage(
                        email: widget.currentUser?.email ?? 'غير متوفر',
                        username:
                            widget.currentUser?.displayName ?? 'غير متوفر',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: Text(
                    AppLocalizations.of(context).translate('change_password')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                    AppLocalizations.of(context).translate('change_language')),
                trailing: DropdownButton<Locale>(
                  value: Provider.of<LanguageProvider>(context).locale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      Provider.of<LanguageProvider>(context, listen: false)
                          .setLocale(newLocale);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: const Locale('en'),
                      child: Text(
                          "🇬🇧 ${AppLocalizations.of(context).translate('english')}"),
                    ),
                    DropdownMenuItem(
                      value: const Locale('ar'),
                      child: Text(
                          "🇪🇬 ${AppLocalizations.of(context).translate('arabic')}"),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(AppLocalizations.of(context).translate('about_us')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.policy),
                title: Text(
                    AppLocalizations.of(context).translate('privacy_policy')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context).translate('log_out')),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                          AppLocalizations.of(context).translate('log_out')),
                      content: Text(AppLocalizations.of(context)
                          .translate('confirm_logout')),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                              AppLocalizations.of(context).translate('cancel')),
                        ),
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: Text(AppLocalizations.of(context)
                              .translate('log_out')),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const GlobalAssistantButtons(), // ✅ إضافة الأزرار الثابتة
        ],
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  final String email;
  final String username;

  const AccountPage({
    super.key,
    this.email = 'غير متوفر', // ✅ قيمة افتراضية
    this.username = 'غير متوفر', // ✅ قيمة افتراضية
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = '';
  String username = '';
  String phoneNumber = 'غير متوفر';
  String photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        email = user.email ?? 'غير متوفر';
        username = user.displayName ?? 'غير متوفر';
        photoUrl = user.photoURL ?? ''; // ✅ صورة المستخدم من حساب Google
      });

      // ✅ جلب بيانات إضافية من Firestore (إذا كانت مسجلة)
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['name'] ??
              username; // ✅ تحديث الاسم إذا كان مسجلًا في Firestore
          phoneNumber = userDoc['phone'] ??
              phoneNumber; // ✅ تحديث رقم الهاتف إذا كان مسجلًا
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (photoUrl.isNotEmpty) // ✅ عرض صورة الحساب إذا كانت متوفرة
              CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 50,
              ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(
                '${AppLocalizations.of(context).translate('email')}: $email',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                '${AppLocalizations.of(context).translate('username')}: $username',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                '${AppLocalizations.of(context).translate('phone')}: $phoneNumber',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isGoogleUser = false;
  String email = '';

  @override
  void initState() {
    super.initState();
    _checkUserProvider();
  }

  /// ✅ تحديد ما إذا كان المستخدم قد سجل الدخول عبر Google أو بالبريد وكلمة المرور
  Future<void> _checkUserProvider() async {
    User? user = _auth.currentUser;
    if (user != null) {
      email = user.email ?? '';
      for (var provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          setState(() {
            isGoogleUser = true;
          });
          break;
        }
      }
    }
  }

  /// ✅ تغيير كلمة المرور بعد التأكد من كلمة المرور الحالية
  Future<void> _changePassword(
      String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // إعادة تسجيل الدخول للتأكد من كلمة المرور الحالية
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // تحديث كلمة المرور
        await user.updatePassword(newPassword);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                  .translate('password_changed_success'))),
        );

        // إعادة توجيه المستخدم بعد تغيير كلمة المرور
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('password_change_failed'))),
      );
    }
  }

  /// ✅ إرسال رابط تغيير كلمة المرور عبر البريد للمستخدم المسجل بجوجل
  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('password_reset_email_sent'))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('password_reset_failed'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            if (isGoogleUser) ...[
              /// ✅ إذا كان المستخدم سجل عبر Google، أظهر زر إرسال رابط تغيير كلمة المرور
              Text(
                AppLocalizations.of(context)
                    .translate('google_password_change_info'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _sendPasswordResetEmail,
                child: Text(AppLocalizations.of(context)
                    .translate('send_password_reset_email')),
              ),
            ] else ...[
              /// ✅ إذا كان المستخدم سجل عبر البريد وكلمة المرور، أطلب منه إدخال كلمة المرور الحالية
              TextField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('current_password'),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate('new_password'),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('confirm_new_password'),
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (newPasswordController.text ==
                      confirmPasswordController.text) {
                    _changePassword(currentPasswordController.text,
                        newPasswordController.text);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(AppLocalizations.of(context)
                              .translate('passwords_do_not_match'))),
                    );
                  }
                },
                child: Text(
                    AppLocalizations.of(context).translate('save_changes')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ✅ اللوجو في الأعلى
              Center(
                child: Image.asset(
                  'assets/images/logo1.png',
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ عنوان الشركة
              Text(
                AppLocalizations.of(context).translate('beyond_investments'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const Divider(thickness: 1, height: 30), // ✅ خط فاصل أنيق

              /// ✅ وصف الشركة
              Text(
                AppLocalizations.of(context)
                    .translate('beyond_investments_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ "كيف نعمل؟"
              Text(
                AppLocalizations.of(context).translate('how_we_operate'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const Divider(thickness: 1, height: 30), // ✅ خط فاصل أنيق

              /// ✅ وصف "كيف نعمل"
              Text(
                AppLocalizations.of(context).translate('how_we_operate_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ✅ أيقونة الخصوصية
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              const SizedBox(height: 20),

              /// ✅ عنوان سياسة الخصوصية
              Text(
                AppLocalizations.of(context).translate('privacy_policy'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const Divider(thickness: 1, height: 30), // ✅ خط فاصل أنيق

              /// ✅ وصف سياسة الخصوصية
              Text(
                AppLocalizations.of(context).translate('privacy_policy_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ "ما البيانات التي نجمعها؟"
              Text(
                AppLocalizations.of(context).translate('what_we_collect'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const Divider(thickness: 1, height: 30), // ✅ خط فاصل أنيق

              /// ✅ تفاصيل "ما البيانات التي نجمعها؟"
              Text(
                AppLocalizations.of(context).translate('what_we_collect_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              /// ✅ "كيف نستخدم بياناتك؟"
              Text(
                AppLocalizations.of(context).translate('how_we_use_it'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const Divider(thickness: 1, height: 30), // ✅ خط فاصل أنيق

              /// ✅ تفاصيل "كيف نستخدم بياناتك؟"
              Text(
                AppLocalizations.of(context).translate('how_we_use_it_desc'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
