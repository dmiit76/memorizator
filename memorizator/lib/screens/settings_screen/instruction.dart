import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/services/constants.dart';

class Instruction extends StatelessWidget {
  const Instruction({super.key});

  final String instructionRuText = """
# Добро пожаловать в приложение **Меморизатор**!

Наше приложение будет полезно следующим пользователям:
1. Туристам, которые хотят пересчитывать цены чужой страны в привычные цены.
2. Тем, кому нужен быстрый пересчет из одной валюты в другую без арифметических действий. Вы просто вводите сумму и тут же видите её в другой валюте.
3. Пользователям, которые хотят сохранять информацию о товарах и ценах на них. К записи можно добавить фотографию товара и штрих-код. Если приложение имеет разрешение на доступ к геоданным, то сохраняется локация места где была сделана запись о товаре.

## Быстрый старт
- На экране настроек установите две валюты для конвертации. Ели появилась кнопка запроса курса валют, то нажмите на неё и приложение автоматически установит курс одной валюты к другой, если это возможно. Вы так же можете самостоятельно ввести курс в соответствующее поле.
- Для ввода суммы, которую хотите конвертировать или запомнить, используйте текстовое поле вверху главного экрана. Если в настройках вы ввели курс конвертации отличный от 0 и 1, приложение в момент ввода будет сразу пересчитывать введенную сумму и выводить результат.
- Вы можете сохранить результат расчета. Опционально можно добавить фотографии и штрихкод товара. При сохранении задайте название товара и введите вес товара, для того чтобы в дальнейшем понимать стоимость относительно веса.

## Действия с записями
- Просмотр записи - короткое нажатие на названии товара.
- Редактирование записи - долгое нажатие на названии товара.
- Удаление записи - откройте запись на редактирование, нажмите кнопку удаления (красным цветом).
- Фильтр для записей - Нажмите на надпись с информацией о количестве записей, задайте фильтр.

## Сохранение фотографий
Фотографии, которые вы прилагаете к записям, хранятся в папке приложения. Если доступно - на внешнем хранилище. Если его нет - в папке приложения на телефоне. посмотреть куда сохраняются фотографии вы можете на экране настроек, в самом низу.

## Отключение рекламы.
Вы можете отключить рекламу в приложении за символическую цену от 1 доллара. Это будет небольшой благодарностью за мой труд и позволит развивать приложение. Вы можете выбрать увеличенную сумму на ваше усмотрение, если посчитаете мой труд полезным. Благодарю за любое пожертвование.

## Развитие
Вы можете предлагать идеи для улучшения приложения или создания новых приложений. 
Вы можете сообщить о недоработках и они будут исправлены.
Пишите memorizator555@gmail.com

Спасибо, что выбрали нас!
""";

  final String instructionEnText = """
# Welcome to the **Memorizator** app!

### Our application will be useful for the following users:
1. Tourists who want to convert the prices of a foreign country into the usual prices.
2. Those who need a quick conversion from one currency to another without arithmetic operations. You just enter the amount and immediately see it in another currency.
3. Users who want to save information about products and their prices. You can add a product photo and barcode to the record. If the application has permission to access geodata, the location of the place where the record was made is saved.

## Quick start
- On the settings screen, set two currencies for conversion. If there is a button to request exchange rate, tap on it and the application will automatically set the exchange rate of one currency to the other, if possible. You can also enter the rate yourself in the corresponding field.
- To enter the amount you want to convert or memorize, use the text field at the top of the main screen. If you have entered a conversion rate other than 0 and 1 in the settings, the application will immediately recalculate the entered amount and display the result.
- You can save the result of the calculation. Optionally you can add photos and barcode of the product. When saving, specify the name of the item and enter the weight of the item, in order to understand the cost in relation to the weight.

## Actions with records
- View record - short press on the product name.
- Edit record - long press on the product name.
- Delete record - open the record for editing, click the delete button (red color).
- Filter for records - Click on the inscription with information about the number of records, set the filter.

## Saving photos
 The photos you attach to your recordings are stored in the application folder. If available - on external storage. If not available, in the application folder on your phone. to see where your photos are saved, you can see where they are saved on the settings screen at the very bottom.

## Disabling advertising
You can disable ads in the app for a nominal price of \$1 or less. It will be a small gratitude for my labor and will allow to develop the application. You can choose an increased amount at your discretion if you find my labor useful. Thank you for any donation.

## Development
You can suggest ideas to improve the app or create new apps. 
You can report bugs and they will be fixed.
Write to memorizator555@gmail.com

Thank you for choosing us!
""";

