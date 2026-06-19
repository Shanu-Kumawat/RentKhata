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
  String get welcomeTitle => 'सुगम किराया प्रबंधन';

  @override
  String get welcomeSubtitle =>
      'एक सुंदर सुरक्षित, ऑफ़लाइन बहीखाता में किरायेदारों, बिलों और भुगतानों को ट्रैक करें।';

  @override
  String get startOrganizing => 'व्यवस्थित करना शुरू करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get setUpProfile => 'प्रोफ़ाइल सेट करें';

  @override
  String get byContinuingYouAgree => 'जारी रखकर, आप हमारी ';

  @override
  String get termsOfService => 'सेवा की शर्तों';

  @override
  String get and => ' और ';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String get openSourceLicenses => 'ओपन सोर्स लाइसेंस';

  @override
  String couldNotOpenLink(String error) {
    return 'लिंक नहीं खुल सका: $error';
  }

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
  String get dateToDateBilling => 'तारीख-से-तारीख बिलिंग';

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
  String get cancel => 'कैंसल';

  @override
  String get delete => 'हटाएं';

  @override
  String get propertyDeleted => 'प्रॉपर्टी हटा दी गई';

  @override
  String get deleteRoom => 'कमरा मिटाएं';

  @override
  String get deleteRoomTitle => 'कमरा मिटाएं?';

  @override
  String confirmDeleteRoom(String roomNumber) {
    return 'क्या आप वाकई कमरा \"$roomNumber\" मिटाना चाहते हैं? यह कार्रवाई पहले जैसी नहीं की जा सकती।';
  }

  @override
  String get roomDeletedSuccess => 'कमरा मिटा दिया गया';

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
  String get save => 'सेव करें';

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
  String get takePhoto => 'फ़ोटो लें';

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
  String get dateToDate => 'तारीख-से-तारीख';

  @override
  String get advance => 'अग्रिम';

  @override
  String get currentLabel => 'अभी लागू';

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
  String get amountLabel => 'रकम';

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
  String get invoiceAttachmentMeterProof => 'संलग्नक: मीटर रीडिंग प्रमाण';

  @override
  String invoiceReference(String number) {
    return 'इनवॉइस संदर्भ: #$number';
  }

  @override
  String invoiceReadings(String prev, String curr) {
    return 'रीडिंग: $prev - $curr';
  }

  @override
  String invoiceConsumption(String units, String rate) {
    return 'खपत: $units यूनिट @ Rs. $rate';
  }

  @override
  String get invoiceUpiTerms =>
      '3. ऊपर दिए गए विवरण पर UPI के माध्यम से भुगतान करें।';

  @override
  String get debugViewScheduledNotifications =>
      'शेड्यूल की गई सूचनाएं देखें (डीबग)';

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
  String get securityDepositLabel => 'सुरक्षा जमा (₹)';

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
  String get monthlyRentLabel => 'मासिक किराया (Rs.) *';

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
  String get ageLabel => 'उम्र';

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
  String get takePhotoBtn => 'तस्वीर लें';

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
  String get errorPrefix => 'समस्या: ';

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
  String get aboutLabel => 'ऐप के बारे में';

  @override
  String get aboutRentKhataDescription =>
      'विशेष रूप से भारतीय मकान मालिकों के लिए बनाया गया। रेंटखाता (RentKhata) एक सुरक्षित और 100% ऑफ़लाइन ऐप है जिससे आप अपने फोन से प्रॉपर्टी, किरायेदारों और किराए का हिसाब रख सकते हैं।';

  @override
  String alertDaysBeforeCycle(int count) {
    return 'महीना पूरा होने से $count दिन पहले अलर्ट करें';
  }

  @override
  String get dateToDateBillingByBillType =>
      'तारीख-से-तारीख बिलिंग बिल प्रकार के अनुसार';

  @override
  String get dateToDateBillingSubtitle =>
      'प्रवेश की तारीख के आधार पर बिलिंग अवधि की गणना करें।';

  @override
  String get backupAndRestoreSubtitle => 'अपना डेटा सुरक्षित रखें';

  @override
  String get backupCreatedShare => 'बैकअप सफलतापूर्वक सेव किया गया';

  @override
  String get backupInfoText =>
      'यदि आप ऐप अनइंस्टॉल करते हैं या डिवाइस बदलते हैं, तो डेटा न खोने के लिए अपने डेटा को बाहरी रूप से सुरक्षित करें।';

  @override
  String get backupRestoredSuccess => 'बैकअप सफलतापूर्वक रिस्टोर किया गया!';

  @override
  String get billDueSoon => 'बिल भरने की तारीख नज़दीक है';

  @override
  String get billFullyPaid => 'बिल का पूरा भुगतान हो गया';

  @override
  String get billFullyPaidSubtitle => 'कोई बकाया राशि नहीं है';

  @override
  String get billingCycleEnding => 'महीना पूरा होने वाला है';

  @override
  String get billingLabel => 'बिलिंग';

  @override
  String get billingReminders => 'बिलिंग से जुड़े रिमाइंडर्स';

  @override
  String get biometricFallbackInfo =>
      'फिंगरप्रिंट काम न करने पर पिन का इस्तेमाल करें';

  @override
  String get biometricLock => 'ऐप लॉक';

  @override
  String get biometricLockSubtitle =>
      'ऐप को फिंगरप्रिंट या फेस आईडी से सुरक्षित रखें';

  @override
  String get biometricsNotAvailable =>
      'आपके फ़ोन में फिंगरप्रिंट या फेस लॉक की सुविधा नहीं है';

  @override
  String get changesSavedAutomatically => 'बदलाव अपने आप सेव हो जाते हैं';

  @override
  String get createBackupToKeepSafe =>
      'यह सुनिश्चित करने के लिए कि आपका डेटा हमेशा सुरक्षित रहे और किसी भी समय आसानी से रिस्टोर किया जा सके, एक बाहरी बैकअप बनाएं';

  @override
  String get createShareBackup => 'बैकअप सेव करें';

  @override
  String get criticalUrgentAttention => 'अति आवश्यक (अर्जेंट)';

  @override
  String get currentRate => 'अभी की दर';

  @override
  String get dataLabel => 'डेटा और बैकअप';

  @override
  String daysCount(int count) {
    return '$count दिन';
  }

  @override
  String get deviceDoesNotSupportBiometrics =>
      'आपके डिवाइस में फिंगरप्रिंट या फेस लॉक सपोर्ट नहीं करता';

  @override
  String get discard => 'हटाएं';

  @override
  String get dueDateOffsetSubtitle =>
      'महीना पूरा होने के बाद बिल भरने की आखिरी तारीख तय करें';

  @override
  String dueDaysAfterCycle(int count) {
    return 'महीना पूरा होने के $count दिन बाद बिल भरना है';
  }

  @override
  String get dueSoonAlert => 'देय तिथि (Due Date) से पहले अलर्ट';

  @override
  String get dueSoonAlertSubtitle => 'आखिरी तारीख निकलने से पहले याद दिलाएं';

  @override
  String get editProfile => 'प्रोफ़ाइल अपडेट करें';

  @override
  String effectiveFrom(String date) {
    return '$date से लागू';
  }

  @override
  String get electricityMeterBills => 'बिजली के बिल';

  @override
  String get electricityRateInfoText =>
      'यह बिजली की दर सभी नए बिलों पर लागू होगी। पहले से बने बिलों पर इसका कोई प्रभाव नहीं पड़ेगा।';

  @override
  String get electricityRatesSubtitle => 'बिजली की दरें सेट करें';

  @override
  String get enableAppLock => 'ऐप लॉक चालू करें';

  @override
  String get enterValidRate => 'कृपया सही दर डालें';

  @override
  String get firstReminderAfterDueDate => 'आखिरी तारीख के बाद पहला रिमाइंडर';

  @override
  String get generalSettingsLabel => 'सामान्य सेटिंग्स';

  @override
  String get localBackups => 'फ़ोन में बैकअप';

  @override
  String get lockAfterInactivity => 'इस्तेमाल न करने पर लॉक करें';

  @override
  String get lockOnExit => 'ऐप बंद करने पर लॉक करें';

  @override
  String get lockOnExitSubtitle => 'ऐप से बाहर निकलते ही ऐप लॉक हो जाएगा';

  @override
  String get maintenanceCharges => 'रखरखाव (मेंटेनेंस) शुल्क';

  @override
  String get messageBody => 'संदेश';

  @override
  String get messageTemplatesSubtitle =>
      'SMS और WhatsApp मैसेज को अपने हिसाब से बदलें';

  @override
  String minutes(int count) {
    return '$count मिनट';
  }

  @override
  String get mobileNumberHint => 'अपना मोबाइल नंबर डालें';

  @override
  String get monthlyRentBills => 'महीने के किराये का बिल';

  @override
  String get monthlySummary => 'महीने का हिसाब (सारांश)';

  @override
  String get monthlySummarySubtitle => 'महीने के अंत में पूरी रिपोर्ट पाएं';

  @override
  String get never => 'कभी नहीं';

  @override
  String get noBiometricsEnrolled =>
      'फ़ोन में कोई फिंगरप्रिंट या फेस आईडी सेट नहीं है';

  @override
  String get noLocalBackups => 'कोई लोकल बैकअप नहीं है';

  @override
  String get noRateHistory => 'पुरानी दरों का कोई रिकॉर्ड नहीं है';

  @override
  String get notEnabled => 'चालू नहीं है';

  @override
  String get notificationSettings => 'नोटिफ़िकेशन सेटिंग्स';

  @override
  String get notificationTime => 'नोटिफ़िकेशन का समय';

  @override
  String get notificationsWorking => 'नोटिफ़िकेशन चालू हैं';

  @override
  String get oneDayOverdue => 'एक दिन की देरी';

  @override
  String get oneMinute => 'एक मिनट';

  @override
  String get oneWeekOverdue => 'एक हफ़्ते की देरी';

  @override
  String get overdueFollowUps => 'पेंडिंग बिल के लिए याद दिलाएं';

  @override
  String get paymentNotifications => 'पेमेंट के नोटिफ़िकेशन';

  @override
  String get paymentReceived => 'पेमेंट मिल गया';

  @override
  String get paymentReceivedSubtitle =>
      'पेमेंट मिलने पर कन्फर्मेशन मैसेज भेजें';

  @override
  String get permissionDenied => 'इजाज़त नहीं मिली';

  @override
  String get profileUpdated => 'प्रोफ़ाइल अपडेट हो गई';

  @override
  String get quietHours => 'नोटिफ़िकेशन बंद रखने का समय (शांत घंटे)';

  @override
  String get rateHistory => 'पुरानी दरें';

  @override
  String get ratePerUnitLabel => 'प्रति यूनिट दर (₹ में)';

  @override
  String get rateUpdated => 'दर अपडेट हो गई है';

  @override
  String get receiptLabel => 'रसीद';

  @override
  String remindDaysBeforeCycleEnds(int days) {
    return 'महीना पूरा होने से $days दिन पहले याद दिलाएं';
  }

  @override
  String remindDaysBeforeDueDate(int days) {
    return 'आखिरी तारीख से $days दिन पहले याद दिलाएं';
  }

  @override
  String get reminderLabel => 'रिमाइंडर';

  @override
  String get reminderSettingsSubtitle => 'रिमाइंडर्स की सेटिंग्स';

  @override
  String get requireBiometric => 'फिंगरप्रिंट/फेस आईडी ज़रूरी है';

  @override
  String get resetBtn => 'रीसेट करें';

  @override
  String get resetTemplateWarning =>
      'क्या आप इस मैसेज को पहले जैसा (डिफ़ॉल्ट) करना चाहते हैं?';

  @override
  String get resetToDefault => 'पहले जैसा करें';

  @override
  String get restartNowBtn => 'अभी ऐप रीस्टार्ट करें';

  @override
  String get restoreBackupTitle => 'बैकअप रिस्टोर करें';

  @override
  String get restoreBackupWarning =>
      'यह आपके वर्तमान डेटा को पूरी तरह से बदल देगा। क्या आप वाकई जारी रखना चाहते हैं?';

  @override
  String get restoreBtn => 'रिस्टोर करें';

  @override
  String get restoreFailedPrefix => 'रिस्टोर विफल';

  @override
  String get restoreFromDevice => 'बैकअप रिस्टोर करें';

  @override
  String get restoreFromDeviceSubtitle => 'अपने फ़ोन से मौजूदा बैकअप लोड करें';

  @override
  String get restoreSuccessTitle => 'रिस्टोर सफल';

  @override
  String get saveDataToFile => 'अपने डेटाबेस को ज़िप फ़ाइल में सेव करें';

  @override
  String get saveProfile => 'प्रोफ़ाइल सेव करें';

  @override
  String get secondReminder => 'दूसरा रिमाइंडर';

  @override
  String get sendTestNotification => 'एक टेस्ट नोटिफ़िकेशन भेजें';

  @override
  String get setNewRate => 'नई दर सेट करें';

  @override
  String get setupFingerprintFirst =>
      'कृपया पहले फ़ोन की सेटिंग्स में फिंगरप्रिंट सेट करें';

  @override
  String get template => 'संदेश का टेम्पलेट';

  @override
  String get templateAlreadyDefault =>
      'यह संदेश पहले से ही डिफ़ॉल्ट रूप में है';

  @override
  String get templatePlaceholders =>
      'आप संदेश में इन शब्दों का इस्तेमाल कर सकते हैं:';

  @override
  String get templateResetSuccess => 'मैसेज सफलतापूर्वक रीसेट हो गया';

  @override
  String get templateSavedSuccess => 'मैसेज सफलतापूर्वक सेव हो गया';

  @override
  String templateUsedWhenSharing(String type) {
    return '$type भेजते समय यही मैसेज जाएगा';
  }

  @override
  String get testNotificationTitle => 'टेस्ट नोटिफ़िकेशन';

  @override
  String get threeDaysOverdue => 'तीन दिन की देरी';

  @override
  String get twoWeeksOverdue => 'दो हफ़्ते की देरी';

  @override
  String get unit => 'यूनिट';

  @override
  String get updateRate => 'दर अपडेट करें';

  @override
  String get upiId => 'UPI आईडी';

  @override
  String get upiIdHelperText =>
      'किरायेदारों से सीधे खाते में पेमेंट पाने के लिए अपनी UPI आईडी डालें';

  @override
  String get upiIdHint => 'उदा. yourname@upi';

  @override
  String versionLabel(String version) {
    return 'वर्ज़न $version';
  }

  @override
  String get weeklyReminder => 'हर हफ़्ते याद दिलाएं';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get documentPdf => 'document.pdf';

  @override
  String errorSharingMessage(String error) {
    return 'मैसेज भेजने में कोई परेशानी हुई: $error';
  }

  @override
  String get downloadsFolder => 'Downloads';

  @override
  String get savedToDownloads => 'डाउनलोड में सहेजा गया';

  @override
  String savedToFolder(String folderName) {
    return '$folderName में सहेजा गया';
  }

  @override
  String get couldNotSavePdf =>
      'पीडीएफ़ सेव नहीं हो सका। कृपया दोबारा कोशिश करें।';

  @override
  String get unableToLoadPdfPreview => 'पीडीएफ़ का प्रीव्यू नहीं दिख रहा है';

  @override
  String get shareReceipt => 'रसीद भेजें';

  @override
  String get chooseHowToShare => 'चुनें कि आप रसीद कैसे भेजना चाहते हैं';

  @override
  String get sendAsMessage => 'SMS या WhatsApp से भेजें';

  @override
  String get quickTextWithDetails => 'छोटे मैसेज के रूप में';

  @override
  String get sharePdf => 'पीडीएफ़ भेजें';

  @override
  String get formalDocument => 'पीडीएफ़ दस्तावेज़ के रूप में';

  @override
  String errorGeneratingPdf(String error) {
    return 'पीडीएफ़ बनाने में परेशानी हुई: $error';
  }

  @override
  String get paymentReceipt => 'भुगतान की रसीद';

  @override
  String get notificationPermissionTitle => 'भुगतान कभी न भूलें';

  @override
  String get notificationPermissionBody =>
      'कभी भी भुगतान न भूलें! क्या आप चाहते हैं कि किराया देय होने पर हम आपको याद दिलाएं?';

  @override
  String get biometricPermissionTitle => 'लेज़र सुरक्षित रखें';

  @override
  String get biometricPermissionBody =>
      'अपने लेज़र को सुरक्षित रखें। क्या आप फिंगरप्रिंट के साथ रेंटखाता को लॉक करना चाहते हैं?';

  @override
  String get yesBtn => 'हाँ';

  @override
  String get noBtn => 'नहीं';

  @override
  String get notNowBtn => 'अभी नहीं';

  @override
  String get systemNotificationsDisabledTitle => 'सिस्टम सूचनाएं अक्षम हैं';

  @override
  String get systemNotificationsDisabledBody =>
      'किराया अलर्ट और भुगतान अनुस्मारक प्राप्त करने के लिए अनुमतियां सक्षम करें।';

  @override
  String get enableBtn => 'सक्षम करें';

  @override
  String get appLockEnabledSuccess => 'ऐप लॉक सफलतापूर्वक सक्षम किया गया!';

  @override
  String get appLockSetupFailed => 'ऐप लॉक सत्यापन विफल रहा।';

  @override
  String get smartAlerts => 'स्मार्ट अलर्ट';

  @override
  String get agreementExpiredAlert => 'अनुबंध पहले ही समाप्त हो चुका है';

  @override
  String agreementExpiredAlertSubtitle(int days) {
    return 'अनुबंध की समाप्ति तिथि के $days दिन बाद याद दिलाएं';
  }

  @override
  String get billNotGeneratedAlert => 'बिल जनरेट नहीं होने का अनुस्मारक';

  @override
  String billNotGeneratedAlertSubtitle(int days) {
    return 'चक्र अतिदेय होने पर या समाप्त होने के $days दिनों के भीतर अलर्ट करें';
  }

  @override
  String get partialPaymentPauseAlert =>
      'आंशिक भुगतान के बाद अतिदेय अनुवर्ती कार्रवाई रोकें';

  @override
  String get partialPaymentPauseAlertSubtitle =>
      'भुगतान की गई राशि 50% तक पहुँचने पर रिमाइंडर्स रोकें';

  @override
  String get depositSettlementAlert => 'निकासी के बाद सुरक्षा जमा निपटान देय';

  @override
  String depositSettlementAlertSubtitle(int days) {
    return 'निपटान लंबित होने पर $days दिन बाद याद दिलाएं';
  }

  @override
  String get depositStatus => 'जमा स्थिति';

  @override
  String get settledStatusCap => 'निपटाया गया';

  @override
  String get manualDeductions => 'अन्य कटौतियां';

  @override
  String get finalRefund => 'अंतिम वापसी';

  @override
  String get amountOwed => 'बकाया राशि';

  @override
  String get manualDeductionReason => 'कटौती का कारण';

  @override
  String get utilityAnomalyAlert => 'असामान्य उच्च उपयोगिता खपत';

  @override
  String get utilityAnomalyAlertSubtitle =>
      'नवीनतम बिजली उपयोग में तीव्र वृद्धि होने पर सचेत करें';

  @override
  String get sameAsMoveIn => 'प्रवेश के समान';

  @override
  String get selectBillToCollect =>
      'समीक्षा और भुगतान लेने के लिए नीचे से एक बिल चुनें।';

  @override
  String overdueSinceDate(String date) {
    return '$date से अतिदेय';
  }

  @override
  String get awaitingPayment => 'भुगतान की प्रतीक्षा';

  @override
  String get unknownTenant => 'अज्ञात किरायेदार';

  @override
  String get unknownRoom => 'अज्ञात कमरा';

  @override
  String get collectLabel => 'संग्रह करें';

  @override
  String get pdfReceivedFrom => 'प्राप्तकर्ता';

  @override
  String get pdfInvoiceTitle => 'इनवॉइस';

  @override
  String get pdfReceiptTitle => 'रसीद';

  @override
  String get pdfBalanceDue => 'बकाया राशि';

  @override
  String get pdfBillTo => 'बिल किसे';

  @override
  String get pdfRoom => 'कमरा';

  @override
  String get pdfIssued => 'जारी किया गया';

  @override
  String get pdfDueDate => 'देय तिथि';

  @override
  String get pdfDescription => 'विवरण';

  @override
  String get pdfPeriod => 'अवधि';

  @override
  String get pdfAmount => 'राशि';

  @override
  String get pdfTotalAmount => 'कुल राशि';

  @override
  String get pdfAmountPaid => 'भुगतान की गई राशि';

  @override
  String get pdfPaymentHistory => 'भुगतान इतिहास';

  @override
  String get pdfDate => 'दिनांक';

  @override
  String get pdfMode => 'माध्यम';

  @override
  String get pdfPaymentDetails => 'भुगतान विवरण';

  @override
  String get pdfTotalBill => 'कुल बिल';

  @override
  String get pdfTotalPaid => 'कुल भुगतान';

  @override
  String get pdfRemaining => 'शेष';

  @override
  String get pdfStatusFullyPaid => 'स्थिति: पूर्ण भुगतान ✅';

  @override
  String get pdfUpiId => 'UPI आईडी';

  @override
  String get pdfScanToPay => 'भुगतान के लिए स्कैन करें';

  @override
  String get pdfTermsAndConditions => 'नियम और शर्तें';

  @override
  String get pdfTerm1 =>
      '1. विलंब शुल्क से बचने के लिए कृपया देय तिथि से पहले बिल का भुगतान करें।';

  @override
  String get pdfTerm2 =>
      '2. यह एक कंप्यूटर-जनरेटेड इनवॉइस है और जब तक निर्दिष्ट न हो, किसी हस्ताक्षर की आवश्यकता नहीं है।';

  @override
  String get pdfVoid => 'रद्द';

  @override
  String get pdfPaid => 'भुगतान किया गया';

  @override
  String get shareStatementSubject => 'खाता विवरण';

  @override
  String shareStatementBody(String name) {
    return 'प्रिय $name,\n\nकृपया अपना जनरेट किया गया खाता विवरण संलग्न पाएं।';
  }

  @override
  String get shareSettlementSubject => 'मूव-आउट निपटान रसीद';

  @override
  String shareSettlementBody(String name) {
    return 'प्रिय $name,\n\nआपका मूव-आउट निपटान पूरा हो गया है। कृपया विस्तृत निपटान रसीद संलग्न पाएं।';
  }

  @override
  String shareInvoiceSubject(String period) {
    return 'इनवॉइस - $period';
  }

  @override
  String shareReceiptSubject(String period) {
    return 'भुगतान रसीद - $period';
  }

  @override
  String shareDear(String name) {
    return 'प्रिय $name,';
  }

  @override
  String get shareInvoiceHeader => '📋 *इनवॉइस*';

  @override
  String shareInvoiceNumber(String number) {
    return 'इनवॉइस #: $number';
  }

  @override
  String get shareBillDetails => '*बिल विवरण:*';

  @override
  String shareType(String type) {
    return 'प्रकार: $type';
  }

  @override
  String sharePeriod(String period) {
    return 'अवधि: $period';
  }

  @override
  String shareRoom(String room) {
    return 'कमरा: $room';
  }

  @override
  String get shareMeterReadings => '*मीटर रीडिंग:*';

  @override
  String sharePrevious(String reading) {
    return 'पिछला: $reading यूनिट';
  }

  @override
  String shareCurrent(String reading) {
    return 'वर्तमान: $reading यूनिट';
  }

  @override
  String shareUnitsUsed(String units) {
    return 'खपत: $units यूनिट';
  }

  @override
  String shareRate(String rate) {
    return 'दर: ₹$rate/यूनिट';
  }

  @override
  String get shareAmountHeader => '*राशि:*';

  @override
  String shareTotal(String amount) {
    return 'कुल: ₹$amount';
  }

  @override
  String sharePaid(String amount) {
    return 'भुगतान: ₹$amount';
  }

  @override
  String sharePending(String amount) {
    return '*बकाया: ₹$amount*';
  }

  @override
  String shareDueDate(String date) {
    return 'देय तिथि: $date';
  }

  @override
  String get sharePayViaUpi => '📱 *UPI द्वारा भुगतान करें:*';

  @override
  String get shareThankYou => 'धन्यवाद,';

  @override
  String get sharePaymentReceived => '✅ *भुगतान प्राप्त*';

  @override
  String get sharePaymentDetails => '*भुगतान विवरण:*';

  @override
  String shareAmount(String amount) {
    return 'राशि: ₹$amount';
  }

  @override
  String shareMode(String mode) {
    return 'माध्यम: $mode';
  }

  @override
  String shareDate(String date) {
    return 'दिनांक: $date';
  }

  @override
  String get shareBillStatus => '*बिल स्थिति:*';

  @override
  String shareTotalBill(String amount) {
    return 'कुल बिल: ₹$amount';
  }

  @override
  String shareTotalPaid(String amount) {
    return 'कुल भुगतान: ₹$amount';
  }

  @override
  String shareRemaining(String amount) {
    return '*शेष: ₹$amount*';
  }

  @override
  String get shareStatusFullyPaid => '*स्थिति: पूर्ण भुगतान ✅*';

  @override
  String get shareThankYouPayment => 'आपके भुगतान के लिए धन्यवाद!';

  @override
  String get editRoomTitle => 'कमरा संपादित करें';

  @override
  String get addRoomTitle => 'कमरा जोड़ें';

  @override
  String get roomNumberLabel => 'कमरा नंबर/नाम *';

  @override
  String get roomNumberHint => 'उदा., 101, ग्राउंड फ्लोर बायां';

  @override
  String get monthlyRentHint => 'उदा., 5000';

  @override
  String get electricityMeterToggleTitle => 'बिजली मीटर';

  @override
  String get electricityMeterToggleSubtitle =>
      'मीटर रीडिंग ट्रैक करें और बिजली बिल अपने आप कैलकुलेट करें';

  @override
  String get saveChangesBtn => 'परिवर्तन सहेजें';

  @override
  String get roomUpdatedSuccess => 'कमरा अपडेट किया गया';

  @override
  String get roomAddedSuccess => 'कमरा जोड़ा गया';

  @override
  String get addExpenseTitle => 'खर्च जोड़ें';

  @override
  String get categoryLabel => 'श्रेणी';

  @override
  String get noteOptionalLabel => 'नोट (वैकल्पिक)';

  @override
  String get noteExpenseHint => 'उदा. पंप मरम्मत के पुर्जे';

  @override
  String get saveExpenseBtn => 'खर्च सेव करें';

  @override
  String get expenseAddedSuccess => 'खर्च सफलतापूर्वक जोड़ा गया';

  @override
  String get addDocumentTitle => 'दस्तावेज़ जोड़ें';

  @override
  String get documentTitleLabel => 'दस्तावेज़ का शीर्षक';

  @override
  String get documentTitleHint => 'उदा., किराया समझौता, पैन कार्ड';

  @override
  String get tapToAddDocument => 'दस्तावेज़ जोड़ने के लिए टैप करें';

  @override
  String get imageOrPdf => 'छवि या PDF';

  @override
  String get saveDocumentBtn => 'दस्तावेज़ सेव करें';

  @override
  String get selectPdf => 'PDF चुनें';

  @override
  String get selectDocumentError => 'कृपया एक दस्तावेज़ चुनें';

  @override
  String get skipForNowBtn => 'अभी छोड़ें';

  @override
  String get whatAreYouManaging => 'आप क्या प्रबंधित कर रहे हैं?';

  @override
  String get giveFirstPropertyTitle => 'अपनी पहली संपत्ति या इमारत को नाम दें।';

  @override
  String get propertyNameLabel => 'संपत्ति का नाम';

  @override
  String get propertyNameHint => 'उदा., ग्रीन वैली अपार्टमेंट्स';

  @override
  String get continueBtn => 'जारी रखें';

  @override
  String get yourProfileTitle => 'आपकी प्रोफ़ाइल';

  @override
  String get letsSetUpProfile =>
      'आइए आपकी प्रोफ़ाइल सेट अप करें ताकि आप संपत्तियों का प्रबंधन शुरू कर सकें।';

  @override
  String get profileBillingInfoText =>
      'इस जानकारी का उपयोग बिलिंग और रसीदों के लिए किया जाएगा।';

  @override
  String get profileUpiInfoText =>
      'आपकी UPI ID का उपयोग किरायेदारों द्वारा आसानी से किराया चुकाने के लिए QR कोड उत्पन्न करने में किया जाएगा।';

  @override
  String get yourNameLabel => 'आपका नाम *';

  @override
  String get enterFullNameHint => 'अपना पूरा नाम दर्ज करें';

  @override
  String get phoneNumberLabel => 'फ़ोन नंबर';

  @override
  String get phoneNumberHint => '10 अंकों का मोबाइल नंबर';

  @override
  String get upiIdLabel => 'UPI ID';

  @override
  String get configureBillingCyclesTitle => 'बिलिंग साइकिल कॉन्फ़िगर करें';

  @override
  String get calculateBillsTenantDateText =>
      'किरायेदार के विशिष्ट प्रवेश-तिथि के आधार पर बिल की गणना करें';

  @override
  String get saveAndContinueBtn => 'सहेजें और जारी रखें';

  @override
  String get notificationsEnabledSuccess => 'सूचनाएँ सफलतापूर्वक सक्षम की गईं!';

  @override
  String get notificationsDeniedError => 'सूचना की अनुमति अस्वीकार कर दी गई।';

  @override
  String get appLockNotConfiguredError => 'ऐप लॉक कॉन्फ़िगर नहीं किया गया था।';

  @override
  String get upiHelperText => 'किराया भुगतान प्राप्त करने के लिए';

  @override
  String get propertyNameRequiredLabel => 'संपत्ति का नाम *';

  @override
  String get propertySunriseHint => 'उदा., सनराइज अपार्टमेंट्स';

  @override
  String get propertyAddressLabel => 'पता';

  @override
  String get propertyAddressHint => 'संपत्ति का पूरा पता';

  @override
  String get noDocumentsAddedYet => 'अभी तक कोई दस्तावेज़ नहीं जोड़ा गया है।';

  @override
  String get noAvailableTenantsCreateNew =>
      'कोई किरायेदार उपलब्ध नहीं है। नया किरायेदार बनाएं।';

  @override
  String get moveInDetailsTitle => 'प्रवेश विवरण';

  @override
  String get olderMoveInDetectedInfo =>
      'पुराना प्रवेश पाया गया। बिलिंग इस महीने से शुरू होगी।';

  @override
  String get noFamilyMembersTap => 'कोई परिवार का सदस्य नहीं है। टैप करें';

  @override
  String get existingMembersLabel => 'मौजूदा सदस्य:';

  @override
  String get newMembersToAddLabel => 'जोड़ने के लिए नए सदस्य:';

  @override
  String get panCardHint => 'उदा. पैन कार्ड';

  @override
  String get nameRequiredLabel => 'नाम *';

  @override
  String get relationshipRequiredLabel => 'संबंध *';

  @override
  String get phoneOptionalLabel => 'फ़ोन';

  @override
  String get fullNameRequiredLabel => 'पूरा नाम *';

  @override
  String get guardianNameOptionalLabel => 'पिता/पति का नाम (वैकल्पिक)';

  @override
  String get twelveDigitNumberHint => '12 अंकों का नंबर';

  @override
  String get agreementEndDateOptionalLabel => 'अनुबंध समाप्ति तिथि (वैकल्पिक)';

  @override
  String get agreedRentLabel => 'सहमत किराया (₹)';

  @override
  String get manualDeductionAmountLabel => 'मैन्युअल कटौती राशि (₹)';

  @override
  String get deductionReasonHint => 'कारण (उदा. नुकसान, पेंटिंग)';

  @override
  String get moveInDateInputLabel => 'प्रवेश तिथि';

  @override
  String get propertyUpdatedSuccess => 'संपत्ति अद्यतन की गई';

  @override
  String get propertyAddedSuccess => 'संपत्ति जोड़ी गई';

  @override
  String get editPropertyTitle => 'संपत्ति संपादित करें';

  @override
  String get addPropertyTitle => 'संपत्ति जोड़ें';

  @override
  String get aadhaarCardPhotosLabel => 'आधार कार्ड की तस्वीरें';

  @override
  String get policeVerifiedLabel => 'पुलिस सत्यापित';

  @override
  String get policeVerifiedSubtitle =>
      'यदि पुलिस सत्यापन पूरा हो गया है तो चिह्नित करें';

  @override
  String get profilePhotoLabel => 'प्रोफ़ाइल फ़ोटो';

  @override
  String get enterTenantFullNameHint => 'किरायेदार का पूरा नाम दर्ज करें';

  @override
  String get fathersNameRequiredHint => 'कानूनी अनुबंधों के लिए आवश्यक';

  @override
  String get tenDigitMobileHint => '10 अंकों का मोबाइल नंबर';

  @override
  String get secondaryPhoneLabel => 'वैकल्पिक फ़ोन';

  @override
  String get emergencyFamilyContactHint => 'आपातकालीन/पारिवारिक संपर्क';

  @override
  String get addressLineLabel => 'पता';

  @override
  String get streetLocalityHint => 'सड़क, मोहल्ला';

  @override
  String get companyNameLabel => 'कंपनी का नाम';

  @override
  String get officeAddressLabel => 'कार्यालय का पता';

  @override
  String get aadhaarNumberLabel => 'आधार संख्या';

  @override
  String get twelveDigitAadhaarHint => '12 अंकों का आधार नंबर';

  @override
  String get introducerNameLabel => 'परिचयकर्ता का नाम';

  @override
  String get vouchedForTenantHint => 'किरायेदार की गारंटी देने वाला व्यक्ति';

  @override
  String get introducerAddressLabel => 'परिचयकर्ता का पता';

  @override
  String get introducerPhoneLabel => 'परिचयकर्ता का फ़ोन';

  @override
  String get identityContactTitle => 'पहचान और संपर्क';

  @override
  String get permanentAddressTitle => 'स्थायी पता';

  @override
  String get workDetailsTitle => 'काम का विवरण';

  @override
  String get idDocumentsTitle => 'पहचान दस्तावेज़';

  @override
  String get introducerReferenceTitle => 'परिचयकर्ता / संदर्भ';

  @override
  String get additionalDocumentsTitle => 'अतिरिक्त दस्तावेज़';

  @override
  String get otherLabel => 'अन्य';

  @override
  String get editTenantTitle => 'किरायेदार संपादित करें';

  @override
  String get addTenantTitle => 'किरायेदार जोड़ें';

  @override
  String get tenantUpdatedSuccess => 'किरायेदार अद्यतन किया गया';

  @override
  String get tenantAddedSuccess => 'किरायेदार जोड़ा गया';

  @override
  String get tenantDeletedSuccess => 'किरायेदार हटा दिया गया';

  @override
  String get cancelBtn => 'रद्द करें';

  @override
  String get moveInAgainBtn => 'फिर से प्रवेश करें';

  @override
  String get selectRoomToMoveInHint =>
      'इस किरायेदार को प्रवेश देने के लिए एक कमरा चुनें';

  @override
  String get deleteTenantTitle => 'किरायेदार हटाएं?';

  @override
  String get deleteBtn => 'हटाएं';

  @override
  String get currentLocationLabel => 'वर्तमान स्थान';

  @override
  String get unableToLoadImage => 'छवि लोड करने में असमर्थ';

  @override
  String get imageFileNotFound => 'छवि फ़ाइल नहीं मिली';

  @override
  String get occupancyHistoryTitle => 'अधिभोग इतिहास';

  @override
  String get noOccupancyHistoryYet => 'अभी तक कोई अधिभोग इतिहास नहीं है';

  @override
  String get familyMembersTitle => 'परिवार के सदस्य';

  @override
  String get addFamilyMemberTitle => 'परिवार का सदस्य जोड़ें';

  @override
  String get familyMembersActiveOnlyHint =>
      'परिवार के सदस्य केवल सक्रिय अधिभोग में जोड़े जा सकते हैं';

  @override
  String get deleteFamilyMemberTitle => 'परिवार के सदस्य को हटाएं?';

  @override
  String get actionCannotBeUndone =>
      'इस क्रिया को पूर्ववत नहीं किया जा सकता है।';

  @override
  String get familyMemberDeletedSuccess => 'परिवार का सदस्य हटा दिया गया';

  @override
  String get spouseLabel => 'पति/पत्नी';

  @override
  String get childLabel => 'बच्चा';

  @override
  String get parentLabel => 'माता-पिता';

  @override
  String get siblingLabel => 'भाई/बहन';

  @override
  String get nameAndRelationshipRequired => 'नाम और संबंध आवश्यक हैं';

  @override
  String get familyMemberAddedSuccess => 'परिवार का सदस्य जोड़ा गया!';

  @override
  String get customFieldsTitle => 'कस्टम फ़ील्ड';

  @override
  String get noCustomFields => 'कोई कस्टम फ़ील्ड नहीं';

  @override
  String get documentsTitle => 'दस्तावेज़';

  @override
  String get noDocumentsAttached => 'कोई दस्तावेज़ संलग्न नहीं है।';

  @override
  String get deleteDocumentTitle => 'दस्तावेज़ हटाएं?';

  @override
  String get confirmDeleteDocumentPrefix => 'क्या आप वाकई हटाना चाहते हैं ';

  @override
  String get documentDeletedSuccess => 'दस्तावेज़ हटा दिया गया';

  @override
  String get fieldNameLabel => 'फ़ील्ड का नाम';

  @override
  String get fieldValueLabel => 'मूल्य';

  @override
  String get zeroAmount => '0';

  @override
  String get letsMakeItProfessionalTitle => 'आइए इसे पेशेवर बनाएं!';

  @override
  String get addNameUpiSubtitle =>
      'अपने किरायेदारों को पेशेवर रसीदें जारी करने के लिए अपना बिलिंग प्रोफ़ाइल सेट करें।';

  @override
  String get continueToBillBtn => 'बिल पर जारी रखें';

  @override
  String get yourNameBusinessNameLabel => 'आपका नाम या व्यवसाय का नाम';

  @override
  String get upiIdOptionalLabel => 'यूपीआई आईडी';

  @override
  String get upiInvoiceHelperText =>
      'आपके इनवॉइस में एक स्कैन करने योग्य क्यूआर कोड जोड़ता है, जिससे किरायेदारों के लिए आपको सीधे भुगतान करना 3 गुना तेज़ हो जाता है।';

  @override
  String get occupancyDetailsTitle => 'अधिभोग विवरण';

  @override
  String get shareFunctionalityComingSoon =>
      'साझा करने की कार्यक्षमता जल्द आ रही है';

  @override
  String get occupancyNotFound => 'अधिभोग नहीं मिला';

  @override
  String get viewSettlementReceiptBtn => 'निपटान रसीद देखें';

  @override
  String get enterPaymentAmountLabel => 'भुगतान राशि (₹)';

  @override
  String get shareTextBtn => 'टेक्स्ट साझा करें';

  @override
  String get pdfInvoiceBtn => 'PDF चालान';

  @override
  String get messageCopiedSuccess => 'संदेश क्लिपबोर्ड पर कॉपी किया गया!';

  @override
  String get generatingPdfMsg => 'PDF जेनरेट किया जा रहा है...';

  @override
  String get noPaymentsRecordedMsg => 'अभी तक कोई भुगतान दर्ज नहीं है';

  @override
  String get paymentDeletedSuccess => 'भुगतान हटा दिया गया';

  @override
  String get enterValidAmountMsg => 'एक वैध राशि दर्ज करें';

  @override
  String get paymentUpdatedSuccess => 'भुगतान अद्यतन किया गया';

  @override
  String get noNotificationsScheduled => 'कोई सूचना निर्धारित नहीं है।';

  @override
  String get errorGeneric => 'त्रुटि';

  @override
  String get chooseFromGalleryBtn => 'गैलरी से चुनें';

  @override
  String get sharePaymentLinkBtn => 'भुगतान लिंक साझा करें';

  @override
  String get meterTrackingExplanation =>
      'अपनी निर्धारित दर के आधार पर बिजली शुल्क की स्वचालित गणना करने के लिए रीडिंग दर्ज करें।';

  @override
  String get archiveProperty => 'प्रॉपर्टी आर्काइव करें';

  @override
  String get unarchiveProperty => 'प्रॉपर्टी अन-आर्काइव करें';

  @override
  String get archiveRoom => 'कमरा आर्काइव करें';

  @override
  String get unarchiveRoom => 'कमरा अन-आर्काइव करें';

  @override
  String get archiveTenant => 'किरायेदार आर्काइव करें';

  @override
  String get unarchiveTenant => 'किरायेदार अन-आर्काइव करें';

  @override
  String get showArchived => 'आर्काइव दिखाएं';

  @override
  String get hideArchived => 'आर्काइव छिपाएं';

  @override
  String get archivedBadge => 'आर्काइव्ड';

  @override
  String get validatePhoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get validatePhoneInvalid => 'एक मान्य 10-अंकीय फ़ोन नंबर दर्ज करें';

  @override
  String get validateUpiInvalid => 'एक मान्य UPI ID दर्ज करें (उदा. name@upi)';

  @override
  String get validateAadharInvalid => 'एक मान्य 12-अंकीय आधार नंबर दर्ज करें';

  @override
  String validateRequiredField(String fieldName) {
    return '$fieldName आवश्यक है';
  }

  @override
  String get validatePositiveNumberInvalid =>
      'एक मान्य धनात्मक संख्या दर्ज करें';

  @override
  String get showLess => 'कम दिखाएं';

  @override
  String get viewHistory => 'इतिहास देखें';

  @override
  String get activeStatus => 'सक्रिय';

  @override
  String get pastStayStatus => 'पुराना निवास';

  @override
  String billsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count बिल',
      one: '1 बिल',
    );
    return '$_temp0';
  }

  @override
  String get netProfit => 'शुद्ध लाभ';

  @override
  String get netLoss => 'शुद्ध हानि';

  @override
  String get statusPaid => 'भुगतान किया';

  @override
  String get statusOverdue => 'बकाया';

  @override
  String get amountSettled => 'राशि का निपटान';

  @override
  String get amountDue => 'देय राशि';

  @override
  String expiredDaysAgo(int days) {
    return '$days दिन पहले समाप्त हो गया';
  }

  @override
  String expiringInDays(int days) {
    return '$days दिनों में समाप्त हो रहा है';
  }

  @override
  String get fieldRequired => 'आवश्यक';

  @override
  String get financialYearPrefix => 'वि.व. ';
}
