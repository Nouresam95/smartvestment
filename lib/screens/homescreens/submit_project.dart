import 'package:flutter/material.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart'; // ✅ استيراد الأزرار الثابتة
import 'package:smartvestment/screens/main_page.dart';

class SubmitProjectPage extends StatefulWidget {
  const SubmitProjectPage({super.key});

  @override
  State<SubmitProjectPage> createState() => SubmitProjectPageState();
}

class SubmitProjectPageState extends State<SubmitProjectPage> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescriptionController =
      TextEditingController();
  final TextEditingController investmentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  List<Map<String, String>> myProjects = [];

  void selectFile(String fileType) {
    // Placeholder for file selection functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$fileType functionality not implemented yet!')),
    );
  }

  void showThankYouDialog() {
    if (!mounted) return; // تأكد أن الصفحة لا تزال نشطة
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Thank you for registering, your project will be reviewed and you will be contacted.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                myProjects.add({
                  'name': projectNameController.text,
                  'description': projectDescriptionController.text,
                });
              });
              if (!mounted) return; // تحقق من أن الصفحة لا تزال موجودة
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MyProjectsPage(myProjects: myProjects),
                ),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/submit.png'),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Please fill out the following information to review the project',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: projectNameController,
                      decoration: const InputDecoration(
                        hintText: 'Project name...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: projectDescriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Project description...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => selectFile('Feasibility study'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Feasibility study (attach files)...'),
                            Icon(Icons.attach_file),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => selectFile('Commercial register'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Commercial register (attach files)...'),
                            Icon(Icons.attach_file),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => selectFile('Tax card'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax card (attach files)...'),
                            Icon(Icons.attach_file),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: investmentController,
                      decoration: const InputDecoration(
                        hintText: 'Required Investment...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Phone number...',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (projectNameController.text.isNotEmpty &&
                            projectDescriptionController.text.isNotEmpty) {
                          showThankYouDialog();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Please fill out all required fields!'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color.fromARGB(255, 58, 44, 7)),
                      ),
                    ),
                    const SizedBox(height: 165),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyProjectsPage(myProjects: myProjects),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(0, 0, 0, 0),
                          border: Border.all(
                              color: const Color.fromARGB(255, 117, 117, 117),
                              width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'My Projects',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 50, 50, 50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const GlobalAssistantButtons(),
        ],
      ),
    );
  }
}

class MyProjectsPage extends StatelessWidget {
  final List<Map<String, String>> myProjects;

  const MyProjectsPage({super.key, required this.myProjects});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: myProjects.isEmpty
          ? const Center(
              child: Text(
                'No projects submitted yet.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: myProjects.length,
              itemBuilder: (context, index) {
                final project = myProjects[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 177, 164, 144)
                          .withAlpha(100), // خلفية شفافة
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Project Name: ${project['name']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email: ${project['email']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Phone: ${project['phone']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Your project is being reviewed, thank you!',
                                  ),
                                ),
                              );
                            },
                            child: const Text('View Status'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
