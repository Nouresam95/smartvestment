import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:dart_openai/dart_openai.dart';
import 'package:smartvestment/secrets.dart';

bool isAssistantActive = false; // ✅ التحكم في تشغيل المساعد مرة واحدة فقط

class VoiceAssistant {
  late stt.SpeechToText _speech; // لتحويل الكلام إلى نص
  late FlutterTts _tts; // لتحويل النص إلى كلام
  bool isListening = false; // هل المساعد يستمع؟
  bool isSpeaking = false; // ✅ هل المساعد يتحدث؟

  VoiceAssistant() {
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _initTTS();

    // ✅ إضافة API Key الخاصة بـ OpenAI
        OpenAI.apiKey = Secrets.openAiApiKey; // ✅ استدعاء المفتاح بأمان
  }

  // ✅ إعداد تحويل النص إلى كلام (تغيير الصوت إلى صوت رجل)
  void _initTTS() async {
    await _tts.setLanguage("ar-EG"); // ✅ اللهجة المصرية
    await _tts.setPitch(0.1); // ✅ نغمة الصوت أقرب لـ Ember
    await _tts.setSpeechRate(0.45); // ✅ سرعة الكلام
    await _tts.setVolume(1.0); // ✅ مستوى الصوت
    await _tts.setVoice(
        {"name": "ar-eg-x-ycm-network", "gender": "male"}); // ✅ صوت رجل
  }

  // ✅ تشغيل المساعد لسماع المستخدم بعد انتهاء الكلام
  Future<void> speak(String text, {Function()? onComplete}) async {
    isSpeaking = true; // ✅ تحديد أن المساعد يتحدث حاليًا
    await _tts.awaitSpeakCompletion(true);
    await _tts.speak(text);
    isSpeaking = false; // ✅ انتهى المساعد من الكلام
    onComplete?.call();
  }

  // ✅ إيقاف الاستماع فورًا
  void stopListening() {
    _speech.stop();
    _tts.stop(); // ✅ إيقاف أي كلام جاري
    isListening = false;
    isSpeaking = false; // ✅ تحديد أن المساعد توقف عن الكلام
  }

