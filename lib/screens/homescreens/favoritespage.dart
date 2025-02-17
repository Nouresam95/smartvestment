import 'package:flutter/material.dart';
import 'package:smartvestment/screens/main_page.dart';
import 'package:smartvestment/screens/projectscreens/industrialpage.dart';
import 'package:smartvestment/widgets/global_assistant_buttons.dart'; // ✅ استيراد الأزرار الثابتة
import 'package:smartvestment/localization/app_localizations.dart'; // ✅ استيراد الترجمة

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarHome(),
      body: Stack(
        children: [
          favorites.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10),
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
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color.fromARGB(255, 123, 94, 35),
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('explore_opportunities'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color.fromARGB(255, 123, 94, 35),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final project = favorites[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                IndustrialDetailsPage(project: project),
                          ),
                        );
                      },
                      child: Card(
                        color: const Color.fromARGB(255, 244, 211, 142)
                            .withAlpha(100),
                        elevation: 2,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.asset(
                            project['image']!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate(project['name']),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${AppLocalizations.of(context).translate('location')}: ${AppLocalizations.of(context).translate(project['location'])}\n"
                            "${AppLocalizations.of(context).translate('profit')}: ${project['profit']}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            onPressed: () {
                              setState(() {
                                favorites.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
          const GlobalAssistantButtons(),
        ],
      ),
    );
  }
}

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    void showFinalConfirmation(
        BuildContext context, DateTime date, TimeOfDay time) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context).translate('appointment_set_for')} "
                "${date.day}/${date.month}/${date.year} ${AppLocalizations.of(context).translate('at')} "
                "${time.hour}:${time.minute}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 25),
              Text(
                "${AppLocalizations.of(context).translate('company_name')} :\nBeyond Investments",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 25),
              Text(
                "${AppLocalizations.of(context).translate('our_location')} : Badr city\nVila no 1 - Alhorrya street",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 25),
              Text(
                "${AppLocalizations.of(context).translate('our_number')} : 01063031811",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MainPage()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate('payment_appointment_confirmed'))),
                );
              },
              child: Text(AppLocalizations.of(context).translate('ok')),
            ),
          ],
        ),
      );
    }

    void showCalendar(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          DateTime? selectedDate;
          TimeOfDay? selectedTime;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)
                    .translate('please_set_appointment')),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('select_date_time'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 7)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: Text(selectedDate == null
                          ? AppLocalizations.of(context)
                              .translate('choose_date')
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            selectedTime = time;
                          });
                        }
                      },
                      child: Text(selectedTime == null
                          ? AppLocalizations.of(context)
                              .translate('choose_time')
                          : '${selectedTime!.hour}:${selectedTime!.minute}'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text(AppLocalizations.of(context).translate('cancel')),
                  ),
                  TextButton(
                    onPressed: () {
                      if (selectedDate != null && selectedTime != null) {
                        Navigator.pop(context);
                        showFinalConfirmation(
                            context, selectedDate!, selectedTime!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)
                                .translate('select_date_time_warning')),
                          ),
                        );
                      }
                    },
                    child:
                        Text(AppLocalizations.of(context).translate('confirm')),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    void showConfirmation(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate('payment_successful')),
          content: Text(AppLocalizations.of(context)
              .translate('thank_you_set_appointment')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showCalendar(context);
              },
              child: Text(AppLocalizations.of(context).translate('ok')),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBarOther(),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => showConfirmation(context),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 222, 192)
                    .withAlpha(50), // لون شفاف
                borderRadius: BorderRadius.circular(30), // الحواف المستديرة
                border: Border.all(color: Colors.black, width: 1), // حدود سوداء
              ),
              child: Row(
                children: [
                  const Icon(Icons.credit_card,
                      color: Color.fromARGB(255, 0, 0, 0)),
                  const SizedBox(width: 25),
                  Text(
                    AppLocalizations.of(context).translate('payment_card'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 23, 23, 23), fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showConfirmation(context),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 222, 192)
                    .withAlpha(50), // لون شفاف
                borderRadius: BorderRadius.circular(30), // الحواف المستديرة
                border: Border.all(color: Colors.black, width: 1), // حدود سوداء
              ),
              child: Row(
                children: [
                  const Icon(Icons.branding_watermark_sharp,
                      color: Color.fromARGB(255, 44, 28, 4)),
                  const SizedBox(width: 25),
                  Text(
                    AppLocalizations.of(context).translate('bank_transfer'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 44, 28, 4), fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => showConfirmation(context),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 222, 192)
                    .withAlpha(50), // لون شفاف
                borderRadius: BorderRadius.circular(30), // الحواف المستديرة
                border: Border.all(color: Colors.black, width: 1), // حدود سوداء
              ),
              child: Row(
                children: [
                  const Icon(Icons.handshake,
                      color: Color.fromARGB(255, 44, 28, 4)),
                  const SizedBox(width: 25),
                  Text(
                    AppLocalizations.of(context)
                        .translate('cash_on_signing_contracts'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 44, 28, 4), fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
