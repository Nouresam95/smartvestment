import 'package:flutter/material.dart';
import 'package:smartvestment/ai_assistant/assistant_service.dart';
import 'package:smartvestment/localization/app_localizations.dart';

class GlobalAssistantButtons extends StatefulWidget {
  const GlobalAssistantButtons({super.key});

  @override
  State<GlobalAssistantButtons> createState() => _GlobalAssistantButtonsState();
}

class _GlobalAssistantButtonsState extends State<GlobalAssistantButtons> {
  final VoiceAssistant assistant = VoiceAssistant();
  bool shouldSayWelcome = true;
  bool isAssistantActive = false;
  bool isSpeaking = false;

  /// ✅ المتغير لحفظ موضع الزر
  Offset buttonPosition = const Offset(300, 500); // الموضع الافتراضي للزر

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: buttonPosition.dx,
      top: buttonPosition.dy,
      child: Draggable(
        feedback: _buildButton(), // ✅ يظهر عند سحب الزر
        childWhenDragging: Container(), // ✅ إخفاء الزر أثناء السحب
        onDraggableCanceled: (velocity, offset) {
          if (mounted) {
            setState(() {
              buttonPosition = offset; // ✅ تحديث الموضع فقط إذا كانت الودجت لا تزال نشطة
            });
          }
        },
        child: _buildButton(),
      ),
    );
  }
  /// ✅ دالة إنشاء الزر
  Widget _buildButton() {
    return GestureDetector(
      onTap: () async {
        if (isSpeaking) {
          assistant.stopListening();
          setState(() {
            isAssistantActive = false;
            isSpeaking = false;
            shouldSayWelcome = true;
          });
        } else if (!isAssistantActive) {
          setState(() {
            isAssistantActive = true;
          });

          if (shouldSayWelcome) {
            setState(() {
              shouldSayWelcome = false;
            });

            await assistant.speak("كيف أساعدك؟", onComplete: () {
              setState(() {
                isSpeaking = false;
              });

              assistant.startListening((text) async {
                String response = await assistant.getResponseFromOpenAI(text);

                setState(() {
                  isSpeaking = true;
                });

                assistant.speak(response, onComplete: () {
                  setState(() {
                    isSpeaking = false;
                    isAssistantActive = false;
                  });
                });
              });
            });
          } else {
            assistant.startListening((text) async {
              String response = await assistant.getResponseFromOpenAI(text);

              setState(() {
                isSpeaking = true;
              });

              assistant.speak(response, onComplete: () {
                setState(() {
                  isSpeaking = false;
                  isAssistantActive = false;
                });
              });
            });
          }
        }
      },

      /// ✅ جعل الزر بوكس شفاف يحتوي على النص والأيقونة
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color:
              const Color.fromARGB(255, 0, 0, 0).withAlpha(50), // ✅ شفافية الزر
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: const Color.fromARGB(159, 0, 0, 0)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSpeaking ? Icons.stop_circle : Icons.assistant_rounded,
              color: const Color.fromARGB(221, 255, 255, 255), // ✅ لون الأيقونة
            ),
            const SizedBox(width: 15), // ✅ مسافة بين الأيقونة والنص
            Text(
              isSpeaking
                  ? AppLocalizations.of(context).translate("stop")
                  : AppLocalizations.of(context).translate("ai_assistant"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color.fromARGB(221, 255, 255, 255), // ✅ لون النص
              ),
            ),
          ],
        ),
      ),
    );
  }
}