  // ✅ تشغيل المساعد لسماع المستخدم
  Future<void> startListening(Function(String) onResult) async {
    bool available = await _speech.initialize();

    if (available) {
      isListening = true;
      await _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            onResult(result.recognizedWords);
          }
        },
 listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.dictation,
          partialResults: false, // ✅ لا نحتاج نتائج جزئية
        ),
        localeId: "ar-EG",
      );
    }
  }

  // ✅ دالة لجلب الرد من OpenAI API
  Future<String> getResponseFromOpenAI(String userInput) async {
    try {
      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  """أنت مساعد ذكي داخل تطبيق **SmartVestmentو لو المستخدم رحب بيك او قالك عامل ايه او كيفك او ازيك هترحب بيه**.
                "  أنا هنا لأكون **مستشارك الاستثماري** وأرشدك خلال رحلتك الاستثمارية داخل التطبيق."
                ### **ما هو تطبيق SmartVestment؟**
                SmartVestment هو تطبيق تابع لشركة **Beyond Investments**، الشركة المتخصصة في الاستثمارات العقارية والصناعية. يتيح التطبيق للمستخدمين الاستثمار في:
                -  **المشاريع الصناعية**: الاستثمار في المصانع أو المخازن الصناعية القائمة وتحقيق عوائد مضمونة.
                -  **المشاريع العقارية**: الاستثمار في العقارات مثل المولات، المحلات، العيادات، المكاتب الإدارية، والاستفادة من العوائد الإيجارية.
"أنت مساعد استثماري داخل تطبيق **SmartVestment**.
                مهمتك هي **مساعدة المستخدمين في فهم الاستثمار العقاري والصناعي** داخل التطبيق فقط. 
                ** لا تجب على أي أسئلة خارج نطاق التطبيق والاستثمار**. 
                - إذا سأل المستخدم عن أي شيء آخر مثل الأخبار، التكنولوجيا، الصحة، أو أي موضوع غير متعلق بالاستثمار، يجب أن يكون ردك:  
                "**لا يمكنني الإجابة على هذا السؤال، لكن يمكنني مساعدتك في استثماراتك داخل التطبيق!*
                ### **معلومات عن شركة Beyond Investments:**
                -  **الشركة مرخصة ومسجلة قانونيًا** بسجل تجاري وبطاقة ضريبية.
                - **معتمدة من** هيئة الاستثمار، هيئة الرقابة المالية، والبنك المركزي المصري.
                -  **توفر فرص استثمارية موثوقة ومضمونة**.
  - ** استثمارك آمن 100%**: لا يوجد خسائر، فقط مكاسب مستمرة.  
  - ** أرباح مستدامة**: أموالك تعمل من أجلك وتحقق لك أعلى العوائد.  
** لماذا الاستثمار أفضل من الادخار؟**  
  - **الادخار في البنك = أموالك تفقد قيمتها بمرور الوقت**.  
  - **الاستثمار = أموالك تنمو باستمرار وتحقق أرباحًا حقيقية**.  
  - **مع Beyond Investments، الفلوس مش بس محفوظة، دي كمان بتزيد يوم بعد يوم!**  
               
                ### **تفاصيل الاستثمار الصناعي:**
                 **الاستثمار في المصانع** 
                   - المستخدم يشتري **حصة (Share)** في مصنع ينتج سلعة.
                   - يحصل على أرباح سنوية.
                   - يحصل على **خصومات** على المنتج المصنع.
                   - يساهم في دعم الاقتصاد وتقليل الاستيراد وزيادة الإنتاج المحلي.

                 **الاستثمار في المخازن الصناعية** 
                   - يشتري المستخدم **حصة (Share)** في مخزن صناعي مؤجر.
                   - يحصل على **عائد إيجاري شهري** ثابت.
                   - يستفيد من **زيادة رأس المال عند انتهاء مدة العقد**.

                ### **تفاصيل الاستثمار العقاري:**
                - يشتري المستخدم **حصة (Share)** في مشروع عقاري قائم مثل:
                  -  **المولات التجارية**
                  -  **المحلات التجارية**
                  -  **العيادات والمكاتب الإدارية**
                - يحصل المستخدم على **عائد إيجاري شهري** وعائد على الاستثمار عند انتهاء العقد.
                - ** الشقق السكنية هي مثل مفهوم إتحاد ملاك بحيث انك ممكن من خلال التطبيق شراء حصة في أرض سكنية و من خلالها تلك الحصة الحصول على شقة غير مشطبة في عمارة سكنية جاهزة بسعر أقل من سعر السوق بحيث أن كل حصة تمثل شقة في العمارة المبنية على تلك الأرض, و تكون الشقة ملك للمستخدم بعد انتهاء المشروع مما يمكن تأجير الشقة و الاتفادة من العائد الشهري او السكن و كل ذلك تحت إشراف الشركة
                ### **أقسام التطبيق:**
                -  **My Investments**: تحتوي على المشاريع التي استثمرت فيها.
                -  **Wallet**: تعرض العوائد المالية التي حصلت عليها من خلال الإستثمار.
                -  **More**: صفحة الإعدادات، تغيير كلمة المرور، اللغة، معلومات عن الشركة، تسجيل الخروج.
                -  **Submit Your Project**: إذا كان لديك فكرة مشروع وتريد تمويله من خلال تقديم السجل التجاري والبطاقة الضريبية ودراسة الجدوى.
 ** متقلقش، أنا هنا معاك خطوة بخطوة!**  
  مع Beyond Investments، **النجاح هو الخيار الوحيد!**  
  أي استفسار؟ اسألني، وهنحقق لك أقصى استفادة من استثمارك!   
  "
                **يمكنك أن تسألني أي شيء عن الاستثمار أو التطبيق وسأساعدك!**""")
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(userInput)
            ],
          ),
        ],
      );

      // ✅ استخراج النص من الرد
      String? responseText =
          chatCompletion.choices.first.message.content?.first.text;

       // ✅ تعديل هذا السطر للتأكد من عدم استخدام `isEmpty` على null
if (responseText?.isEmpty ?? true) {
  return Future.value("لم أتمكن من فهم سؤالك، ولكن يمكنني إخبارك أن تطبيق SmartVestment هو تطبيق للاستثمار الجزئي في المشاريع العقارية والصناعية.");
}



       return Future.value(responseText);
    } catch (e) {
      return Future.value("عذرًا، حدث خطأ أثناء جلب الرد.");
    }
  }

  // ✅ تنظيف الموارد عند إغلاق التطبيق
  void dispose() {
    _speech.stop();
    _tts.stop();
  }
}
