import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smartvestment/localization/app_localizations.dart';
import 'package:smartvestment/providers/language_provider.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _SignInScreenState extends State<SignInScreen> {
  String? _registeredEmail;
  String? _registeredPassword;

  // Controllers for Sign In
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controllers for Register
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedCountry;
  String? _selectedCity;
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isRegistering = false;


  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).translate('error')),
          content: Text(
              AppLocalizations.of(context).translate('invalid_credentials')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).translate('ok')),
            ),
          ],
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.disconnect();

      await _auth.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate('google_signin_error')),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).translate('ok')),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).translate('passwords_not_match'))),
      );
      return;
    }
    if (!_emailController.text.contains('@') ||
        !_emailController.text.endsWith('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context).translate('invalid_email'))),
      );
      return;
    }
    if (_nationalIdController.text.length != 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context).translate('invalid_national_id'))),
      );
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;
      _registeredEmail = _emailController.text.trim();
      _registeredPassword = _passwordController.text.trim();

      await user!.sendEmailVerification();
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).translate('verify_email')),
          content:
              Text(AppLocalizations.of(context).translate('verification_sent')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: Text(AppLocalizations.of(context).translate('ok')),
            ),
          ],
        ),
      );

      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null) {
          await user.reload();
          if (user.emailVerified) {
            _emailController.text = _registeredEmail ?? '';
            _passwordController.text = _registeredPassword ?? '';

            if (mounted) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title:
                      Text(AppLocalizations.of(context).translate('welcome')),
                  content: Text(AppLocalizations.of(context)
                      .translate('account_created')),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context).translate('ok')),
                    ),
                  ],
                ),
              );
            }
          }
        }
      });

      bool isVerified = false;
      while (!isVerified) {
        await Future.delayed(const Duration(seconds: 2));
        await user.reload();
        isVerified = user.emailVerified;
      }

      if (isVerified) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return; // ✅ تأكد أن الصفحة لا تزال نشطة
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context).translate('welcome')),
              content: Text(
                  AppLocalizations.of(context).translate('account_created')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _emailController.text = _registeredEmail ?? '';
                    _passwordController.text = _registeredPassword ?? '';
                  },
                  child: Text(AppLocalizations.of(context).translate('ok')),
                ),
              ],
            ),
          );
        });
      }

      if (isVerified) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'country': _selectedCountry,
        'city': _selectedCity,
        'national_id': _nationalIdController.text.trim(),
        'phone_no': _phoneController.text.trim(),
      });

      setState(() {
        _isRegistering = false;
      });
      if (!mounted) return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  AppLocalizations.of(context).translate('weak_password'))),
        );
      } else if (e.code == 'email-already-in-use') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context).translate('email_exists'))),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(AppLocalizations.of(context).translate('email_exists')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).translate('ok')),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ الخلفية
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/log in.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ زر تخطي
          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: const Icon(Icons.skip_next,
                  size: 32, color: Color.fromARGB(255, 60, 60, 60)),
            ),
          ),

          // ✅ زر تغيير اللغة باستخدام Dropdown
          Positioned(
            top: 50,
            left: 20,
            child: DropdownButton<Locale>(
              value: Provider.of<LanguageProvider>(context).locale,
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .setLocale(newLocale);
                }
              },
              icon: const Icon(Icons.language,
                  size: 32, color: Color.fromARGB(255, 71, 71, 71)),
              underline: Container(), // إزالة الخط السفلي
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

          // ✅ محتوى الفورم
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _isRegistering
                      ? _buildRegisterForm(context)
                      : _buildSignInForm(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSignInForm(BuildContext context) {
    return [
      const SizedBox(height: 350), // مسافة علوية للتحكم بالموقع
      Column(
        mainAxisAlignment: MainAxisAlignment.center, // توسيط العناوين
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate('log'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color:
                  const Color.fromARGB(255, 0, 0, 0), // يمكنك تغيير اللون هنا
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).translate('in'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),

      const SizedBox(height: 30), // مسافة قبل الحقول

      _buildCustomTextField(
          AppLocalizations.of(context).translate('enter_email'),
          _emailController),
      const SizedBox(height: 30),
      _buildCustomTextField(
          AppLocalizations.of(context).translate('enter_password'),
          _passwordController,
          isPassword: true),
      const SizedBox(height: 30),

      /// **💡 وضع الأزرار داخل Center + Column لتوسيطها بالكامل**
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 98, 98, 98),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: _signIn,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Text(
                  AppLocalizations.of(context).translate('log_in'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // مسافة بين الأزرار
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 98, 98, 98),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: signInWithGoogle,
              icon: const Icon(Icons.mail,
                  color: Color.fromARGB(255, 255, 255, 255)),
              label: Text(
                AppLocalizations.of(context).translate('google_account'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      /// **🔹 التوسيط في السطر السفلي أيضًا**
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).translate('dont_have_account'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = true;
                });
              },
              child: Text(
                AppLocalizations.of(context).translate('register'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildRegisterForm(BuildContext context) {
    return [
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _isRegistering = false;
              });
            },
          ),
          const SizedBox(height: 250),
          Text(
            AppLocalizations.of(context).translate('back'),
            style: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 59, 59, 59)),
          ),
        ],
      ),
      Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20), // مسافة داخلية
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200), // ✅ جعل الخلفية شفافة جزئيًا
          borderRadius: BorderRadius.circular(10), // ✅ إضافة حواف ناعمة
        ),
        child: Text(
          AppLocalizations.of(context).translate('create_account'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black, // ✅ تأكد أن النص بلون غامق ليكون واضحًا
          ),
        ),
      ),
      const SizedBox(height: 20),
      Form(
        key: _formKey,
        child: Column(
          children: [
            _buildCustomTextField(
                AppLocalizations.of(context).translate('name'),
                _nameController),
            const SizedBox(height: 20),
            _buildCustomTextField(
                AppLocalizations.of(context).translate('email'),
                _emailController),
            const SizedBox(height: 20),
            _buildCustomTextField(
                AppLocalizations.of(context).translate('password'),
                _passwordController,
                isPassword: true),
            const SizedBox(height: 20),
            _buildCustomTextField(
                AppLocalizations.of(context).translate('confirm_password'),
                _confirmPasswordController,
                isPassword: true),
            const SizedBox(height: 20),
            _buildCustomTextField(
                AppLocalizations.of(context).translate('national_id'),
                _nationalIdController),
            const SizedBox(height: 20),
            _buildCustomTextField(
                AppLocalizations.of(context).translate('phone_no'),
                _phoneController),
            const SizedBox(height: 20),
            _buildDropdownField(
                AppLocalizations.of(context).translate('country'), ['Egypt'],
                (value) {
              setState(() {
                _selectedCountry = value;
              });
            }),
            const SizedBox(height: 20),
            _buildDropdownField(
                AppLocalizations.of(context).translate('city'), [
              'Cairo',
              'Alexandria',
              'Giza',
              'Aswan',
              'Luxor',
              'Suez',
              'Port Said'
            ], (value) {
              setState(() {
                _selectedCity = value;
              });
            }),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 81, 81, 81),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _register();
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  child: Text(
                    AppLocalizations.of(context).translate('create_account'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildCustomTextField(
      String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 16),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String hint, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                    AppLocalizations.of(context).translate(item.toLowerCase())),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context).translate('please_select') + hint;
        }
        return null;
      },
    );
  }
}
