// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'रेंटखाता';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get setUpProfile => 'प्रोफ़ाइल सेट करें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String error(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get appearance => 'रूप-रंग';

  @override
  String get theme => 'थीम';

  @override
  String get language => 'भाषा';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get chooseTheme => 'थीम चुनें';

  @override
  String get security => 'सुरक्षा';

  @override
  String get appLock => 'ऐप लॉक';

  @override
  String get biometricAuthentication => 'बायोमेट्रिक प्रमाणीकरण';

  @override
  String get billingAndCycles => 'बिलिंग और चक्र';

  @override
  String get anniversaryBilling => 'सालगिरह बिलिंग';

  @override
  String get configureBillingCycles =>
      'बिलिंग चक्र और नियत तिथियां कॉन्फ़िगर करें';

  @override
  String get billing => 'बिलिंग';

  @override
  String get electricityRates => 'बिजली दरें';

  @override
  String get viewAndUpdateElectricityRates => 'बिजली दरें देखें और अपडेट करें';

  @override
  String get messageTemplates => 'संदेश टेम्पलेट';

  @override
  String get customizeInvoice => 'चालान और रसीद संदेशों को अनुकूलित करें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get reminderSettings => 'रिमाइंडर सेटिंग्स';

  @override
  String get dueDateAndOverdue => 'नियत तिथि और अतिदेय रिमाइंडर';

  @override
  String get data => 'डेटा';

  @override
  String get backupAndRestore => 'बैकअप और रिस्टोर';

  @override
  String get saveOrRestoreData => 'अपना डेटा सहेजें या पुनर्स्थापित करें';

  @override
  String get about => 'किराया खाता के बारे में';

  @override
  String get aboutRentKhata => 'किराया खाता के बारे में';

  @override
  String get offlineFirstRentalApp =>
      'भारतीय मकान मालिकों के लिए ऑफलाइन-फर्स्ट रेंटल मैनेजमेंट ऐप।';

  @override
  String get tapToAddUpiId => 'यूपीआई आईडी जोड़ने के लिए टैप करें';

  @override
  String get reports => 'रिपोर्ट्स';

  @override
  String get attentionNeeded => 'ध्यान दें';

  @override
  String get livePropertyStatus => 'लाइव प्रॉपर्टी स्थिति';

  @override
  String get quickAdd => 'त्वरित जोड़ें';

  @override
  String get addProperty => 'प्रॉपर्टी जोड़ें';

  @override
  String get addTenant => 'किरायेदार जोड़ें';

  @override
  String get createBill => 'बिल बनाएं';

  @override
  String get goToRoomToCreateBills => 'बिल बनाने के लिए किसी कमरे में जाएं';

  @override
  String get pendingInvoices => 'लंबित चालान';

  @override
  String tenantsNeedBills(int count) {
    return '$count किरायेदारों के लिए बिल बनाने की आवश्यकता है';
  }

  @override
  String get collectPayments => 'भुगतान एकत्र करें';

  @override
  String billsAwaitPayment(int count) {
    return '$count जनरेट किए गए बिल भुगतान की प्रतीक्षा में';
  }

  @override
  String get renewAgreements => 'समझौते नवीनीकृत करें';

  @override
  String agreementsExpiring(int count) {
    return '$count समझौते जल्द ही समाप्त हो रहे हैं';
  }

  @override
  String get allCaughtUp => 'सब हो गया!';

  @override
  String get noBillingCyclesEnding =>
      'कोई बिलिंग चक्र जल्द ही समाप्त नहीं हो रहा है';

  @override
  String get noActiveRooms => 'कोई भी सक्रिय कमरे नहीं मिले';

  @override
  String get tenants => 'किरायेदार';

  @override
  String get searchByNameOrPhone => 'नाम या फोन से खोजें...';

  @override
  String get noTenantsYet => 'अभी तक कोई किरायेदार नहीं';

  @override
  String get noTenantsFound => 'कोई किरायेदार नहीं मिला';

  @override
  String get tenantsAppearHereAfterMoveIn =>
      'किरायेदारों को किसी कमरे में ले जाने के बाद वे यहां दिखाई देंगे';

  @override
  String get tryDifferentSearchTerm => 'एक अलग खोज शब्द का प्रयास करें';

  @override
  String get current => 'वर्तमान';

  @override
  String get past => 'पूर्व';

  @override
  String get property => 'प्रॉपर्टी';

  @override
  String get na => 'लागू नहीं';

  @override
  String get tenantDetail => 'किरायेदार विवरण';

  @override
  String get tenantNotFound => 'किरायेदार नहीं मिला';

  @override
  String get deleteTenant => 'किरायेदार हटाएं';

  @override
  String get personalDetails => 'व्यक्तिगत विवरण';

  @override
  String get fathersName => 'पिता का नाम';

  @override
  String get age => 'आयु';

  @override
  String years(int count) {
    return '$count वर्ष';
  }

  @override
  String get gender => 'लिंग';

  @override
  String get contactInformation => 'संपर्क जानकारी';

  @override
  String get phone => 'फोन';

  @override
  String get secondaryPhone => 'द्वितीयक फ़ोन';

  @override
  String get aadhaar => 'आधार';

  @override
  String get permanentAddress => 'स्थायी पता';

  @override
  String get address => 'पता';

  @override
  String get cityState => 'शहर, राज्य';

  @override
  String get pincode => 'पिन कोड';

  @override
  String get workDetails => 'कार्य विवरण';

  @override
  String get company => 'कंपनी';

  @override
  String get officeAddress => 'कार्यालय का पता';

  @override
  String get introducerReference => 'परिचयकर्ता / संदर्भ';

  @override
  String get name => 'नाम';

  @override
  String get overview => 'अवलोकन';

  @override
  String get pending => 'लंबित';

  @override
  String get history => 'इतिहास';

  @override
  String get expenses => 'खर्च';

  @override
  String get addExpense => 'खर्च जोड़ें';

  @override
  String get financialSummary => 'वित्तीय सारांश';

  @override
  String get outstanding => 'बकाया';

  @override
  String get overdue => 'अतिदेय';

  @override
  String get collected => 'एकत्रित';

  @override
  String urgent(int count) {
    return '$count तत्काल';
  }

  @override
  String get allOnTime => 'सब समय पर';

  @override
  String items(int count) {
    return '$count वस्तुएं';
  }

  @override
  String get errorLoadingBills => 'बिल लोड करने में त्रुटि';

  @override
  String get errorLoadingExpenses => 'खर्च लोड करने में त्रुटि';

  @override
  String get errorLoadingFinancials => 'वित्तीय डेटा लोड करने में त्रुटि';

  @override
  String get billsByType => 'प्रकार के अनुसार बिल';

  @override
  String get properties => 'प्रॉपर्टीज';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get noPropertiesYet => 'अभी तक कोई प्रॉपर्टी नहीं';

  @override
  String get addYourFirstProperty =>
      'शुरू करने के लिए अपनी पहली प्रॉपर्टी जोड़ें';

  @override
  String roomsCount(int count) {
    return '$count कमरे';
  }

  @override
  String occupiedPercent(int percent) {
    return '$percent% भरा हुआ';
  }

  @override
  String get propertyNotFound => 'प्रॉपर्टी नहीं मिली';

  @override
  String get deleteProperty => 'प्रॉपर्टी हटाएं';

  @override
  String get noRoomsYet => 'अभी तक कोई कमरे नहीं';

  @override
  String get addRoomsToStartManaging =>
      'किरायेदारों का प्रबंधन शुरू करने के लिए कमरे जोड़ें';

  @override
  String get addRoom => 'कमरा जोड़ें';

  @override
  String get deletePropertyTitle => 'प्रॉपर्टी हटाएं?';

  @override
  String confirmDeleteProperty(String propertyName) {
    return 'क्या आप वाकई \"$propertyName\" को हटाना चाहते हैं? इससे इस प्रॉपर्टी के सभी कमरे भी हट जाएंगे।';
  }

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get propertyDeleted => 'प्रॉपर्टी हटा दी गई';

  @override
  String occupancyCount(int count) {
    return '$count भरा हुआ';
  }

  @override
  String roomNumber(String number) {
    return 'कमरा $number';
  }

  @override
  String get vacant => 'खाली';

  @override
  String get perMonth => '/महीना';

  @override
  String get billDetails => 'बिल विवरण';

  @override
  String get editBill => 'बिल संपादित करें';

  @override
  String get deleteBill => 'बिल हटाएं';

  @override
  String get voidBill => 'बिल रद्द करें';

  @override
  String get sendReminder => 'अनुस्मारक भेजें';

  @override
  String get paymentHistory => 'भुगतान इतिहास';

  @override
  String get noPaymentsRecorded => 'कोई भुगतान रिकॉर्ड नहीं';

  @override
  String get notes => 'टिप्पणियाँ';

  @override
  String get reviewAndSend => 'समीक्षा करें और भेजें';

  @override
  String get shareInvoice => 'इनवॉइस साझा करें';

  @override
  String payAmount(String amount) {
    return '$amount का भुगतान करें';
  }

  @override
  String get save => 'सहेजें';

  @override
  String get share => 'साझा करें';

  @override
  String get saveInvoicePdf => 'इनवॉइस PDF सहेजें';

  @override
  String get voidBillTitle => 'बिल रद्द करें?';

  @override
  String get voidBillWarning =>
      'यह बिल को रद्द कर देगा। इस क्रिया को पूर्ववत नहीं किया जा सकता है।';

  @override
  String get voidReasonLabel => 'रद्द करने का कारण';

  @override
  String get voidReasonHint => 'उदा., गलत राशि';

  @override
  String get billMarkedVoid => 'बिल रद्द के रूप में चिह्नित';

  @override
  String get deleteBillTitle => 'बिल हटाएं?';

  @override
  String confirmDeleteBill(String billType, String period) {
    return 'क्या आप सुनिश्चित हैं कि आप इस $period के $billType बिल को हटाना चाहते हैं?\n\nइस क्रिया को पूर्ववत नहीं किया जा सकता है।';
  }

  @override
  String get billDeleted => 'बिल हटा दिया गया';

  @override
  String errorDeletingBill(String error) {
    return 'बिल हटाने में त्रुटि: $error';
  }

  @override
  String get overdueU => 'अतिदेय';

  @override
  String get total => 'कुल';

  @override
  String get paid => 'भुगतान किया गया';

  @override
  String get pendingTitle => 'लंबित';

  @override
  String get draft => 'ड्राफ्ट';

  @override
  String get sent => 'भेजा गया';

  @override
  String get partiallyPaid => 'आंशिक रूप से भुगतान किया गया';

  @override
  String get overdueBill => 'अतिदेय';

  @override
  String get voided => 'रद्द';

  @override
  String get billNumber => 'बिल नंबर';

  @override
  String get notAssigned => 'निर्धारित नहीं';

  @override
  String get type => 'प्रकार';

  @override
  String get billingPeriod => 'बिलिंग अवधि';

  @override
  String get dueDate => 'नियत तारीख';

  @override
  String get room => 'कमरा';

  @override
  String get tenant => 'किरायेदार';

  @override
  String get created => 'बनाया गया';

  @override
  String get monthlyRent => 'मासिक किराया';

  @override
  String get electricityBill => 'बिजली बिल';

  @override
  String get waterBill => 'पानी बिल';

  @override
  String get maintenance => 'रखरखाव';

  @override
  String get otherCharges => 'अन्य शुल्क';

  @override
  String get electricityDetails => 'बिजली का विवरण';

  @override
  String get previous => 'पिछला';

  @override
  String get meterPhoto => 'मीटर की फोटो';

  @override
  String get tapToViewFullSize => 'पूरा आकार देखने के लिए टैप करें';

  @override
  String get addMeterPhoto => 'मीटर की फोटो जोड़ें';

  @override
  String get takePhoto => 'फोटो लें';

  @override
  String get chooseFromGallery => 'गैलरी से चुनें';

  @override
  String get meterPhotoAdded => 'मीटर की फोटो सफलतापूर्वक जोड़ दी गई';

  @override
  String errorAddingPhoto(String error) {
    return 'फोटो जोड़ने में त्रुटि: $error';
  }

  @override
  String get editPayment => 'भुगतान संपादित करें';

  @override
  String get deletePayment => 'भुगतान हटाएं';

  @override
  String get deletePaymentTitle => 'भुगतान हटाएं?';

  @override
  String confirmDeletePayment(String amount, String date) {
    return 'क्या $date को किए गए $amount के भुगतान को हटा दें?\n\nयह बिल बैलेंस को अपडेट कर देगा।';
  }

  @override
  String get paymentDeleted => 'भुगतान हटा दिया गया';

  @override
  String get cash => 'नकद';

  @override
  String get upi => 'यूपीआई';

  @override
  String get bankTransfer => 'बैंक ट्रांसफर';

  @override
  String get cheque => 'चेक';

  @override
  String get other => 'अन्य';

  @override
  String get auditHistory => 'ऑडिट का इतिहास';

  @override
  String get noChangesRecorded => 'कोई परिवर्तन रिकॉर्ड नहीं किया गया';

  @override
  String get updated => 'अपडेट किया गया';

  @override
  String get deleted => 'हटा दिया गया';

  @override
  String get billAlreadyExists => 'बिल पहले से मौजूद है';

  @override
  String duplicateBillMessage(
    String type,
    String month,
    int year,
    String number,
  ) {
    return '$month $year के लिए $type बिल पहले से मौजूद है ($number)।\n\nक्या आप फिर भी एक और बिल बनाना चाहते हैं?';
  }

  @override
  String get createAnyway => 'फिर भी बनाएं';

  @override
  String get billCreated => 'बिल बनाया गया';

  @override
  String billCreatedWithRate(String rate) {
    return 'बिल बनाया गया। ग्लोबल रेट ₹$rate/यूनिट पर अपडेट कर दिया गया है';
  }

  @override
  String get meterReadings => 'मीटर रीडिंग';

  @override
  String get currentReading => 'वर्तमान रीडिंग';

  @override
  String get ratePerUnit => 'प्रति यूनिट रेट:';

  @override
  String get electricityCalculation => 'बिजली बिल की गणना';

  @override
  String get units => 'यूनिट';

  @override
  String unitsCalculation(String units, String rate) {
    return '$units यूनिट × $rate';
  }

  @override
  String get optionalVerification => 'वैकल्पिक - सत्यापन में मदद करता है';

  @override
  String get tapToChangePhoto => 'तस्वीर बदलने के लिए टैप करें';

  @override
  String get billAmountLabel => 'बिल राशि (₹) *';

  @override
  String get notesOptional => 'नोट्स (वैकल्पिक)';

  @override
  String get anniversary => 'वर्षगांठ';

  @override
  String get advance => 'अग्रिम';

  @override
  String get currentLabel => 'वर्तमान';

  @override
  String cycleExceedsAgreementWarning(String date) {
    return 'यह बिलिंग चक्र एग्रीमेंट खत्म होने की तारीख ($date) से आगे जा रहा है';
  }

  @override
  String amountCannotBeLessThanPaid(String amount) {
    return 'राशि भुगतान की गई राशि $amount से कम नहीं हो सकती';
  }

  @override
  String get billUpdatedSuccessfully => 'बिल सफलतापूर्वक अपडेट किया गया';

  @override
  String get partiallyPaidBillWarning =>
      'इस बिल के लिए भुगतान प्राप्त हो चुके हैं। राशि केवल बढ़ाई जा सकती है। यह भुगतान की गई राशि से कम नहीं हो सकती।';

  @override
  String paidAmount(String amount) {
    return 'भुगतान किया गया: $amount';
  }

  @override
  String minAmount(String amount) {
    return 'न्यूनतम राशि: $amount';
  }

  @override
  String get notSet => 'सेट नहीं है';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get amountLabel => 'राशि';

  @override
  String amountCannotExceedPendingBalance(String amount) {
    return 'राशि बकाया राशि $amount से अधिक नहीं हो सकती';
  }

  @override
  String get recordPayment => 'भुगतान रिकॉर्ड करें';

  @override
  String dueAmount(String amount) {
    return 'बकाया: $amount';
  }

  @override
  String get enterAmount => 'राशि दर्ज करें';

  @override
  String get payFullDue => 'पूरा बकाया चुकाएं';

  @override
  String get date => 'तारीख';

  @override
  String get addNoteOptional => 'नोट जोड़ें (वैकल्पिक)';

  @override
  String get paymentComplete => 'भुगतान पूरा हुआ!';

  @override
  String get paymentRecorded => 'भुगतान रिकॉर्ड किया गया';

  @override
  String get billFullyPaidLabel => 'बिल का पूरा भुगतान हो गया है';

  @override
  String get partialPaymentRecorded => 'आंशिक भुगतान दर्ज किया गया';

  @override
  String get invoiceLabel => 'इनवॉइस';

  @override
  String get periodLabel => 'अवधि';

  @override
  String get roomLabel => 'कमरा';

  @override
  String get paymentAmountLabel => 'भुगतान राशि';

  @override
  String get paymentModeLabel => 'भुगतान का प्रकार';

  @override
  String get billTotalLabel => 'कुल बिल';

  @override
  String get paidLabel => 'भुगतान किया';

  @override
  String get balanceLabel => 'बचा हुआ';

  @override
  String get closeLabel => 'बंद करें';

  @override
  String get electricity => 'बिजली';

  @override
  String get water => 'पानी';

  @override
  String amountCannotExceedMax(String amount) {
    return 'राशि $amount से अधिक नहीं हो सकती';
  }

  @override
  String get paymentUpdated => 'भुगतान अपडेट किया गया';

  @override
  String originalAmount(String amount) {
    return 'मूल: $amount';
  }

  @override
  String get paymentAmountRequiredLabel => 'भुगतान राशि (₹) *';

  @override
  String get paymentDateLabel => 'भुगतान की तारीख';

  @override
  String get notesOptionalLabel => 'नोट (वैकल्पिक)';

  @override
  String get updatePayment => 'भुगतान अपडेट करें';

  @override
  String get invoicePreview => 'इनवॉइस पूर्वावलोकन';

  @override
  String get viewPdf => 'पीडीएफ देखें';

  @override
  String errorPreviewingPdf(String error) {
    return 'पीडीएफ दिखाने में त्रुटि: $error';
  }

  @override
  String errorSharingPdf(String error) {
    return 'पीडीएफ साझा करने में त्रुटि: $error';
  }

  @override
  String invoiceNumber(String number) {
    return 'इनवॉइस $number';
  }

  @override
  String get billTo => 'बिल प्राप्तकर्ता';

  @override
  String unitsAmount(String amount) {
    return '$amount यूनिट';
  }

  @override
  String unitsConsumedRate(String units, String rate) {
    return '$units यूनिट @ $rate/यूनिट';
  }

  @override
  String get scanToPay => 'भुगतान के लिए स्कैन करें';

  @override
  String generatedOn(String date) {
    return 'जारी तिथि: $date';
  }

  @override
  String get sentStatus => 'भेजा गया';

  @override
  String get partialStatus => 'आंशिक';

  @override
  String get paidStatus => 'भुगतान किया गया';

  @override
  String get overdueStatus => 'बकाया है';

  @override
  String get voidedStatus => 'रद्द';

  @override
  String get landlord => 'मकान मालिक';

  @override
  String get previousReading => 'पिछली रीडिंग';

  @override
  String get unitsConsumed => 'उपभोग की गई यूनिट';

  @override
  String get notesLabel => 'नोट';

  @override
  String get totalAmount => 'कुल राशि';

  @override
  String get balanceDueLabel => 'बकाया राशि';

  @override
  String get amount => 'राशि';

  @override
  String get invoiceSavedToDownloads => 'इनवॉइस डाउनलोड में सहेजा गया';

  @override
  String get ok => 'ठीक है';

  @override
  String errorSavingPdf(String error) {
    return 'PDF सहेजने में त्रुटि: $error';
  }

  @override
  String errorLoadingAuditLogs(String error) {
    return 'ऑडिट लॉग लोड करने में त्रुटि: $error';
  }

  @override
  String get previousCycle => 'पिछला चक्र';

  @override
  String get nextCycle => 'अगला चक्र';

  @override
  String get monthLabel => 'महीना';

  @override
  String get yearLabel => 'वर्ष';

  @override
  String get removePhoto => 'फोटो हटाएं';

  @override
  String get january => 'जनवरी';

  @override
  String get february => 'फ़रवरी';

  @override
  String get march => 'मार्च';

  @override
  String get april => 'अप्रैल';

  @override
  String get may => 'मई';

  @override
  String get june => 'जून';

  @override
  String get july => 'जुलाई';

  @override
  String get august => 'अगस्त';

  @override
  String get september => 'सितंबर';

  @override
  String get october => 'अक्टूबर';

  @override
  String get november => 'नवंबर';

  @override
  String get december => 'दिसंबर';

  @override
  String get jan => 'जनवरी';

  @override
  String get feb => 'फ़रवरी';

  @override
  String get mar => 'मार्च';

  @override
  String get apr => 'अप्रैल';

  @override
  String get mayShort => 'मई';

  @override
  String get jun => 'जून';

  @override
  String get jul => 'जुलाई';

  @override
  String get aug => 'अगस्त';

  @override
  String get sep => 'सितंबर';

  @override
  String get oct => 'अक्टूबर';

  @override
  String get nov => 'नवंबर';

  @override
  String get dec => 'दिसंबर';

  @override
  String get roomTitle => 'कमरा';

  @override
  String get roomNotFound => 'कमरा नहीं मिला';

  @override
  String get statementLabel => 'विवरण';

  @override
  String get occupiedStatus => 'कब्जे में';

  @override
  String get moveOutBtn => 'बाहर जाएँ';

  @override
  String get agreedRent => 'सहमत किराया';

  @override
  String get securityDepositLabel => 'सुरक्षा जमा';

  @override
  String get billingStartLabel => 'बिलिंग प्रारंभ';

  @override
  String get editBtn => 'संपादित करें';

  @override
  String get selectBillingStartDate => 'बिलिंग प्रारंभ तिथि का चयन करें';

  @override
  String get failedToUpdateBillingStart =>
      'बिलिंग प्रारंभ तिथि को अपडेट करने में विफल';

  @override
  String get roomIsVacant => 'कमरा खाली है';

  @override
  String get assignTenantToStartCollecting =>
      'किराया लेना शुरू करने के लिए किरायेदार को असाइन करें';

  @override
  String get moveInTenantBtn => 'किरायेदार को अंदर लाएं';

  @override
  String get noBillsYet => 'अभी तक कोई बिल नहीं';

  @override
  String get activeBills => 'सक्रिय बिल';

  @override
  String get paidCaps => 'भुगतान किया';

  @override
  String get dueCaps => 'बकाया है';

  @override
  String get voidLabel => 'रद्द';

  @override
  String get remindBtn => 'याद दिलाएं';

  @override
  String get payNowBtn => 'अभी भुगतान करें';

  @override
  String get viewBtn => 'देखें';

  @override
  String get shareBtn => 'साझा करें';

  @override
  String get monthlyRentLabel => 'मासिक किराया';

  @override
  String get electricityBillLabel => 'बिजली का बिल';

  @override
  String get waterBillLabel => 'पानी का बिल';

  @override
  String get maintenanceLabel => 'रखरखाव';

  @override
  String get sendInvoiceBtn => 'इनवॉइस भेजें';

  @override
  String viewBillHistory(int count) {
    return 'बिल इतिहास देखें ($count)';
  }

  @override
  String get otherChargesLabel => 'अन्य शुल्क';

  @override
  String get documentTitle => 'दस्तावेज़ का शीर्षक';

  @override
  String get addBtn => 'जोड़ें';

  @override
  String get pleaseSelectTenant => 'कृपया एक किरायेदार चुनें';

  @override
  String get tenantMovedInSuccess => 'किरायेदार सफलतापूर्वक अंदर आ गया है';

  @override
  String get incompleteProfile => 'अधूरी प्रोफाइल';

  @override
  String get completeLaterMsg => 'इन्हें बाद में एडिट टेनांट पेज से पूरा करें';

  @override
  String get goBack => 'पीछे जाएँ';

  @override
  String get saveAnyway => 'फिर भी सहेजें';

  @override
  String get addFamilyMember => 'परिवार के सदस्य को जोड़ें';

  @override
  String get spouse => 'जीवनसाथी';

  @override
  String get child => 'बच्चा';

  @override
  String get parent => 'माता-पिता';

  @override
  String get sibling => 'भाई-बहन';

  @override
  String get otherRelation => 'अन्य';

  @override
  String get ageLabel => 'आयु';

  @override
  String get genderLabel => 'लिंग';

  @override
  String get maleLabel => 'पुरुष';

  @override
  String get femaleLabel => 'महिला';

  @override
  String get nameAndRelRequired => 'नाम और संबंध आवश्यक है';

  @override
  String get moveInTenantTitle => 'किरायेदार को अंदर लाएं';

  @override
  String get existingTenant => 'मौजूदा किरायेदार';

  @override
  String get newTenant => 'नया किरायेदार';

  @override
  String get essentialInfo => 'आवश्यक जानकारी';

  @override
  String get nameLabel => 'नाम';

  @override
  String get phoneLabel => 'फ़ोन नंबर';

  @override
  String get addressLine => 'पता पंक्ति';

  @override
  String get cityLabel => 'शहर';

  @override
  String get stateLabel => 'राज्य';

  @override
  String get pincodeLabel => 'पिन कोड';

  @override
  String get idDocuments => 'पहचान दस्तावेज़';

  @override
  String get aadhaarNumber => 'आधार नंबर';

  @override
  String get aadhaarCardPhotos => 'आधार कार्ड की तस्वीरें';

  @override
  String get frontLabel => 'सामने';

  @override
  String get backLabel => 'पीछे';

  @override
  String get policeVerificationStatus => 'पुलिस सत्यापन स्थिति';

  @override
  String get clearBtn => 'साफ़ करें';

  @override
  String get takePhotoBtn => 'फोटो लें';

  @override
  String get uploadGalleryBtn => 'गैलरी से अपलोड करें';

  @override
  String get addMemberMsg => 'सदस्य जोड़ें';

  @override
  String get electricitySetup => 'बिजली सेटअप';

  @override
  String get currentMeterReading => 'वर्तमान मीटर रीडिंग';

  @override
  String get currentRatePerUnit => 'प्रति यूनिट वर्तमान दर';

  @override
  String get aadhaarFrontPhoto => 'आधार के सामने की फोटो';

  @override
  String get aadhaarBackPhoto => 'आधार के पीछे की फोटो';

  @override
  String get companyName => 'कंपनी का नाम';

  @override
  String get introducerName => 'परिचयकर्ता का नाम';

  @override
  String get introducerAddress => 'परिचयकर्ता का पता';

  @override
  String get introducerPhone => 'परिचयकर्ता का फोन';

  @override
  String get additionalDocuments => 'अतिरिक्त दस्तावेज़';

  @override
  String get addDocumentBtn => 'दस्तावेज़ जोड़ें';

  @override
  String get familyMembers => 'परिवार के सदस्य';

  @override
  String get addNewBtn => 'नया जोड़ें';

  @override
  String get noFamilyMembersYet => 'अभी तक कोई परिवार का सदस्य नहीं जोड़ा गया';

  @override
  String get selectTenant => 'किरायेदार चुनें';

  @override
  String get futureLabel => 'भविष्य';

  @override
  String get startBillingFrom => 'बिलिंग यहाँ से शुरू करें';

  @override
  String get billsNotTrackedMsg =>
      'इस तिथि से पहले के बिल ट्रैक नहीं किए जाएंगे';

  @override
  String get autoLabel => 'स्वतः';

  @override
  String get noAgreementDateSet => 'कोई समझौता तिथि निर्धारित नहीं';

  @override
  String get rent => 'किराया';

  @override
  String get pastTenant => 'पिछला किरायेदार';

  @override
  String get moveOutSettlement => 'अंतिम भुगतान';

  @override
  String get pendingBillsToDeduct => 'बकाया बिल';

  @override
  String get undoVoid => 'अमान्य रद्द करें';

  @override
  String get markAsVoid => 'अमान्य करें';

  @override
  String get otherDeductionsTitle => 'अन्य कटौतियां';

  @override
  String get totalDeposit => 'कुल जमा';

  @override
  String get billDeductions => 'बिल कटौतियां';

  @override
  String get tenantOwes => 'किरायेदार का बकाया';

  @override
  String get refundableAmount => 'वापसी योग्य राशि';

  @override
  String get settledViaDeposit => 'जमा से कटा हुआ';

  @override
  String get confirmMoveOutRecord => 'बकाया दर्ज़ करें और बाहर निकलें';

  @override
  String get confirmMoveOutSettle => 'भुगतान करें और बाहर निकलें';

  @override
  String get moveOutDate => 'बाहर निकलने की तिथि';

  @override
  String get errorPrefix => 'त्रुटि: ';

  @override
  String get ledgerNotFound => 'खाता नहीं मिला';

  @override
  String get tenantT => 'किरायेदार';

  @override
  String overdueByDays(int days) {
    return '$days दिन से बकाया';
  }

  @override
  String amountDueSuffix(String amount) {
    return '$amount बाकी';
  }

  @override
  String get khataStatement => 'खाता विवरण';

  @override
  String get fromLabel => 'प्रेषक:';

  @override
  String get toLabel => 'प्राप्तकर्ता:';

  @override
  String roomNoLabel(String roomNumber) {
    return 'कमरा नंबर: $roomNumber';
  }

  @override
  String get totalBilledLabel => 'कुल बिल';

  @override
  String get totalPaidLabel => 'कुल भुगतान';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get descriptionLabel => 'विवरण';

  @override
  String get billedLabel => 'बिल हुआ';

  @override
  String advanceLabel(String amount) {
    return '$amount (अग्रिम)';
  }

  @override
  String get systemGeneratedMsg =>
      'यह सिस्टम द्वारा तैयार किया गया विवरण है और इसके लिए भौतिक हस्ताक्षर की आवश्यकता नहीं है।';

  @override
  String get moveOutSettlementTitle => 'अंतिम हिसाब';

  @override
  String moveOutDateLabel(String date) {
    return 'बाहर निकलने की तिथि: $date';
  }

  @override
  String moveInDateLabel(String date) {
    return 'प्रवेश तिथि: $date';
  }

  @override
  String get initialSecurityDeposit => 'प्रारंभिक जमा राशि';

  @override
  String get deductionsLabel => 'कटौतियां';

  @override
  String get amountDeductedLabel => 'काटी गई राशि';

  @override
  String get finalRefundAmount => 'अंतिम वापसी योग्य राशि';

  @override
  String get amountTenantOwes => 'किरायेदार पर बकाया राशि';

  @override
  String get accountSettledMsg => 'हिसाब चुकता - कोई बकाया नहीं';

  @override
  String get tenantSignature => 'किरायेदार के हस्ताक्षर';

  @override
  String get landlordSignature => 'मकान मालिक के हस्ताक्षर';

  @override
  String get computerGeneratedMsg =>
      'यह कंप्यूटर द्वारा तैयार किया गया विवरण है और इसके लिए भौतिक हस्ताक्षर की आवश्यकता नहीं है।';

  @override
  String get aboutLabel => '[HI] About Label';

  @override
  String get aboutRentKhataDescription => '[HI] About Rent Khata Description';

  @override
  String alertDaysBeforeCycle(int count) {
    return '[HI] Alert $count days before';
  }

  @override
  String get anniversaryBillingByBillType =>
      '[HI] Anniversary Billing By Bill Type';

  @override
  String get anniversaryBillingSubtitle => '[HI] Anniversary Billing Subtitle';

  @override
  String get backupAndRestoreSubtitle => '[HI] Backup And Restore Subtitle';

  @override
  String get backupCreatedShare => '[HI] Backup Created Share';

  @override
  String get backupInfoText => '[HI] Backup Info Text';

  @override
  String get backupRestoredSuccess => '[HI] Backup Restored Success';

  @override
  String get billDueSoon => '[HI] Bill Due Soon';

  @override
  String get billFullyPaid => '[HI] Bill Fully Paid';

  @override
  String get billFullyPaidSubtitle => '[HI] Bill Fully Paid Subtitle';

  @override
  String get billingCycleEnding => '[HI] Billing Cycle Ending';

  @override
  String get billingLabel => '[HI] Billing Label';

  @override
  String get billingReminders => '[HI] Billing Reminders';

  @override
  String get biometricFallbackInfo => '[HI] Biometric Fallback Info';

  @override
  String get biometricLock => '[HI] Biometric Lock';

  @override
  String get biometricLockSubtitle => '[HI] Biometric Lock Subtitle';

  @override
  String get biometricsNotAvailable => '[HI] Biometrics Not Available';

  @override
  String get changesSavedAutomatically => '[HI] Changes Saved Automatically';

  @override
  String get createBackupToKeepSafe => '[HI] Create Backup To Keep Safe';

  @override
  String get createShareBackup => '[HI] Create Share Backup';

  @override
  String get criticalUrgentAttention => '[HI] Critical Urgent Attention';

  @override
  String get currentRate => '[HI] Current Rate';

  @override
  String get dataLabel => '[HI] Data Label';

  @override
  String daysCount(int count) {
    return '[HI] $count days';
  }

  @override
  String get deviceDoesNotSupportBiometrics =>
      '[HI] Device Does Not Support Biometrics';

  @override
  String get discard => '[HI] Discard';

  @override
  String get dueDateOffsetSubtitle => '[HI] Due Date Offset Subtitle';

  @override
  String dueDaysAfterCycle(int count) {
    return '[HI] Due $count days after cycle ends';
  }

  @override
  String get dueSoonAlert => '[HI] Due Soon Alert';

  @override
  String get dueSoonAlertSubtitle => '[HI] Due Soon Alert Subtitle';

  @override
  String get editProfile => '[HI] Edit Profile';

  @override
  String effectiveFrom(String date) {
    return '[HI] Effective from $date';
  }

  @override
  String get electricityMeterBills => '[HI] Electricity Meter Bills';

  @override
  String get electricityRateInfoText => '[HI] Electricity Rate Info Text';

  @override
  String get electricityRatesSubtitle => '[HI] Electricity Rates Subtitle';

  @override
  String get enableAppLock => '[HI] Enable App Lock';

  @override
  String get enterValidRate => '[HI] Enter Valid Rate';

  @override
  String get firstReminderAfterDueDate => '[HI] First Reminder After Due Date';

  @override
  String get generalSettingsLabel => '[HI] General Settings Label';

  @override
  String get localBackups => '[HI] Local Backups';

  @override
  String get lockAfterInactivity => '[HI] Lock After Inactivity';

  @override
  String get lockOnExit => '[HI] Lock On Exit';

  @override
  String get lockOnExitSubtitle => '[HI] Lock On Exit Subtitle';

  @override
  String get maintenanceCharges => '[HI] Maintenance Charges';

  @override
  String get messageBody => '[HI] Message Body';

  @override
  String get messageTemplatesSubtitle => '[HI] Message Templates Subtitle';

  @override
  String minutes(int count) {
    return '[HI] $count minutes';
  }

  @override
  String get mobileNumberHint => '[HI] Mobile Number Hint';

  @override
  String get monthlyRentBills => '[HI] Monthly Rent Bills';

  @override
  String get monthlySummary => '[HI] Monthly Summary';

  @override
  String get monthlySummarySubtitle => '[HI] Monthly Summary Subtitle';

  @override
  String get never => '[HI] Never';

  @override
  String get noBiometricsEnrolled => '[HI] No Biometrics Enrolled';

  @override
  String get noLocalBackups => '[HI] No Local Backups';

  @override
  String get noRateHistory => '[HI] No Rate History';

  @override
  String get notEnabled => '[HI] Not Enabled';

  @override
  String get notificationSettings => '[HI] Notification Settings';

  @override
  String get notificationTime => '[HI] Notification Time';

  @override
  String get notificationsWorking => '[HI] Notifications Working';

  @override
  String get oneDayOverdue => '[HI] One Day Overdue';

  @override
  String get oneMinute => '[HI] One Minute';

  @override
  String get oneWeekOverdue => '[HI] One Week Overdue';

  @override
  String get overdueFollowUps => '[HI] Overdue Follow Ups';

  @override
  String get paymentNotifications => '[HI] Payment Notifications';

  @override
  String get paymentReceived => '[HI] Payment Received';

  @override
  String get paymentReceivedSubtitle => '[HI] Payment Received Subtitle';

  @override
  String get permissionDenied => '[HI] Permission Denied';

  @override
  String get profileUpdated => '[HI] Profile Updated';

  @override
  String get quietHours => '[HI] Quiet Hours';

  @override
  String get rateHistory => '[HI] Rate History';

  @override
  String get ratePerUnitLabel => '[HI] Rate Per Unit Label';

  @override
  String get rateUpdated => '[HI] Rate Updated';

  @override
  String get receiptLabel => '[HI] Receipt Label';

  @override
  String remindDaysBeforeCycleEnds(int days) {
    return '[HI] Remind $days days before cycle ends';
  }

  @override
  String remindDaysBeforeDueDate(int days) {
    return '[HI] Remind $days days before due date';
  }

  @override
  String get reminderLabel => '[HI] Reminder Label';

  @override
  String get reminderSettingsSubtitle => '[HI] Reminder Settings Subtitle';

  @override
  String get requireBiometric => '[HI] Require Biometric';

  @override
  String get resetBtn => '[HI] Reset Btn';

  @override
  String get resetTemplateWarning => '[HI] Reset Template Warning';

  @override
  String get resetToDefault => '[HI] Reset To Default';

  @override
  String get restartNowBtn => '[HI] Restart Now Btn';

  @override
  String get restoreBackupTitle => '[HI] Restore Backup Title';

  @override
  String get restoreBackupWarning => '[HI] Restore Backup Warning';

  @override
  String get restoreBtn => '[HI] Restore Btn';

  @override
  String get restoreFailedPrefix => '[HI] Restore Failed Prefix';

  @override
  String get restoreFromDevice => '[HI] Restore From Device';

  @override
  String get restoreFromDeviceSubtitle => '[HI] Restore From Device Subtitle';

  @override
  String get restoreSuccessTitle => '[HI] Restore Success Title';

  @override
  String get saveDataToFile => '[HI] Save Data To File';

  @override
  String get saveProfile => '[HI] Save Profile';

  @override
  String get secondReminder => '[HI] Second Reminder';

  @override
  String get sendTestNotification => '[HI] Send Test Notification';

  @override
  String get setNewRate => '[HI] Set New Rate';

  @override
  String get setupFingerprintFirst => '[HI] Setup Fingerprint First';

  @override
  String get template => '[HI] Template';

  @override
  String get templateAlreadyDefault => '[HI] Template Already Default';

  @override
  String get templatePlaceholders => '[HI] Template Placeholders';

  @override
  String get templateResetSuccess => '[HI] Template Reset Success';

  @override
  String get templateSavedSuccess => '[HI] Template Saved Success';

  @override
  String templateUsedWhenSharing(String type) {
    return '[HI] Template used when sharing $type';
  }

  @override
  String get testNotificationTitle => '[HI] Test Notification Title';

  @override
  String get threeDaysOverdue => '[HI] Three Days Overdue';

  @override
  String get twoWeeksOverdue => '[HI] Two Weeks Overdue';

  @override
  String get unit => '[HI] Unit';

  @override
  String get updateRate => '[HI] Update Rate';

  @override
  String get upiId => '[HI] Upi Id';

  @override
  String get upiIdHelperText => '[HI] Upi Id Helper Text';

  @override
  String get upiIdHint => '[HI] Upi Id Hint';

  @override
  String versionLabel(String version) {
    return '[HI] Version $version';
  }

  @override
  String get weeklyReminder => '[HI] Weekly Reminder';

  @override
  String get yourName => '[HI] Your Name';

  @override
  String get documentPdf => 'document.pdf';

  @override
  String errorSharingMessage(String error) {
    return '[HI] संदेश साझा करने में विफल: $error';
  }

  @override
  String get downloadsFolder => 'Downloads';

  @override
  String get savedToDownloads => 'डाउनलोड में सहेजा गया';

  @override
  String get couldNotSavePdf =>
      '[HI] PDF सहेजने में विफल। कृपया पुन: प्रयास करें।';

  @override
  String get unableToLoadPdfPreview => '[HI] PDF प्रीव्यू लोड करने में असमर्थ';
}