  @override
  Widget build(BuildContext context) {
    String instructionText = '';

    // if (Intl.getCurrentLocale() == 'ru') {
    //   instructionText = instructionRuText;
    // } else {
    //   instructionText = instructionEnText;
    // }
    instructionText = getInstruction(Intl.getCurrentLocale());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: aWhite,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
        title: Text(
          S.of(context).instructionTitle,
          style: const TextStyle(color: aWhite),
        ),
        //actions: [Icon(Icons.close_outlined), Text('  ')],
        backgroundColor: aBlue,
      ),
      backgroundColor: aLightBlue,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Markdown(
          data: instructionText,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        ),
      ),
    );
  }

  String getInstruction(currentInstruction) {
    switch (currentInstruction) {
      case 'ru':
        return """
# Добро пожаловать в приложение **Меморизатор**!

Наше приложение будет полезно следующим пользователям:
1. Туристам, которые хотят пересчитывать цены чужой страны в привычные цены.
2. Тем, кому нужен быстрый пересчет из одной валюты в другую без арифметических действий. Вы просто вводите сумму и тут же видите её в другой валюте.
3. Пользователям, которые хотят сохранять информацию о товарах и ценах на них. К записи можно добавить фотографию товара и штрих-код. Если приложение имеет разрешение на доступ к геоданным, то сохраняется локация места где была сделана запись о товаре.

## Быстрый старт
- На экране настроек установите две валюты для конвертации. Ели появилась кнопка запроса курса валют, то нажмите на неё и приложение автоматически установит курс одной валюты к другой, если это возможно. Вы так же можете самостоятельно ввести курс в соответствующее поле.
- Для ввода суммы, которую хотите конвертировать или запомнить, используйте текстовое поле вверху главного экрана. Если в настройках вы ввели курс конвертации отличный от 0 и 1, приложение в момент ввода будет сразу пересчитывать введенную сумму и выводить результат.
- Вы можете сохранить результат расчета. Опционально можно добавить фотографии и штрихкод товара. При сохранении задайте название товара и введите вес товара, для того чтобы в дальнейшем понимать стоимость относительно веса.

## Действия с записями
- Просмотр записи - короткое нажатие на названии товара.
- Редактирование записи - долгое нажатие на названии товара.
- Удаление записи - откройте запись на редактирование, нажмите кнопку удаления (красным цветом).
- Фильтр для записей - Нажмите на надпись с информацией о количестве записей, задайте фильтр.

## Сохранение фотографий
Фотографии, которые вы прилагаете к записям, хранятся в папке приложения. Если доступно - на внешнем хранилище. Если его нет - в папке приложения на телефоне. посмотреть куда сохраняются фотографии вы можете на экране настроек, в самом низу.

## Отключение рекламы.
Вы можете отключить рекламу в приложении за символическую цену от 1 доллара. Это будет небольшой благодарностью за мой труд и позволит развивать приложение. Вы можете выбрать увеличенную сумму на ваше усмотрение, если посчитаете мой труд полезным. Благодарю за любое пожертвование.

## Развитие
Вы можете предлагать идеи для улучшения приложения или создания новых приложений. 
Вы можете сообщить о недоработках и они будут исправлены.
Пишите memorizator555@gmail.com

Спасибо, что выбрали нас!
""";
      case 'ar':
        return """
# مرحبًا بك في تطبيق **ميموريزاتور**!

سيكون تطبيقنا مفيدًا للمستخدمين التاليين:
1. السياح الذين يرغبون في تحويل أسعار البلدان الأخرى إلى أسعار مألوفة.
2. لمن يحتاج إلى تحويل سريع من عملة إلى أخرى دون إجراء العمليات الحسابية. كل ما عليك هو إدخال المبلغ، وسترى السعر بالعملة الأخرى فوراً.
3. المستخدمين الذين يرغبون في حفظ معلومات عن المنتجات وأسعارها. يمكن إضافة صورة للمنتج ورمز شريطي (باركود) للتسجيل. إذا كان التطبيق لديه إذن للوصول إلى الموقع الجغرافي، سيتم حفظ موقع المكان حيث تم تسجيل المنتج.

## بداية سريعة
- في شاشة الإعدادات، قم بتعيين عملتين للتحويل. إذا ظهرت زر طلب سعر الصرف، اضغط عليه وسيقوم التطبيق بتعيين سعر الصرف تلقائيًا إذا كان ذلك ممكنًا. يمكنك أيضًا إدخال سعر الصرف يدويًا في الحقل المناسب.
- لاستخدام الحقل في إدخال المبلغ الذي تريد تحويله أو حفظه، استخدم حقل النص في أعلى الشاشة الرئيسية. إذا قمت بإدخال سعر صرف مختلف عن 0 و 1 في الإعدادات، سيقوم التطبيق بحساب المبلغ المدخل وعرض النتيجة مباشرة.
- يمكنك حفظ نتيجة الحساب. كما يمكن اختيارياً إضافة الصور والباركود للمنتج. عند الحفظ، قم بتعيين اسم للمنتج وأدخل وزنه لكي تفهم لاحقًا السعر بالنسبة للوزن.

## التعامل مع السجلات
- عرض السجل - انقر نقرة قصيرة على اسم المنتج.
- تحرير السجل - انقر نقرة طويلة على اسم المنتج.
- حذف السجل - افتح السجل للتحرير، ثم اضغط على زر الحذف (باللون الأحمر).
- فلتر للسجلات - اضغط على العنوان مع معلومات عن عدد السجلات، ثم قم بتعيين الفلتر.

## حفظ الصور
الصور التي ترفقها بالسجلات يتم حفظها في مجلد التطبيق. إذا كان متاحًا، سيتم الحفظ في الذاكرة الخارجية، وإن لم يكن متوفرًا، سيتم حفظها في مجلد التطبيق على الهاتف. يمكنك رؤية موقع حفظ الصور في أسفل شاشة الإعدادات.

## إيقاف الإعلانات.
يمكنك إيقاف الإعلانات في التطبيق مقابل رسوم رمزية تبدأ من دولار واحد. سيكون هذا شكرًا صغيرًا على عملي ويسمح بتطوير التطبيق. يمكنك اختيار مبلغ أكبر إذا كنت تعتبر عملي مفيدًا. شكرًا لك على أي تبرع.

## التطوير
يمكنك تقديم أفكار لتحسين التطبيق أو إنشاء تطبيقات جديدة.
يمكنك الإبلاغ عن الأخطاء وسيتم تصحيحها.
اكتب إلى memorizator555@gmail.com

شكرًا لاختيارك لنا!
""";
      case 'bn':
        return """
# **মেমোরাইজার** অ্যাপে স্বাগতম!

আমাদের অ্যাপ নিম্নলিখিত ব্যবহারকারীদের জন্য উপকারী হবে:
1. পর্যটকরা, যারা অন্য দেশের মূল্যকে পরিচিত মূল্যে রূপান্তর করতে চান।
2. যারা এক মুদ্রা থেকে অন্য মুদ্রায় দ্রুত রূপান্তর চান, কোনো গাণিতিক ক্রিয়া ছাড়াই। আপনি শুধু পরিমাণটি প্রবেশ করুন এবং সাথে সাথে এটি অন্য মুদ্রায় দেখতে পাবেন।
3. ব্যবহারকারীরা, যারা পণ্য এবং তাদের মূল্যের তথ্য সংরক্ষণ করতে চান। আপনি রেকর্ডে পণ্যের ছবি এবং বারকোড যোগ করতে পারেন। যদি অ্যাপটি জিওডেটার অ্যাক্সেসের অনুমতি পায়, তাহলে পণ্যের রেকর্ড যেখানে করা হয়েছে সেই স্থানের অবস্থান সংরক্ষিত হবে।

## দ্রুত শুরু
- সেটিংস স্ক্রিনে রূপান্তরের জন্য দুটি মুদ্রা সেট করুন। যদি মুদ্রা বিনিময় হার অনুরোধের বোতামটি প্রদর্শিত হয়, তাহলে সেটিতে চাপুন এবং অ্যাপটি স্বয়ংক্রিয়ভাবে একটি মুদ্রার হার অন্যটির সাথে সেট করবে, যদি সম্ভব হয়। আপনি নিজেও সংশ্লিষ্ট ক্ষেত্রে হারটি প্রবেশ করতে পারেন।
- আপনি যে পরিমাণটি রূপান্তর করতে বা মনে রাখতে চান তা প্রবেশ করতে প্রধান স্ক্রিনের উপরের টেক্সট ফিল্ডটি ব্যবহার করুন। যদি আপনি সেটিংসে 0 এবং 1 থেকে ভিন্ন রূপান্তর হার প্রবেশ করেন, তাহলে অ্যাপটি প্রবেশের সময় সাথে সাথে পরিমাণটি রূপান্তর করবে এবং ফলাফল দেখাবে।
- আপনি গণনার ফলাফল সংরক্ষণ করতে পারেন। ঐচ্ছিকভাবে আপনি পণ্যের ছবি এবং বারকোড যোগ করতে পারেন। সংরক্ষণের সময় পণ্যের নাম দিন এবং পণ্যের ওজন প্রবেশ করুন, যাতে ভবিষ্যতে ওজনের সাথে সম্পর্কিত মূল্যের ধারণা পেতে পারেন।

## রেকর্ডের সাথে ক্রিয়াকলাপ
- রেকর্ড দেখুন - পণ্যের নামের উপর সংক্ষিপ্ত চাপ।
- রেকর্ড সম্পাদনা - পণ্যের নামের উপর দীর্ঘ চাপ।
- রেকর্ড মুছুন - রেকর্ডটি সম্পাদনার জন্য খুলুন, মুছে ফেলার বোতামে চাপুন (লাল রঙে)।
- রেকর্ডের জন্য ফিল্টার - রেকর্ডের সংখ্যার তথ্য সহ লেখায় চাপুন, ফিল্টার সেট করুন।

## ছবির সংরক্ষণ
আপনি যে ছবিগুলি রেকর্ডে সংযুক্ত করেন, সেগুলি অ্যাপের ফোল্ডারে সংরক্ষিত হয়। যদি উপলব্ধ থাকে - বাহ্যিক স্টোরেজে। যদি না থাকে - ফোনের অ্যাপের ফোল্ডারে। আপনি কোথায় ছবিগুলি সংরক্ষিত হয় তা দেখতে পারেন সেটিংস স্ক্রিনের সবচেয়ে নিচে।

## বিজ্ঞাপন বন্ধ করা।
আপনি অ্যাপে বিজ্ঞাপন বন্ধ করতে পারেন 1 ডলার থেকে শুরু করে একটি প্রতীকী মূল্যে। এটি আমার পরিশ্রমের জন্য একটি ছোট ধন্যবাদ হবে এবং অ্যাপটি উন্নত করতে সহায়তা করবে। আপনি আপনার বিবেচনায় একটি বড় পরিমাণ বেছে নিতে পারেন, যদি আপনি আমার পরিশ্রমকে উপকারী মনে করেন। যে কোনো দানের জন্য ধন্যবাদ।

## উন্নয়ন
আপনি অ্যাপটি উন্নত করার বা নতুন অ্যাপ তৈরির জন্য ধারণা প্রস্তাব করতে পারেন।
আপনি ত্রুটির রিপোর্ট করতে পারেন এবং সেগুলি সংশোধন করা হবে।
লিখুন memorizator555@gmail.com

আমাদের বেছে নেওয়ার জন্য ধন্যবাদ!
""";
      case 'de':
        return """
# Willkommen bei der App **Memorizator**!

Unsere App ist nützlich für folgende Benutzer:
1. Touristen, die Preise aus fremden Ländern in vertraute Preise umrechnen möchten.
2. Personen, die schnell von einer Währung in eine andere umrechnen möchten, ohne mathematische Berechnungen durchzuführen. Sie geben einfach den Betrag ein und sehen ihn sofort in der anderen Währung.
3. Benutzer, die Informationen über Produkte und deren Preise speichern möchten. Sie können dem Eintrag ein Foto des Produkts und einen Barcode hinzufügen. Wenn die App Zugriff auf Geodaten hat, wird der Standort gespeichert, an dem der Produkteintrag erstellt wurde.

## Schnellstart
- Stellen Sie auf dem Einstellungsbildschirm zwei Währungen für die Umrechnung ein. Wenn eine Schaltfläche zum Abrufen des Wechselkurses erscheint, klicken Sie darauf, und die App stellt automatisch den Kurs einer Währung zur anderen ein, sofern dies möglich ist. Sie können den Kurs auch manuell in das entsprechende Feld eingeben.
- Verwenden Sie das Textfeld oben auf dem Hauptbildschirm, um den Betrag einzugeben, den Sie umrechnen oder speichern möchten. Wenn Sie in den Einstellungen einen anderen Umrechnungskurs als 0 und 1 eingegeben haben, berechnet die App den eingegebenen Betrag sofort und zeigt das Ergebnis an.
- Sie können das Berechnungsergebnis speichern. Optional können Sie Fotos und den Barcode des Produkts hinzufügen. Beim Speichern geben Sie den Produktnamen und das Gewicht des Produkts ein, um später den Preis in Bezug auf das Gewicht zu verstehen.

## Aktionen mit Einträgen
- Eintrag anzeigen – kurzes Tippen auf den Produktnamen.
- Eintrag bearbeiten – langes Tippen auf den Produktnamen.
- Eintrag löschen – öffnen Sie den Eintrag zur Bearbeitung und klicken Sie auf die Löschtaste (in Rot).
- Filter für Einträge – klicken Sie auf die Beschriftung mit Informationen zur Anzahl der Einträge und legen Sie den Filter fest.

## Speichern von Fotos
Die Fotos, die Sie den Einträgen hinzufügen, werden im App-Ordner gespeichert. Wenn verfügbar, auf dem externen Speicher. Wenn nicht, im App-Ordner auf dem Telefon. Sie können sehen, wo die Fotos gespeichert werden, indem Sie auf dem Einstellungsbildschirm ganz nach unten scrollen.

## Deaktivierung von Werbung
Sie können die Werbung in der App für einen symbolischen Preis ab 1 Dollar deaktivieren. Dies ist ein kleines Dankeschön für meine Arbeit und ermöglicht die Weiterentwicklung der App. Sie können einen höheren Betrag nach eigenem Ermessen wählen, wenn Sie meine Arbeit als nützlich empfinden. Vielen Dank für jede Spende.

## Weiterentwicklung
Sie können Ideen zur Verbesserung der App oder zur Erstellung neuer Apps vorschlagen.
Sie können auf Fehler hinweisen, und diese werden behoben.
Schreiben Sie an memorizator555@gmail.com

Vielen Dank, dass Sie uns gewählt haben!
""";
      case 'fr':
        return """
# Bienvenue dans l'application **Memorisateur** !

Notre application sera utile aux utilisateurs suivants :
1. Les touristes qui souhaitent convertir les prix d'un pays étranger en prix familiers.
2. Ceux qui ont besoin d'une conversion rapide d'une devise à une autre sans calculs arithmétiques. Il vous suffit d'entrer le montant et vous le verrez immédiatement dans l'autre devise.
3. Les utilisateurs qui souhaitent enregistrer des informations sur des produits et leurs prix. Vous pouvez ajouter une photo du produit et un code-barres à l'enregistrement. Si l'application a l'autorisation d'accéder aux données de localisation, l'emplacement où l'enregistrement du produit a été effectué sera enregistré.

## Démarrage rapide
- Sur l'écran des paramètres, définissez deux devises pour la conversion. Si un bouton de demande de taux de change apparaît, appuyez dessus et l'application définira automatiquement le taux d'une devise par rapport à l'autre, si possible. Vous pouvez également entrer manuellement le taux dans le champ correspondant.
- Pour entrer le montant que vous souhaitez convertir ou mémoriser, utilisez le champ de texte en haut de l'écran principal. Si vous avez entré un taux de conversion différent de 0 et 1 dans les paramètres, l'application recalculera immédiatement le montant saisi et affichera le résultat.
- Vous pouvez enregistrer le résultat du calcul. Vous pouvez également ajouter des photos et le code-barres du produit. Lors de l'enregistrement, donnez un nom au produit et entrez son poids afin de comprendre ultérieurement le coût par rapport au poids.

## Actions avec les enregistrements
- Afficher un enregistrement : appuyez brièvement sur le nom du produit.
- Modifier un enregistrement : appuyez longuement sur le nom du produit.
- Supprimer un enregistrement : ouvrez l'enregistrement pour le modifier, puis appuyez sur le bouton de suppression (en rouge).
- Filtrer les enregistrements : appuyez sur l'indication du nombre d'enregistrements, puis définissez le filtre.

## Enregistrement des photos
Les photos que vous ajoutez aux enregistrements sont stockées dans le dossier de l'application. Si disponible, elles sont enregistrées sur le stockage externe. Sinon, elles sont enregistrées dans le dossier de l'application sur le téléphone. Vous pouvez voir où les photos sont enregistrées en bas de l'écran des paramètres.

## Désactivation des publicités
Vous pouvez désactiver les publicités dans l'application pour un prix symbolique à partir de 1 dollar. Ce sera un petit remerciement pour mon travail et permettra de développer l'application. Vous pouvez choisir un montant plus élevé à votre discrétion si vous trouvez mon travail utile. Merci pour tout don.

## Développement
Vous pouvez proposer des idées pour améliorer l'application ou créer de nouvelles applications.
Vous pouvez signaler des bugs et ils seront corrigés.
Écrivez à memorizator555@gmail.com

Merci de nous avoir choisis !
""";
      case 'hi':
        return """
# **मेमोराइज़र** ऐप में आपका स्वागत है!

हमारा ऐप निम्नलिखित उपयोगकर्ताओं के लिए उपयोगी होगा:
1. पर्यटकों के लिए, जो किसी अन्य देश की कीमतों को अपनी परिचित कीमतों में परिवर्तित करना चाहते हैं।
2. उन लोगों के लिए, जिन्हें एक मुद्रा से दूसरी मुद्रा में बिना गणितीय क्रियाओं के त्वरित रूपांतरण की आवश्यकता है। आप बस राशि दर्ज करें और तुरंत इसे दूसरी मुद्रा में देखें।
3. उन उपयोगकर्ताओं के लिए, जो उत्पादों और उनकी कीमतों की जानकारी सहेजना चाहते हैं। आप रिकॉर्ड में उत्पाद की तस्वीर और बारकोड जोड़ सकते हैं। यदि ऐप को जियोडेटा तक पहुंच की अनुमति है, तो उस स्थान का स्थान सहेजा जाएगा जहां उत्पाद का रिकॉर्ड बनाया गया था।

## त्वरित प्रारंभ
- सेटिंग्स स्क्रीन पर, रूपांतरण के लिए दो मुद्राएं सेट करें। यदि मुद्रा विनिमय दर अनुरोध बटन दिखाई देता है, तो उस पर टैप करें और ऐप स्वचालित रूप से एक मुद्रा की दर दूसरी के साथ सेट करेगा, यदि संभव हो। आप संबंधित फ़ील्ड में दर मैन्युअली भी दर्ज कर सकते हैं।
- उस राशि को दर्ज करने के लिए जिसे आप रूपांतरित या सहेजना चाहते हैं, मुख्य स्क्रीन के शीर्ष पर टेक्स्ट फ़ील्ड का उपयोग करें। यदि आपने सेटिंग्स में 0 और 1 से भिन्न रूपांतरण दर दर्ज की है, तो ऐप दर्ज की गई राशि को तुरंत पुनर्गणना करेगा और परिणाम प्रदर्शित करेगा।
- आप गणना के परिणाम को सहेज सकते हैं। वैकल्पिक रूप से, आप उत्पाद की तस्वीरें और बारकोड जोड़ सकते हैं। सहेजते समय, उत्पाद का नाम दें और उत्पाद का वजन दर्ज करें, ताकि बाद में वजन के सापेक्ष लागत को समझ सकें।

## रिकॉर्ड के साथ क्रियाएँ
- रिकॉर्ड देखें - उत्पाद के नाम पर एक छोटा टैप करें।
- रिकॉर्ड संपादित करें - उत्पाद के नाम पर लंबा टैप करें।
- रिकॉर्ड हटाएं - रिकॉर्ड को संपादन के लिए खोलें, हटाने के बटन पर टैप करें (लाल रंग में)।
- रिकॉर्ड के लिए फ़िल्टर - रिकॉर्ड की संख्या की जानकारी वाले लेबल पर टैप करें, फ़िल्टर सेट करें।

## तस्वीरों का सहेजना
आप जो तस्वीरें रिकॉर्ड में संलग्न करते हैं, वे ऐप फ़ोल्डर में सहेजी जाती हैं। यदि उपलब्ध है - बाहरी स्टोरेज पर। यदि नहीं - फोन पर ऐप फ़ोल्डर में। आप सेटिंग्स स्क्रीन के सबसे नीचे देख सकते हैं कि तस्वीरें कहाँ सहेजी जाती हैं।

## विज्ञापन बंद करना
आप ऐप में विज्ञापन को 1 डॉलर से शुरू होने वाली सांकेतिक कीमत पर बंद कर सकते हैं। यह मेरे काम के लिए एक छोटा धन्यवाद होगा और ऐप को विकसित करने में मदद करेगा। यदि आप मेरे काम को उपयोगी मानते हैं, तो आप अपनी इच्छा से एक बड़ी राशि चुन सकते हैं। किसी भी दान के लिए धन्यवाद।

## विकास
आप ऐप को बेहतर बनाने या नए ऐप बनाने के लिए विचार प्रस्तुत कर सकते हैं।
आप बग की रिपोर्ट कर सकते हैं और उन्हें ठीक किया जाएगा।
लिखें memorizator555@gmail.com

हमें चुनने के लिए धन्यवाद!
""";
      case 'it':
        return """
# Benvenuto nell'applicazione **Memorizzatore**!

La nostra applicazione sarà utile ai seguenti utenti:
1. Turisti che desiderano convertire i prezzi di un paese straniero in prezzi familiari.
2. Coloro che necessitano di una conversione rapida da una valuta all'altra senza operazioni aritmetiche. Basta inserire l'importo e lo vedrete immediatamente nell'altra valuta.
3. Utenti che desiderano salvare informazioni su prodotti e i loro prezzi. È possibile aggiungere una foto del prodotto e un codice a barre al record. Se l'applicazione ha il permesso di accedere ai dati di geolocalizzazione, verrà salvata la posizione del luogo in cui è stata effettuata la registrazione del prodotto.

## Avvio rapido
- Nella schermata delle impostazioni, impostate due valute per la conversione. Se appare il pulsante per richiedere il tasso di cambio, premetelo e l'applicazione imposterà automaticamente il tasso di una valuta rispetto all'altra, se possibile. Potete anche inserire manualmente il tasso nel campo corrispondente.
- Per inserire l'importo che desiderate convertire o memorizzare, utilizzate il campo di testo in alto nella schermata principale. Se nelle impostazioni avete inserito un tasso di conversione diverso da 0 e 1, l'applicazione ricalcolerà immediatamente l'importo inserito e mostrerà il risultato.
- Potete salvare il risultato del calcolo. Facoltativamente, potete aggiungere foto e il codice a barre del prodotto. Durante il salvataggio, assegnate un nome al prodotto e inserite il peso del prodotto, in modo da comprendere successivamente il costo in relazione al peso.

## Azioni con i record
- Visualizzare un record: tocco breve sul nome del prodotto.
- Modificare un record: tocco prolungato sul nome del prodotto.
- Eliminare un record: aprite il record per la modifica, quindi premete il pulsante di eliminazione (in rosso).
- Filtro per i record: premete sull'indicazione con le informazioni sul numero di record, quindi impostate il filtro.

## Salvataggio delle foto
Le foto che allegate ai record vengono salvate nella cartella dell'applicazione. Se disponibile, nella memoria esterna. In caso contrario, nella cartella dell'applicazione sul telefono. Potete vedere dove vengono salvate le foto nella parte inferiore della schermata delle impostazioni.

## Disattivazione della pubblicità
Potete disattivare la pubblicità nell'applicazione per un prezzo simbolico a partire da 1 dollaro. Questo sarà un piccolo ringraziamento per il mio lavoro e permetterà di sviluppare l'applicazione. Potete scegliere un importo maggiore a vostra discrezione se ritenete utile il mio lavoro. Grazie per qualsiasi donazione.

## Sviluppo
Potete proporre idee per migliorare l'applicazione o creare nuove applicazioni.
Potete segnalare bug e verranno corretti.
Scrivete a memorizator555@gmail.com

Grazie per averci scelto!
""";
      case 'ja':
        return """
# **メモライザー**アプリへようこそ！

このアプリは以下のユーザーに役立ちます：
1. 他国の価格を自国の通貨に換算したい旅行者。
2. 数学的な計算なしで、ある通貨から別の通貨への迅速な変換が必要な方。金額を入力するだけで、即座に他の通貨での金額が表示されます。
3. 商品とその価格情報を保存したいユーザー。商品記録に写真やバーコードを追加できます。アプリが位置情報へのアクセス許可を持っている場合、商品記録が作成された場所の位置情報も保存されます。

## クイックスタート
- 設定画面で、変換する2つの通貨を設定します。為替レートのリクエストボタンが表示された場合、それをタップすると、可能であればアプリが自動的に一方の通貨のレートを他方に設定します。対応するフィールドにレートを手動で入力することもできます。
- 変換または保存したい金額を入力するには、メイン画面上部のテキストフィールドを使用します。設定で0や1以外の変換レートを入力した場合、アプリは入力時に即座に金額を再計算し、結果を表示します。
- 計算結果を保存できます。オプションで、商品の写真やバーコードを追加できます。保存時に商品名を指定し、商品の重量を入力して、後で重量に対するコストを理解できるようにします。

## 記録の操作
- 記録の表示：商品名を短くタップします。
- 記録の編集：商品名を長押しします。
- 記録の削除：編集のために記録を開き、削除ボタン（赤色）をタップします。
- 記録のフィルタリング：記録数の情報が表示されているラベルをタップし、フィルタを設定します。

## 写真の保存
記録に添付した写真は、アプリのフォルダに保存されます。利用可能であれば外部ストレージに、そうでなければ電話のアプリフォルダに保存されます。写真の保存場所は、設定画面の一番下で確認できます。

## 広告の無効化
アプリ内の広告は、1ドルからの象徴的な価格で無効化できます。これは私の作業への小さな感謝となり、アプリの開発を可能にします。私の作業が有益だと感じた場合、任意でより高い金額を選択できます。どんな寄付にも感謝します。

## 開発
アプリの改善や新しいアプリの作成に関するアイデアを提案できます。
バグを報告すると、それらは修正されます。
memorizator555@gmail.com までご連絡ください。

私たちを選んでいただき、ありがとうございます！
""";
      case 'ko':
        return """
# **메모라이저** 앱에 오신 것을 환영합니다!

우리 앱은 다음과 같은 사용자들에게 유용합니다:
1. 다른 나라의 가격을 익숙한 가격으로 환산하고자 하는 여행자.
2. 복잡한 계산 없이 한 통화에서 다른 통화로 빠르게 변환이 필요한 분. 금액을 입력하면 즉시 다른 통화로 변환된 금액을 확인할 수 있습니다.
3. 상품과 그 가격 정보를 저장하고자 하는 사용자. 기록에 상품 사진과 바코드를 추가할 수 있습니다. 앱이 위치 정보 접근 권한을 가지고 있다면, 상품 기록이 작성된 장소의 위치도 저장됩니다.

## 빠른 시작
- 설정 화면에서 변환할 두 개의 통화를 설정하세요. 환율 요청 버튼이 나타나면, 해당 버튼을 눌러주세요. 가능하다면 앱이 자동으로 한 통화의 환율을 다른 통화로 설정합니다. 또한 해당 필드에 환율을 직접 입력할 수도 있습니다.
- 변환하거나 저장하고자 하는 금액을 입력하려면, 메인 화면 상단의 텍스트 필드를 사용하세요. 설정에서 0이나 1이 아닌 환율을 입력했다면, 앱은 입력 시 즉시 금액을 재계산하여 결과를 표시합니다.
- 계산 결과를 저장할 수 있습니다. 선택적으로 상품의 사진과 바코드를 추가할 수 있습니다. 저장 시 상품명을 입력하고, 나중에 무게 대비 비용을 이해할 수 있도록 상품의 무게를 입력하세요.

## 기록 관리
- 기록 보기: 상품명을 짧게 터치하세요.
- 기록 편집: 상품명을 길게 터치하세요.
- 기록 삭제: 기록을 편집 모드로 열고, 삭제 버튼(빨간색)을 누르세요.
- 기록 필터링: 기록 수에 대한 정보가 표시된 레이블을 누르고, 필터를 설정하세요.

## 사진 저장
기록에 첨부한 사진은 앱 폴더에 저장됩니다. 가능하다면 외부 저장소에, 그렇지 않다면 휴대폰의 앱 폴더에 저장됩니다. 사진이 저장되는 위치는 설정 화면 하단에서 확인할 수 있습니다.

## 광고 제거
앱 내 광고는 1달러부터 시작하는 상징적인 가격으로 제거할 수 있습니다. 이는 저의 작업에 대한 작은 감사의 표시이며, 앱 개발을 가능하게 합니다. 제 작업이 유용하다고 느끼신다면, 원하시는 금액을 선택하실 수 있습니다. 모든 기부에 감사드립니다.

## 개발
앱 개선이나 새로운 앱 제작에 대한 아이디어를 제안하실 수 있습니다.
버그를 신고하시면, 해당 버그는 수정될 것입니다.
memorizator555@gmail.com 으로 연락주세요.

저희를 선택해 주셔서 감사합니다!
""";
      case 'pt':
        return """
# Bem-vindo ao aplicativo **Memorizador**!

Nosso aplicativo será útil para os seguintes usuários:
1. Turistas que desejam converter preços de um país estrangeiro para valores familiares.
2. Aqueles que precisam de uma conversão rápida de uma moeda para outra sem cálculos aritméticos. Basta inserir o valor e você verá imediatamente na outra moeda.
3. Usuários que desejam salvar informações sobre produtos e seus preços. Você pode adicionar uma foto do produto e o código de barras ao registro. Se o aplicativo tiver permissão para acessar os dados de localização, será salvo o local onde o registro do produto foi feito.

## Início Rápido
- Na tela de configurações, defina duas moedas para conversão. Se aparecer um botão para solicitar a taxa de câmbio, toque nele e o aplicativo definirá automaticamente a taxa de uma moeda para a outra, se possível. Você também pode inserir manualmente a taxa no campo correspondente.
- Para inserir o valor que deseja converter ou memorizar, use o campo de texto na parte superior da tela principal. Se nas configurações você inseriu uma taxa de conversão diferente de 0 e 1, o aplicativo recalculará imediatamente o valor inserido e exibirá o resultado.
- Você pode salvar o resultado do cálculo. Opcionalmente, pode adicionar fotos e o código de barras do produto. Ao salvar, atribua um nome ao produto e insira o peso do produto para que, posteriormente, você possa entender o custo em relação ao peso.

## Ações com Registros
- Visualizar registro: toque curto no nome do produto.
- Editar registro: toque longo no nome do produto.
- Excluir registro: abra o registro para edição e toque no botão de exclusão (em vermelho).
- Filtro para registros: toque na indicação com informações sobre o número de registros e defina o filtro.

## Salvamento de Fotos
As fotos que você anexa aos registros são armazenadas na pasta do aplicativo. Se disponível, no armazenamento externo. Caso contrário, na pasta do aplicativo no telefone. Você pode ver onde as fotos são salvas na parte inferior da tela de configurações.

## Desativação de Anúncios
Você pode desativar os anúncios no aplicativo por um preço simbólico a partir de 1 dólar. Isso será um pequeno agradecimento pelo meu trabalho e permitirá o desenvolvimento do aplicativo. Você pode escolher um valor maior a seu critério, se considerar meu trabalho útil. Agradeço por qualquer doação.

## Desenvolvimento
Você pode sugerir ideias para melhorar o aplicativo ou criar novos aplicativos.
Você pode relatar bugs e eles serão corrigidos.
Escreva para memorizator555@gmail.com

Obrigado por nos escolher!
""";
      case 'tr':
        return """
# **Memorizator** uygulamasına hoş geldiniz!

Uygulamamız aşağıdaki kullanıcılar için faydalı olacaktır:
1. Farklı bir ülkenin fiyatlarını kendi alışık oldukları fiyatlara çevirmek isteyen turistler.
2. Matematiksel işlemler yapmadan bir para biriminden diğerine hızlı dönüşüm yapmak isteyenler. Sadece tutarı girin ve hemen diğer para birimindeki karşılığını görün.
3. Ürünler ve fiyatları hakkında bilgi saklamak isteyen kullanıcılar. Kayıtlara ürünün fotoğrafını ve barkodunu ekleyebilirsiniz. Uygulama konum bilgilerine erişim iznine sahipse, ürün kaydının yapıldığı yerin konumu da saklanır.

## Hızlı Başlangıç
- Ayarlar ekranında, dönüşüm için iki para birimi belirleyin. Döviz kuru talep etme butonu görünüyorsa, üzerine dokunun ve uygulama mümkünse bir para biriminin kurunu diğerine otomatik olarak ayarlayacaktır. Ayrıca ilgili alana kuru manuel olarak da girebilirsiniz.
- Dönüştürmek veya kaydetmek istediğiniz tutarı girmek için ana ekranın üst kısmındaki metin alanını kullanın. Ayarlarda 0 ve 1'den farklı bir dönüşüm kuru girdiyseniz, uygulama girilen tutarı anında yeniden hesaplayacak ve sonucu gösterecektir.
- Hesaplama sonucunu kaydedebilirsiniz. İsteğe bağlı olarak ürünün fotoğraflarını ve barkodunu ekleyebilirsiniz. Kaydederken, ürünün adını belirleyin ve ürünün ağırlığını girin, böylece daha sonra ağırlığa göre maliyeti anlayabilirsiniz.

## Kayıtlarla İlgili İşlemler
- Kaydı görüntüleme: Ürün adına kısa dokunuş.
- Kaydı düzenleme: Ürün adına uzun dokunuş.
- Kaydı silme: Kaydı düzenlemek için açın ve silme butonuna (kırmızı renkte) dokunun.
- Kayıtlar için filtre: Kayıt sayısı bilgisi içeren etikete dokunun ve filtreyi ayarlayın.

## Fotoğrafların Saklanması
Kayıtlara eklediğiniz fotoğraflar uygulamanın klasöründe saklanır. Mevcutsa harici depolamada, değilse telefonun uygulama klasöründe saklanır. Fotoğrafların nereye kaydedildiğini ayarlar ekranının en altından görebilirsiniz.

## Reklamların Kapatılması
Uygulamadaki reklamları 1 dolardan başlayan sembolik bir fiyatla kapatabilirsiniz. Bu, emeğim için küçük bir teşekkür olacak ve uygulamanın gelişimini sağlayacaktır. Emeğimi faydalı buluyorsanız, kendi takdirinize bağlı olarak daha yüksek bir tutar seçebilirsiniz. Her türlü bağış için teşekkür ederim.

## Geliştirme
Uygulamayı geliştirmek veya yeni uygulamalar oluşturmak için fikirler önerebilirsiniz.
Hataları bildirebilir ve bunlar düzeltilecektir.
memorizator555@gmail.com adresine yazın

Bizi seçtiğiniz için teşekkür ederiz!
""";
      case 'vi':
        return """
# Chào mừng bạn đến với ứng dụng **Memorizator**!

Ứng dụng của chúng tôi sẽ hữu ích cho các đối tượng sau:
1. Khách du lịch muốn chuyển đổi giá cả của quốc gia khác sang giá quen thuộc.
2. Những người cần chuyển đổi nhanh từ một loại tiền tệ sang loại khác mà không cần thực hiện các phép tính. Bạn chỉ cần nhập số tiền và ngay lập tức thấy nó trong loại tiền tệ khác.
3. Người dùng muốn lưu trữ thông tin về sản phẩm và giá cả của chúng. Bạn có thể thêm ảnh sản phẩm và mã vạch vào bản ghi. Nếu ứng dụng có quyền truy cập vào dữ liệu vị trí, vị trí nơi bản ghi sản phẩm được tạo sẽ được lưu lại.

## Bắt đầu nhanh
- Trên màn hình cài đặt, thiết lập hai loại tiền tệ để chuyển đổi. Nếu xuất hiện nút yêu cầu tỷ giá hối đoái, hãy nhấn vào đó và ứng dụng sẽ tự động thiết lập tỷ giá của một loại tiền tệ so với loại kia, nếu có thể. Bạn cũng có thể tự nhập tỷ giá vào trường tương ứng.
- Để nhập số tiền bạn muốn chuyển đổi hoặc ghi nhớ, hãy sử dụng trường văn bản ở đầu màn hình chính. Nếu trong cài đặt bạn đã nhập tỷ giá chuyển đổi khác 0 và 1, ứng dụng sẽ ngay lập tức tính toán lại số tiền đã nhập và hiển thị kết quả.
- Bạn có thể lưu kết quả tính toán. Tùy chọn, bạn có thể thêm ảnh và mã vạch của sản phẩm. Khi lưu, hãy đặt tên cho sản phẩm và nhập trọng lượng của sản phẩm để sau này hiểu được chi phí so với trọng lượng.

## Thao tác với bản ghi
- Xem bản ghi: nhấn ngắn vào tên sản phẩm.
- Chỉnh sửa bản ghi: nhấn lâu vào tên sản phẩm.
- Xóa bản ghi: mở bản ghi để chỉnh sửa, sau đó nhấn nút xóa (màu đỏ).
- Bộ lọc cho bản ghi: nhấn vào nhãn có thông tin về số lượng bản ghi, sau đó thiết lập bộ lọc.

## Lưu trữ ảnh
Ảnh bạn đính kèm vào bản ghi được lưu trong thư mục của ứng dụng. Nếu có sẵn, sẽ lưu trên bộ nhớ ngoài. Nếu không, sẽ lưu trong thư mục của ứng dụng trên điện thoại. Bạn có thể xem nơi lưu trữ ảnh ở cuối màn hình cài đặt.

## Tắt quảng cáo
Bạn có thể tắt quảng cáo trong ứng dụng với mức giá tượng trưng từ 1 đô la. Đây sẽ là một lời cảm ơn nhỏ cho công việc của tôi và cho phép phát triển ứng dụng. Bạn có thể chọn số tiền lớn hơn theo ý muốn nếu bạn thấy công việc của tôi hữu ích. Cảm ơn bạn cho bất kỳ khoản đóng góp nào.

## Phát triển
Bạn có thể đề xuất ý tưởng để cải thiện ứng dụng hoặc tạo ứng dụng mới.
Bạn có thể báo cáo lỗi và chúng sẽ được sửa.
Viết thư đến memorizator555@gmail.com

Cảm ơn bạn đã chọn chúng tôi!
""";
      case 'zh':
        return """
# 欢迎使用 **Memorizator** 应用程序！

我们的应用程序对以下用户非常有用：
1. 希望将外国价格转换为熟悉价格的游客。
2. 需要快速将一种货币转换为另一种货币而无需进行数学计算的人。您只需输入金额，即可立即看到其在另一种货币中的值。
3. 希望保存商品及其价格信息的用户。您可以在记录中添加商品的照片和条形码。如果应用程序有访问地理数据的权限，将保存创建商品记录的位置。

## 快速入门
- 在设置屏幕上，设置两种要转换的货币。如果出现请求汇率的按钮，请点击它，应用程序将自动设置一种货币对另一种货币的汇率（如果可能）。您也可以在相应的字段中手动输入汇率。
- 要输入您想转换或记住的金额，请使用主屏幕顶部的文本字段。如果您在设置中输入了不同于0和1的转换汇率，应用程序将在输入时立即重新计算输入的金额并显示结果。
- 您可以保存计算结果。可选地，您可以添加商品的照片和条形码。保存时，请为商品命名并输入商品的重量，以便将来了解相对于重量的成本。

## 记录操作
- 查看记录：短按商品名称。
- 编辑记录：长按商品名称。
- 删除记录：打开记录进行编辑，然后点击删除按钮（红色）。
- 记录筛选：点击带有记录数量信息的标签，设置筛选条件。

## 照片保存
您附加到记录的照片保存在应用程序的文件夹中。如果可用，则保存在外部存储中。如果不可用，则保存在手机上的应用程序文件夹中。您可以在设置屏幕的底部查看照片的保存位置。

## 关闭广告
您可以以象征性的价格（从1美元起）关闭应用程序中的广告。这将是对我工作的一个小小的感谢，并将有助于应用程序的发展。如果您认为我的工作有用，您可以自行选择更高的金额。感谢您的任何捐赠。

## 开发
您可以提出改进应用程序或创建新应用程序的想法。
您可以报告错误，我们将进行修复。
请发送邮件至 memorizator555@gmail.com

感谢您选择我们！
""";

      case 'es':
        return """
# ¡Bienvenido a la aplicación **Memorizator**!

Nuestra aplicación será útil para los siguientes usuarios:
1. Turistas que desean convertir los precios de un país extranjero a los precios a los que están acostumbrados.
2. Aquellos que necesitan una conversión rápida de una moneda a otra sin realizar cálculos aritméticos. Solo introduce la cantidad y verás el resultado en la otra moneda al instante.
3. Usuarios que desean guardar información sobre productos y sus precios. A la entrada se puede añadir una foto del producto y su código de barras. Si la aplicación tiene permiso para acceder a los datos de ubicación, se guardará la ubicación donde se hizo la entrada sobre el producto.

## Inicio rápido
- En la pantalla de configuración, selecciona dos monedas para la conversión. Si aparece un botón para solicitar la tasa de cambio, púlsalo y la aplicación establecerá automáticamente la tasa de cambio entre las dos monedas, si es posible. También puedes ingresar manualmente la tasa en el campo correspondiente.
- Para ingresar la cantidad que deseas convertir o recordar, usa el campo de texto en la parte superior de la pantalla principal. Si en la configuración ingresaste una tasa de conversión diferente de 0 y 1, la aplicación calculará el monto ingresado en el momento y mostrará el resultado.
- Puedes guardar el resultado del cálculo. Opcionalmente, puedes agregar fotos y el código de barras del producto. Al guardar, introduce el nombre del producto y su peso, para que posteriormente puedas entender el costo en relación al peso.

## Acciones con registros
- Ver entrada: pulsa brevemente el nombre del producto.
- Editar entrada: pulsa prolongadamente el nombre del producto.
- Eliminar entrada: abre la entrada para editar, luego presiona el botón de eliminar (en rojo).
- Filtro para las entradas: pulsa el texto que muestra el número de entradas y configura el filtro.

## Guardado de fotografías
Las fotos que adjuntas a las entradas se guardan en la carpeta de la aplicación. Si hay almacenamiento externo disponible, se guardarán en él; si no, en la carpeta de aplicaciones en el Teléfono. Puedes ver dónde se guardan las fotos en la pantalla de configuración, en la parte inferior.

## Desactivación de publicidad.
Puedes desactivar la publicidad en la aplicación por un precio simbólico a partir de 1 dólar. Será un pequeño agradecimiento por mi trabajo y me permitirá continuar desarrollando aplicaciones. Puedes elegir una cantidad mayor si consideras útil mi trabajo. Agradezco cualquier donación.

## Desarrollo
Puedes proponer ideas para mejorar la aplicación o para crear nuevas aplicaciones.
Puedes informar de errores y serán corregidos.
Escríbenos a memorizator555@gmail.com

¡Gracias por elegirnos!
""";

      default: // en
        return """
# Welcome to the **Memorizator** app!

### Our application will be useful for the following users:
1. Tourists who want to convert the prices of a foreign country into the usual prices.
2. Those who need a quick conversion from one currency to another without arithmetic operations. You just enter the amount and immediately see it in another currency.
3. Users who want to save information about products and their prices. You can add a product photo and barcode to the record. If the application has permission to access geodata, the location of the place where the record was made is saved.

## Quick start
- On the settings screen, set two currencies for conversion. If there is a button to request exchange rate, tap on it and the application will automatically set the exchange rate of one currency to the other, if possible. You can also enter the rate yourself in the corresponding field.
- To enter the amount you want to convert or memorize, use the text field at the top of the main screen. If you have entered a conversion rate other than 0 and 1 in the settings, the application will immediately recalculate the entered amount and display the result.
- You can save the result of the calculation. Optionally you can add photos and barcode of the product. When saving, specify the name of the item and enter the weight of the item, in order to understand the cost in relation to the weight.

## Actions with records
- View record - short press on the product name.
- Edit record - long press on the product name.
- Delete record - open the record for editing, click the delete button (red color).
- Filter for records - Click on the inscription with information about the number of records, set the filter.

## Saving photos
 The photos you attach to your recordings are stored in the application folder. If available - on external storage. If not available, in the application folder on your phone. to see where your photos are saved, you can see where they are saved on the settings screen at the very bottom.

## Disabling advertising
You can disable ads in the app for a nominal price of \$1 or less. It will be a small gratitude for my labor and will allow to develop the application. You can choose an increased amount at your discretion if you find my labor useful. Thank you for any donation.

## Development
You can suggest ideas to improve the app or create new apps. 
You can report bugs and they will be fixed.
Write to memorizator555@gmail.com

Thank you for choosing us!
""";
    }
  }
}
