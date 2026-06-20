import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'RentKhata'**
  String get appTitle;

  /// No description provided for @reviewTitleBill.
  ///
  /// In en, this message translates to:
  /// **'Bill Generated Successfully! 🎉'**
  String get reviewTitleBill;

  /// No description provided for @reviewTitlePayment.
  ///
  /// In en, this message translates to:
  /// **'Payment Recorded! 💸'**
  String get reviewTitlePayment;

  /// No description provided for @reviewTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Enjoying RentKhata?'**
  String get reviewTitleDefault;

  /// No description provided for @reviewSubtitleBillPayment.
  ///
  /// In en, this message translates to:
  /// **'I\'m a **solo developer** working **nights and weekends** to make managing your properties easier.\n\nIf RentKhata just saved you 5 minutes of work today, leaving a **5-star review** is the best way you can pay me back!'**
  String get reviewSubtitleBillPayment;

  /// No description provided for @reviewSubtitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m an **independent developer** building this app single-handedly.\n\nYour **5-star review** means the world to me and helps keep the app alive and improving!'**
  String get reviewSubtitleDefault;

  /// No description provided for @reviewRateButton.
  ///
  /// In en, this message translates to:
  /// **'Rate 5 Stars'**
  String get reviewRateButton;

  /// No description provided for @reviewTakes5s.
  ///
  /// In en, this message translates to:
  /// **'Takes 5s '**
  String get reviewTakes5s;

  /// No description provided for @reviewSuggestionButton.
  ///
  /// In en, this message translates to:
  /// **'I have a suggestion'**
  String get reviewSuggestionButton;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Effortless Rent Management'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track tenants, bills, and payments in one beautifully secure, offline ledger.'**
  String get welcomeSubtitle;

  /// No description provided for @startOrganizing.
  ///
  /// In en, this message translates to:
  /// **'Start Organizing'**
  String get startOrganizing;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @setUpProfile.
  ///
  /// In en, this message translates to:
  /// **'Set up profile'**
  String get setUpProfile;

  /// No description provided for @byContinuingYouAgree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our '**
  String get byContinuingYouAgree;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @couldNotOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Could not open link: {error}'**
  String couldNotOpenLink(String error);

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// No description provided for @biometricAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get biometricAuthentication;

  /// No description provided for @billingAndCycles.
  ///
  /// In en, this message translates to:
  /// **'Billing & Cycles'**
  String get billingAndCycles;

  /// No description provided for @dateToDateBilling.
  ///
  /// In en, this message translates to:
  /// **'Date-to-Date Billing'**
  String get dateToDateBilling;

  /// No description provided for @configureBillingCycles.
  ///
  /// In en, this message translates to:
  /// **'Configure billing cycles and due dates'**
  String get configureBillingCycles;

  /// No description provided for @billing.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billing;

  /// No description provided for @electricityRates.
  ///
  /// In en, this message translates to:
  /// **'Electricity Rates'**
  String get electricityRates;

  /// No description provided for @viewAndUpdateElectricityRates.
  ///
  /// In en, this message translates to:
  /// **'View and update electricity rates'**
  String get viewAndUpdateElectricityRates;

  /// No description provided for @messageTemplates.
  ///
  /// In en, this message translates to:
  /// **'Message Templates'**
  String get messageTemplates;

  /// No description provided for @customizeInvoice.
  ///
  /// In en, this message translates to:
  /// **'Customize invoice and receipt messages'**
  String get customizeInvoice;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @reminderSettings.
  ///
  /// In en, this message translates to:
  /// **'Reminder Settings'**
  String get reminderSettings;

  /// No description provided for @dueDateAndOverdue.
  ///
  /// In en, this message translates to:
  /// **'Due date and overdue reminders'**
  String get dueDateAndOverdue;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// No description provided for @saveOrRestoreData.
  ///
  /// In en, this message translates to:
  /// **'Save or restore your data'**
  String get saveOrRestoreData;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutRentKhata.
  ///
  /// In en, this message translates to:
  /// **'About RentKhata'**
  String get aboutRentKhata;

  /// No description provided for @offlineFirstRentalApp.
  ///
  /// In en, this message translates to:
  /// **'Offline-first rental management app for Indian landlords.'**
  String get offlineFirstRentalApp;

  /// No description provided for @tapToAddUpiId.
  ///
  /// In en, this message translates to:
  /// **'Tap to add UPI ID'**
  String get tapToAddUpiId;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @attentionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Attention Needed'**
  String get attentionNeeded;

  /// No description provided for @livePropertyStatus.
  ///
  /// In en, this message translates to:
  /// **'Live Property Status'**
  String get livePropertyStatus;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add Property'**
  String get addProperty;

  /// No description provided for @addTenant.
  ///
  /// In en, this message translates to:
  /// **'Add Tenant'**
  String get addTenant;

  /// No description provided for @createBill.
  ///
  /// In en, this message translates to:
  /// **'Create Bill'**
  String get createBill;

  /// No description provided for @goToRoomToCreateBills.
  ///
  /// In en, this message translates to:
  /// **'Go to a room to create bills'**
  String get goToRoomToCreateBills;

  /// No description provided for @pendingInvoices.
  ///
  /// In en, this message translates to:
  /// **'Pending Invoices'**
  String get pendingInvoices;

  /// No description provided for @tenantsNeedBills.
  ///
  /// In en, this message translates to:
  /// **'{count} tenants need bills created'**
  String tenantsNeedBills(int count);

  /// No description provided for @collectPayments.
  ///
  /// In en, this message translates to:
  /// **'Collect Payments'**
  String get collectPayments;

  /// No description provided for @billsAwaitPayment.
  ///
  /// In en, this message translates to:
  /// **'{count} generated bills await payment'**
  String billsAwaitPayment(int count);

  /// No description provided for @renewAgreements.
  ///
  /// In en, this message translates to:
  /// **'Renew Agreements'**
  String get renewAgreements;

  /// No description provided for @agreementsExpiring.
  ///
  /// In en, this message translates to:
  /// **'{count} agreements expiring soon'**
  String agreementsExpiring(int count);

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// No description provided for @noBillingCyclesEnding.
  ///
  /// In en, this message translates to:
  /// **'No billing cycles ending soon'**
  String get noBillingCyclesEnding;

  /// No description provided for @noActiveRooms.
  ///
  /// In en, this message translates to:
  /// **'No active rooms found'**
  String get noActiveRooms;

  /// No description provided for @tenants.
  ///
  /// In en, this message translates to:
  /// **'Tenants'**
  String get tenants;

  /// No description provided for @searchByNameOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search by name or phone...'**
  String get searchByNameOrPhone;

  /// No description provided for @noTenantsYet.
  ///
  /// In en, this message translates to:
  /// **'No tenants yet'**
  String get noTenantsYet;

  /// No description provided for @noTenantsFound.
  ///
  /// In en, this message translates to:
  /// **'No tenants found'**
  String get noTenantsFound;

  /// No description provided for @tenantsAppearHereAfterMoveIn.
  ///
  /// In en, this message translates to:
  /// **'Tenants will appear here after you move them into a room'**
  String get tenantsAppearHereAfterMoveIn;

  /// No description provided for @tryDifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @property.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get property;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @tenantDetail.
  ///
  /// In en, this message translates to:
  /// **'Tenant Detail'**
  String get tenantDetail;

  /// No description provided for @tenantNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tenant not found'**
  String get tenantNotFound;

  /// No description provided for @deleteTenant.
  ///
  /// In en, this message translates to:
  /// **'Delete Tenant'**
  String get deleteTenant;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @fathersName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name'**
  String get fathersName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'{count} years'**
  String years(int count);

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @secondaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Secondary Phone'**
  String get secondaryPhone;

  /// No description provided for @aadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar'**
  String get aadhaar;

  /// No description provided for @permanentAddress.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get permanentAddress;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @cityState.
  ///
  /// In en, this message translates to:
  /// **'City, State'**
  String get cityState;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @workDetails.
  ///
  /// In en, this message translates to:
  /// **'Work Details'**
  String get workDetails;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @officeAddress.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddress;

  /// No description provided for @introducerReference.
  ///
  /// In en, this message translates to:
  /// **'Introducer / Reference'**
  String get introducerReference;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financialSummary;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'{count} urgent'**
  String urgent(int count);

  /// No description provided for @allOnTime.
  ///
  /// In en, this message translates to:
  /// **'All on time'**
  String get allOnTime;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String items(int count);

  /// No description provided for @errorLoadingBills.
  ///
  /// In en, this message translates to:
  /// **'Error loading bills'**
  String get errorLoadingBills;

  /// No description provided for @errorLoadingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Error loading expenses'**
  String get errorLoadingExpenses;

  /// No description provided for @errorLoadingFinancials.
  ///
  /// In en, this message translates to:
  /// **'Error loading financials'**
  String get errorLoadingFinancials;

  /// No description provided for @billsByType.
  ///
  /// In en, this message translates to:
  /// **'Bills by Type'**
  String get billsByType;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noPropertiesYet.
  ///
  /// In en, this message translates to:
  /// **'No properties yet'**
  String get noPropertiesYet;

  /// No description provided for @addYourFirstProperty.
  ///
  /// In en, this message translates to:
  /// **'Add your first property to get started'**
  String get addYourFirstProperty;

  /// No description provided for @roomsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} rooms'**
  String roomsCount(int count);

  /// No description provided for @occupiedPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% occupied'**
  String occupiedPercent(int percent);

  /// No description provided for @propertyNotFound.
  ///
  /// In en, this message translates to:
  /// **'Property not found'**
  String get propertyNotFound;

  /// No description provided for @deleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Delete Property'**
  String get deleteProperty;

  /// No description provided for @noRoomsYet.
  ///
  /// In en, this message translates to:
  /// **'No rooms yet'**
  String get noRoomsYet;

  /// No description provided for @addRoomsToStartManaging.
  ///
  /// In en, this message translates to:
  /// **'Add rooms to start managing tenants'**
  String get addRoomsToStartManaging;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get addRoom;

  /// No description provided for @deletePropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Property?'**
  String get deletePropertyTitle;

  /// No description provided for @confirmDeleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{propertyName}\"? This will also delete all rooms in this property.'**
  String confirmDeleteProperty(String propertyName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @propertyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Property deleted'**
  String get propertyDeleted;

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete Room'**
  String get deleteRoom;

  /// No description provided for @deleteRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Room?'**
  String get deleteRoomTitle;

  /// No description provided for @confirmDeleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete room \"{roomNumber}\"? This action cannot be undone.'**
  String confirmDeleteRoom(String roomNumber);

  /// No description provided for @roomDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room deleted'**
  String get roomDeletedSuccess;

  /// No description provided for @occupancyCount.
  ///
  /// In en, this message translates to:
  /// **'{count} occupied'**
  String occupancyCount(int count);

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room {number}'**
  String roomNumber(String number);

  /// No description provided for @vacant.
  ///
  /// In en, this message translates to:
  /// **'Vacant'**
  String get vacant;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @billDetails.
  ///
  /// In en, this message translates to:
  /// **'Bill Details'**
  String get billDetails;

  /// No description provided for @editBill.
  ///
  /// In en, this message translates to:
  /// **'Edit Bill'**
  String get editBill;

  /// No description provided for @deleteBill.
  ///
  /// In en, this message translates to:
  /// **'Delete Bill'**
  String get deleteBill;

  /// No description provided for @voidBill.
  ///
  /// In en, this message translates to:
  /// **'Void Bill'**
  String get voidBill;

  /// No description provided for @sendReminder.
  ///
  /// In en, this message translates to:
  /// **'Send Reminder'**
  String get sendReminder;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @noPaymentsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded'**
  String get noPaymentsRecorded;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @reviewAndSend.
  ///
  /// In en, this message translates to:
  /// **'Review & Send'**
  String get reviewAndSend;

  /// No description provided for @shareInvoice.
  ///
  /// In en, this message translates to:
  /// **'Share Invoice'**
  String get shareInvoice;

  /// No description provided for @payAmount.
  ///
  /// In en, this message translates to:
  /// **'Pay {amount}'**
  String payAmount(String amount);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @saveInvoicePdf.
  ///
  /// In en, this message translates to:
  /// **'Save Invoice PDF'**
  String get saveInvoicePdf;

  /// No description provided for @voidBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Void Bill?'**
  String get voidBillTitle;

  /// No description provided for @voidBillWarning.
  ///
  /// In en, this message translates to:
  /// **'This will mark the bill as void. This action cannot be undone.'**
  String get voidBillWarning;

  /// No description provided for @voidReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for voiding'**
  String get voidReasonLabel;

  /// No description provided for @voidReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Incorrect amount'**
  String get voidReasonHint;

  /// No description provided for @billMarkedVoid.
  ///
  /// In en, this message translates to:
  /// **'Bill marked as Void'**
  String get billMarkedVoid;

  /// No description provided for @deleteBillTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Bill?'**
  String get deleteBillTitle;

  /// No description provided for @confirmDeleteBill.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this {billType} bill for {period}?\n\nThis action cannot be undone.'**
  String confirmDeleteBill(String billType, String period);

  /// No description provided for @billDeleted.
  ///
  /// In en, this message translates to:
  /// **'Bill deleted'**
  String get billDeleted;

  /// No description provided for @errorDeletingBill.
  ///
  /// In en, this message translates to:
  /// **'Error deleting bill: {error}'**
  String errorDeletingBill(String error);

  /// No description provided for @overdueU.
  ///
  /// In en, this message translates to:
  /// **'OVERDUE'**
  String get overdueU;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingTitle;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'DRAFT'**
  String get draft;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @partiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get partiallyPaid;

  /// No description provided for @overdueBill.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdueBill;

  /// No description provided for @voided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get voided;

  /// No description provided for @billNumber.
  ///
  /// In en, this message translates to:
  /// **'Bill Number'**
  String get billNumber;

  /// No description provided for @notAssigned.
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get notAssigned;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @billingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Billing Period'**
  String get billingPeriod;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @monthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly Rent'**
  String get monthlyRent;

  /// No description provided for @electricityBill.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill'**
  String get electricityBill;

  /// No description provided for @waterBill.
  ///
  /// In en, this message translates to:
  /// **'Water Bill'**
  String get waterBill;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @otherCharges.
  ///
  /// In en, this message translates to:
  /// **'Other Charges'**
  String get otherCharges;

  /// No description provided for @electricityDetails.
  ///
  /// In en, this message translates to:
  /// **'Electricity Details'**
  String get electricityDetails;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @meterPhoto.
  ///
  /// In en, this message translates to:
  /// **'Meter Photo'**
  String get meterPhoto;

  /// No description provided for @tapToViewFullSize.
  ///
  /// In en, this message translates to:
  /// **'Tap to view full size'**
  String get tapToViewFullSize;

  /// No description provided for @addMeterPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Meter Photo'**
  String get addMeterPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @meterPhotoAdded.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get meterPhotoAdded;

  /// No description provided for @errorAddingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Error adding photo: {error}'**
  String errorAddingPhoto(String error);

  /// No description provided for @editPayment.
  ///
  /// In en, this message translates to:
  /// **'Edit Payment'**
  String get editPayment;

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment'**
  String get deletePayment;

  /// No description provided for @deletePaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment?'**
  String get deletePaymentTitle;

  /// No description provided for @confirmDeletePayment.
  ///
  /// In en, this message translates to:
  /// **'Delete payment of {amount} made on {date}?\n\nThis will update the bill balance.'**
  String confirmDeletePayment(String amount, String date);

  /// No description provided for @paymentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Payment deleted'**
  String get paymentDeleted;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @cheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get cheque;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @auditHistory.
  ///
  /// In en, this message translates to:
  /// **'Audit History'**
  String get auditHistory;

  /// No description provided for @noChangesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No changes recorded'**
  String get noChangesRecorded;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @billAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Bill Already Exists'**
  String get billAlreadyExists;

  /// No description provided for @duplicateBillMessage.
  ///
  /// In en, this message translates to:
  /// **'A {type} bill for {month} {year} already exists ({number}).\n\nDo you want to create another bill anyway?'**
  String duplicateBillMessage(
    String type,
    String month,
    int year,
    String number,
  );

  /// No description provided for @createAnyway.
  ///
  /// In en, this message translates to:
  /// **'Create Anyway'**
  String get createAnyway;

  /// No description provided for @billCreated.
  ///
  /// In en, this message translates to:
  /// **'Bill created'**
  String get billCreated;

  /// No description provided for @billCreatedWithRate.
  ///
  /// In en, this message translates to:
  /// **'Bill created. Global rate updated to ₹{rate}/unit'**
  String billCreatedWithRate(String rate);

  /// No description provided for @meterReadings.
  ///
  /// In en, this message translates to:
  /// **'Meter Readings'**
  String get meterReadings;

  /// No description provided for @currentReading.
  ///
  /// In en, this message translates to:
  /// **'Current reading'**
  String get currentReading;

  /// No description provided for @ratePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Rate per unit:'**
  String get ratePerUnit;

  /// No description provided for @electricityCalculation.
  ///
  /// In en, this message translates to:
  /// **'Electricity Calculation'**
  String get electricityCalculation;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @unitsCalculation.
  ///
  /// In en, this message translates to:
  /// **'{units} units × {rate}'**
  String unitsCalculation(String units, String rate);

  /// No description provided for @optionalVerification.
  ///
  /// In en, this message translates to:
  /// **'Optional - helps with verification'**
  String get optionalVerification;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @billAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill Amount (₹) *'**
  String get billAmountLabel;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @dateToDate.
  ///
  /// In en, this message translates to:
  /// **'Date-to-Date'**
  String get dateToDate;

  /// No description provided for @advance.
  ///
  /// In en, this message translates to:
  /// **'Advance'**
  String get advance;

  /// No description provided for @currentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentLabel;

  /// No description provided for @cycleExceedsAgreementWarning.
  ///
  /// In en, this message translates to:
  /// **'This cycle exceeds the agreement end date ({date})'**
  String cycleExceedsAgreementWarning(String date);

  /// No description provided for @amountCannotBeLessThanPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot be less than paid amount of {amount}'**
  String amountCannotBeLessThanPaid(String amount);

  /// No description provided for @billUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Bill updated successfully'**
  String get billUpdatedSuccessfully;

  /// No description provided for @partiallyPaidBillWarning.
  ///
  /// In en, this message translates to:
  /// **'This bill has received payments. Amount can only be increased. It cannot be less than paid amount.'**
  String get partiallyPaidBillWarning;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid: {amount}'**
  String paidAmount(String amount);

  /// No description provided for @minAmount.
  ///
  /// In en, this message translates to:
  /// **'Min amount: {amount}'**
  String minAmount(String amount);

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountCannotExceedPendingBalance.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed pending balance of {amount}'**
  String amountCannotExceedPendingBalance(String amount);

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @dueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due: {amount}'**
  String dueAmount(String amount);

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @payFullDue.
  ///
  /// In en, this message translates to:
  /// **'Pay Full Due'**
  String get payFullDue;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add note (optional)'**
  String get addNoteOptional;

  /// No description provided for @paymentComplete.
  ///
  /// In en, this message translates to:
  /// **'Payment Complete!'**
  String get paymentComplete;

  /// No description provided for @paymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment Recorded'**
  String get paymentRecorded;

  /// No description provided for @billFullyPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill has been fully paid'**
  String get billFullyPaidLabel;

  /// No description provided for @partialPaymentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Partial payment recorded'**
  String get partialPaymentRecorded;

  /// No description provided for @invoiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoiceLabel;

  /// No description provided for @periodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get periodLabel;

  /// No description provided for @roomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get roomLabel;

  /// No description provided for @paymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmountLabel;

  /// No description provided for @paymentModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get paymentModeLabel;

  /// No description provided for @billTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill Total'**
  String get billTotalLabel;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidLabel;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeLabel;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @amountCannotExceedMax.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed {amount}'**
  String amountCannotExceedMax(String amount);

  /// No description provided for @paymentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Payment updated'**
  String get paymentUpdated;

  /// No description provided for @originalAmount.
  ///
  /// In en, this message translates to:
  /// **'Original: {amount}'**
  String originalAmount(String amount);

  /// No description provided for @paymentAmountRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount (₹) *'**
  String get paymentAmountRequiredLabel;

  /// No description provided for @paymentDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDateLabel;

  /// No description provided for @notesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptionalLabel;

  /// No description provided for @updatePayment.
  ///
  /// In en, this message translates to:
  /// **'Update Payment'**
  String get updatePayment;

  /// No description provided for @invoicePreview.
  ///
  /// In en, this message translates to:
  /// **'Invoice Preview'**
  String get invoicePreview;

  /// No description provided for @viewPdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get viewPdf;

  /// No description provided for @errorPreviewingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error previewing PDF: {error}'**
  String errorPreviewingPdf(String error);

  /// No description provided for @errorSharingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error sharing PDF: {error}'**
  String errorSharingPdf(String error);

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice {number}'**
  String invoiceNumber(String number);

  /// No description provided for @invoiceAttachmentMeterProof.
  ///
  /// In en, this message translates to:
  /// **'ATTACHMENT: METER READING PROOF'**
  String get invoiceAttachmentMeterProof;

  /// No description provided for @invoiceReference.
  ///
  /// In en, this message translates to:
  /// **'Invoice Reference: #{number}'**
  String invoiceReference(String number);

  /// No description provided for @invoiceReadings.
  ///
  /// In en, this message translates to:
  /// **'Readings: {prev} - {curr}'**
  String invoiceReadings(String prev, String curr);

  /// No description provided for @invoiceConsumption.
  ///
  /// In en, this message translates to:
  /// **'Consumption: {units} units @ Rs. {rate}'**
  String invoiceConsumption(String units, String rate);

  /// No description provided for @invoiceUpiTerms.
  ///
  /// In en, this message translates to:
  /// **'3. Make payments via UPI to the details mentioned above.'**
  String get invoiceUpiTerms;

  /// No description provided for @debugViewScheduledNotifications.
  ///
  /// In en, this message translates to:
  /// **'View Scheduled Notifications (Debug)'**
  String get debugViewScheduledNotifications;

  /// No description provided for @billTo.
  ///
  /// In en, this message translates to:
  /// **'Bill To'**
  String get billTo;

  /// No description provided for @unitsAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} units'**
  String unitsAmount(String amount);

  /// No description provided for @unitsConsumedRate.
  ///
  /// In en, this message translates to:
  /// **'{units} units @ {rate}/unit'**
  String unitsConsumedRate(String units, String rate);

  /// No description provided for @scanToPay.
  ///
  /// In en, this message translates to:
  /// **'Scan to Pay'**
  String get scanToPay;

  /// No description provided for @generatedOn.
  ///
  /// In en, this message translates to:
  /// **'Generated on: {date}'**
  String generatedOn(String date);

  /// No description provided for @sentStatus.
  ///
  /// In en, this message translates to:
  /// **'SENT'**
  String get sentStatus;

  /// No description provided for @partialStatus.
  ///
  /// In en, this message translates to:
  /// **'PARTIAL'**
  String get partialStatus;

  /// No description provided for @paidStatus.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paidStatus;

  /// No description provided for @overdueStatus.
  ///
  /// In en, this message translates to:
  /// **'OVERDUE'**
  String get overdueStatus;

  /// No description provided for @voidedStatus.
  ///
  /// In en, this message translates to:
  /// **'VOIDED'**
  String get voidedStatus;

  /// No description provided for @landlord.
  ///
  /// In en, this message translates to:
  /// **'Landlord'**
  String get landlord;

  /// No description provided for @previousReading.
  ///
  /// In en, this message translates to:
  /// **'Previous Reading'**
  String get previousReading;

  /// No description provided for @unitsConsumed.
  ///
  /// In en, this message translates to:
  /// **'Units Consumed'**
  String get unitsConsumed;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @balanceDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get balanceDueLabel;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @invoiceSavedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Invoice saved to Downloads'**
  String get invoiceSavedToDownloads;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorSavingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error saving PDF: {error}'**
  String errorSavingPdf(String error);

  /// No description provided for @errorLoadingAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'Error loading audit logs: {error}'**
  String errorLoadingAuditLogs(String error);

  /// No description provided for @previousCycle.
  ///
  /// In en, this message translates to:
  /// **'Previous cycle'**
  String get previousCycle;

  /// No description provided for @nextCycle.
  ///
  /// In en, this message translates to:
  /// **'Next cycle'**
  String get nextCycle;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthLabel;

  /// No description provided for @yearLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearLabel;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @mayShort.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get mayShort;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @roomTitle.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get roomTitle;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFound;

  /// No description provided for @statementLabel.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get statementLabel;

  /// No description provided for @occupiedStatus.
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get occupiedStatus;

  /// No description provided for @moveOutBtn.
  ///
  /// In en, this message translates to:
  /// **'Move Out'**
  String get moveOutBtn;

  /// No description provided for @agreedRent.
  ///
  /// In en, this message translates to:
  /// **'Agreed Rent'**
  String get agreedRent;

  /// No description provided for @securityDepositLabel.
  ///
  /// In en, this message translates to:
  /// **'Security Deposit (₹)'**
  String get securityDepositLabel;

  /// No description provided for @billingStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Billing Start'**
  String get billingStartLabel;

  /// No description provided for @editBtn.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editBtn;

  /// No description provided for @selectBillingStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select Billing Start Date'**
  String get selectBillingStartDate;

  /// No description provided for @failedToUpdateBillingStart.
  ///
  /// In en, this message translates to:
  /// **'Failed to update billing start date'**
  String get failedToUpdateBillingStart;

  /// No description provided for @roomIsVacant.
  ///
  /// In en, this message translates to:
  /// **'Room is Vacant'**
  String get roomIsVacant;

  /// No description provided for @assignTenantToStartCollecting.
  ///
  /// In en, this message translates to:
  /// **'Assign a tenant to start collecting rent'**
  String get assignTenantToStartCollecting;

  /// No description provided for @moveInTenantBtn.
  ///
  /// In en, this message translates to:
  /// **'Move In Tenant'**
  String get moveInTenantBtn;

  /// No description provided for @noBillsYet.
  ///
  /// In en, this message translates to:
  /// **'No bills yet'**
  String get noBillsYet;

  /// No description provided for @activeBills.
  ///
  /// In en, this message translates to:
  /// **'Active Bills'**
  String get activeBills;

  /// No description provided for @paidCaps.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get paidCaps;

  /// No description provided for @dueCaps.
  ///
  /// In en, this message translates to:
  /// **'DUE'**
  String get dueCaps;

  /// No description provided for @voidLabel.
  ///
  /// In en, this message translates to:
  /// **'VOID'**
  String get voidLabel;

  /// No description provided for @remindBtn.
  ///
  /// In en, this message translates to:
  /// **'Remind'**
  String get remindBtn;

  /// No description provided for @payNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNowBtn;

  /// No description provided for @viewBtn.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewBtn;

  /// No description provided for @shareBtn.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareBtn;

  /// No description provided for @monthlyRentLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Rent (₹) *'**
  String get monthlyRentLabel;

  /// No description provided for @electricityBillLabel.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill'**
  String get electricityBillLabel;

  /// No description provided for @waterBillLabel.
  ///
  /// In en, this message translates to:
  /// **'Water Bill'**
  String get waterBillLabel;

  /// No description provided for @maintenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceLabel;

  /// No description provided for @sendInvoiceBtn.
  ///
  /// In en, this message translates to:
  /// **'Send Invoice'**
  String get sendInvoiceBtn;

  /// No description provided for @viewBillHistory.
  ///
  /// In en, this message translates to:
  /// **'View Bill History ({count})'**
  String viewBillHistory(int count);

  /// No description provided for @otherChargesLabel.
  ///
  /// In en, this message translates to:
  /// **'Other Charges'**
  String get otherChargesLabel;

  /// No description provided for @documentTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Title'**
  String get documentTitle;

  /// No description provided for @addBtn.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addBtn;

  /// No description provided for @pleaseSelectTenant.
  ///
  /// In en, this message translates to:
  /// **'Please select a tenant'**
  String get pleaseSelectTenant;

  /// No description provided for @tenantMovedInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant moved in successfully'**
  String get tenantMovedInSuccess;

  /// No description provided for @incompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Profile'**
  String get incompleteProfile;

  /// No description provided for @completeLaterMsg.
  ///
  /// In en, this message translates to:
  /// **'Complete these later from the Edit Tenant page'**
  String get completeLaterMsg;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @saveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Save Anyway'**
  String get saveAnyway;

  /// No description provided for @addFamilyMember.
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addFamilyMember;

  /// No description provided for @spouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouse;

  /// No description provided for @child.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get child;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @sibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get sibling;

  /// No description provided for @otherRelation.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherRelation;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @maleLabel.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get maleLabel;

  /// No description provided for @femaleLabel.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get femaleLabel;

  /// No description provided for @nameAndRelRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and relationship required'**
  String get nameAndRelRequired;

  /// No description provided for @moveInTenantTitle.
  ///
  /// In en, this message translates to:
  /// **'Move In Tenant'**
  String get moveInTenantTitle;

  /// No description provided for @existingTenant.
  ///
  /// In en, this message translates to:
  /// **'Existing Tenant'**
  String get existingTenant;

  /// No description provided for @newTenant.
  ///
  /// In en, this message translates to:
  /// **'New Tenant'**
  String get newTenant;

  /// No description provided for @essentialInfo.
  ///
  /// In en, this message translates to:
  /// **'Essential Information'**
  String get essentialInfo;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @addressLine.
  ///
  /// In en, this message translates to:
  /// **'Address Line'**
  String get addressLine;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateLabel;

  /// No description provided for @pincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincodeLabel;

  /// No description provided for @idDocuments.
  ///
  /// In en, this message translates to:
  /// **'ID Documents'**
  String get idDocuments;

  /// No description provided for @aadhaarNumber.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNumber;

  /// No description provided for @aadhaarCardPhotos.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card Photos'**
  String get aadhaarCardPhotos;

  /// No description provided for @frontLabel.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get frontLabel;

  /// No description provided for @backLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backLabel;

  /// No description provided for @policeVerificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Police Verification Status'**
  String get policeVerificationStatus;

  /// No description provided for @clearBtn.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearBtn;

  /// No description provided for @takePhotoBtn.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhotoBtn;

  /// No description provided for @uploadGalleryBtn.
  ///
  /// In en, this message translates to:
  /// **'Upload Gallery'**
  String get uploadGalleryBtn;

  /// No description provided for @addMemberMsg.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMemberMsg;

  /// No description provided for @electricitySetup.
  ///
  /// In en, this message translates to:
  /// **'Electricity Setup'**
  String get electricitySetup;

  /// No description provided for @currentMeterReading.
  ///
  /// In en, this message translates to:
  /// **'Current Meter Reading'**
  String get currentMeterReading;

  /// No description provided for @currentRatePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Current Rate per Unit'**
  String get currentRatePerUnit;

  /// No description provided for @aadhaarFrontPhoto.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Front Photo'**
  String get aadhaarFrontPhoto;

  /// No description provided for @aadhaarBackPhoto.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Back Photo'**
  String get aadhaarBackPhoto;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @introducerName.
  ///
  /// In en, this message translates to:
  /// **'Introducer Name'**
  String get introducerName;

  /// No description provided for @introducerAddress.
  ///
  /// In en, this message translates to:
  /// **'Introducer Address'**
  String get introducerAddress;

  /// No description provided for @introducerPhone.
  ///
  /// In en, this message translates to:
  /// **'Introducer Phone'**
  String get introducerPhone;

  /// No description provided for @additionalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Additional Documents'**
  String get additionalDocuments;

  /// No description provided for @addDocumentBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocumentBtn;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @addNewBtn.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNewBtn;

  /// No description provided for @noFamilyMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No family members added yet'**
  String get noFamilyMembersYet;

  /// No description provided for @selectTenant.
  ///
  /// In en, this message translates to:
  /// **'Select Tenant'**
  String get selectTenant;

  /// No description provided for @futureLabel.
  ///
  /// In en, this message translates to:
  /// **'Future'**
  String get futureLabel;

  /// No description provided for @startBillingFrom.
  ///
  /// In en, this message translates to:
  /// **'Start Billing From'**
  String get startBillingFrom;

  /// No description provided for @billsNotTrackedMsg.
  ///
  /// In en, this message translates to:
  /// **'Bills before this date will not be tracked'**
  String get billsNotTrackedMsg;

  /// No description provided for @autoLabel.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get autoLabel;

  /// No description provided for @noAgreementDateSet.
  ///
  /// In en, this message translates to:
  /// **'No agreement date set'**
  String get noAgreementDateSet;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @pastTenant.
  ///
  /// In en, this message translates to:
  /// **'Past Tenant'**
  String get pastTenant;

  /// No description provided for @moveOutSettlement.
  ///
  /// In en, this message translates to:
  /// **'Move Out Settlement'**
  String get moveOutSettlement;

  /// No description provided for @pendingBillsToDeduct.
  ///
  /// In en, this message translates to:
  /// **'Pending Bills to Deduct'**
  String get pendingBillsToDeduct;

  /// No description provided for @undoVoid.
  ///
  /// In en, this message translates to:
  /// **'Undo Void'**
  String get undoVoid;

  /// No description provided for @markAsVoid.
  ///
  /// In en, this message translates to:
  /// **'Mark as Void'**
  String get markAsVoid;

  /// No description provided for @otherDeductionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Other Deductions'**
  String get otherDeductionsTitle;

  /// No description provided for @totalDeposit.
  ///
  /// In en, this message translates to:
  /// **'Total Deposit'**
  String get totalDeposit;

  /// No description provided for @billDeductions.
  ///
  /// In en, this message translates to:
  /// **'Bill Deductions'**
  String get billDeductions;

  /// No description provided for @tenantOwes.
  ///
  /// In en, this message translates to:
  /// **'Tenant Owes'**
  String get tenantOwes;

  /// No description provided for @refundableAmount.
  ///
  /// In en, this message translates to:
  /// **'Refundable Amount'**
  String get refundableAmount;

  /// No description provided for @settledViaDeposit.
  ///
  /// In en, this message translates to:
  /// **'Settled via Deposit Deduction'**
  String get settledViaDeposit;

  /// No description provided for @confirmMoveOutRecord.
  ///
  /// In en, this message translates to:
  /// **'Confirm Move Out & Record Pending'**
  String get confirmMoveOutRecord;

  /// No description provided for @confirmMoveOutSettle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Move Out & Settle'**
  String get confirmMoveOutSettle;

  /// No description provided for @moveOutDate.
  ///
  /// In en, this message translates to:
  /// **'Move Out Date'**
  String get moveOutDate;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @ledgerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Ledger not found'**
  String get ledgerNotFound;

  /// No description provided for @tenantT.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get tenantT;

  /// No description provided for @overdueByDays.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {days} days'**
  String overdueByDays(int days);

  /// No description provided for @amountDueSuffix.
  ///
  /// In en, this message translates to:
  /// **'{amount} due'**
  String amountDueSuffix(String amount);

  /// No description provided for @khataStatement.
  ///
  /// In en, this message translates to:
  /// **'KHATA STATEMENT'**
  String get khataStatement;

  /// No description provided for @fromLabel.
  ///
  /// In en, this message translates to:
  /// **'From:'**
  String get fromLabel;

  /// No description provided for @toLabel.
  ///
  /// In en, this message translates to:
  /// **'To:'**
  String get toLabel;

  /// No description provided for @roomNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Room No: {roomNumber}'**
  String roomNoLabel(String roomNumber);

  /// No description provided for @totalBilledLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Billed'**
  String get totalBilledLabel;

  /// No description provided for @totalPaidLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaidLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @billedLabel.
  ///
  /// In en, this message translates to:
  /// **'Billed'**
  String get billedLabel;

  /// No description provided for @advanceLabel.
  ///
  /// In en, this message translates to:
  /// **'{amount} (Adv)'**
  String advanceLabel(String amount);

  /// No description provided for @systemGeneratedMsg.
  ///
  /// In en, this message translates to:
  /// **'This is a system-generated statement and does not require a physical signature.'**
  String get systemGeneratedMsg;

  /// No description provided for @moveOutSettlementTitle.
  ///
  /// In en, this message translates to:
  /// **'MOVE-OUT SETTLEMENT'**
  String get moveOutSettlementTitle;

  /// No description provided for @moveOutDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Move Out Date: {date}'**
  String moveOutDateLabel(String date);

  /// No description provided for @moveInDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Move In Date: {date}'**
  String moveInDateLabel(String date);

  /// No description provided for @initialSecurityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Initial Security Deposit'**
  String get initialSecurityDeposit;

  /// No description provided for @deductionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Deductions'**
  String get deductionsLabel;

  /// No description provided for @amountDeductedLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount Deducted'**
  String get amountDeductedLabel;

  /// No description provided for @finalRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Final Refund Amount'**
  String get finalRefundAmount;

  /// No description provided for @amountTenantOwes.
  ///
  /// In en, this message translates to:
  /// **'Amount Tenant Owes'**
  String get amountTenantOwes;

  /// No description provided for @accountSettledMsg.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT SETTLED - NO CURRENT DUES'**
  String get accountSettledMsg;

  /// No description provided for @tenantSignature.
  ///
  /// In en, this message translates to:
  /// **'Tenant Signature'**
  String get tenantSignature;

  /// No description provided for @landlordSignature.
  ///
  /// In en, this message translates to:
  /// **'Landlord Signature'**
  String get landlordSignature;

  /// No description provided for @computerGeneratedMsg.
  ///
  /// In en, this message translates to:
  /// **'This is a computer-generated statement and does not require a physical signature.'**
  String get computerGeneratedMsg;

  /// No description provided for @aboutLabel.
  ///
  /// In en, this message translates to:
  /// **'About Label'**
  String get aboutLabel;

  /// No description provided for @aboutRentKhataDescription.
  ///
  /// In en, this message translates to:
  /// **'Proudly built for Indian landlords. RentKhata is a secure, 100% offline app to manage your properties, tenants, and rent payments right from your phone.'**
  String get aboutRentKhataDescription;

  /// No description provided for @alertDaysBeforeCycle.
  ///
  /// In en, this message translates to:
  /// **'Alert {count} days before'**
  String alertDaysBeforeCycle(int count);

  /// No description provided for @dateToDateBillingByBillType.
  ///
  /// In en, this message translates to:
  /// **'Date-to-Date Billing By Bill Type'**
  String get dateToDateBillingByBillType;

  /// No description provided for @dateToDateBillingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-calculate billing period based on move-in date.'**
  String get dateToDateBillingSubtitle;

  /// No description provided for @backupAndRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your data securely'**
  String get backupAndRestoreSubtitle;

  /// No description provided for @backupCreatedShare.
  ///
  /// In en, this message translates to:
  /// **'Backup saved successfully'**
  String get backupCreatedShare;

  /// No description provided for @backupInfoText.
  ///
  /// In en, this message translates to:
  /// **'Save your data externally to ensure you don\'t lose it if you uninstall the app or change devices.'**
  String get backupInfoText;

  /// No description provided for @backupRestoredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully!'**
  String get backupRestoredSuccess;

  /// No description provided for @billDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Bill Due Soon'**
  String get billDueSoon;

  /// No description provided for @billFullyPaid.
  ///
  /// In en, this message translates to:
  /// **'Bill Fully Paid'**
  String get billFullyPaid;

  /// No description provided for @billFullyPaidSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bill Fully Paid Subtitle'**
  String get billFullyPaidSubtitle;

  /// No description provided for @billingCycleEnding.
  ///
  /// In en, this message translates to:
  /// **'Billing Cycle Ending'**
  String get billingCycleEnding;

  /// No description provided for @billingLabel.
  ///
  /// In en, this message translates to:
  /// **'Billing Label'**
  String get billingLabel;

  /// No description provided for @billingReminders.
  ///
  /// In en, this message translates to:
  /// **'Billing Reminders'**
  String get billingReminders;

  /// No description provided for @biometricFallbackInfo.
  ///
  /// In en, this message translates to:
  /// **'Biometric Fallback Info'**
  String get biometricFallbackInfo;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock'**
  String get biometricLock;

  /// No description provided for @biometricLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock Subtitle'**
  String get biometricLockSubtitle;

  /// No description provided for @biometricsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics Not Available'**
  String get biometricsNotAvailable;

  /// No description provided for @changesSavedAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Changes Saved Automatically'**
  String get changesSavedAutomatically;

  /// No description provided for @createBackupToKeepSafe.
  ///
  /// In en, this message translates to:
  /// **'Create an external backup to ensure your data is always safe and can be easily restored at any time'**
  String get createBackupToKeepSafe;

  /// No description provided for @createShareBackup.
  ///
  /// In en, this message translates to:
  /// **'Save Backup'**
  String get createShareBackup;

  /// No description provided for @criticalUrgentAttention.
  ///
  /// In en, this message translates to:
  /// **'Critical Urgent Attention'**
  String get criticalUrgentAttention;

  /// No description provided for @currentRate.
  ///
  /// In en, this message translates to:
  /// **'Current Rate'**
  String get currentRate;

  /// No description provided for @dataLabel.
  ///
  /// In en, this message translates to:
  /// **'Data Label'**
  String get dataLabel;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @deviceDoesNotSupportBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Device Does Not Support Biometrics'**
  String get deviceDoesNotSupportBiometrics;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @dueDateOffsetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Due Date Offset Subtitle'**
  String get dueDateOffsetSubtitle;

  /// No description provided for @dueDaysAfterCycle.
  ///
  /// In en, this message translates to:
  /// **'Due {count} days after cycle ends'**
  String dueDaysAfterCycle(int count);

  /// No description provided for @dueSoonAlert.
  ///
  /// In en, this message translates to:
  /// **'Due Soon Alert'**
  String get dueSoonAlert;

  /// No description provided for @dueSoonAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Due Soon Alert Subtitle'**
  String get dueSoonAlertSubtitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @effectiveFrom.
  ///
  /// In en, this message translates to:
  /// **'Effective from {date}'**
  String effectiveFrom(String date);

  /// No description provided for @electricityMeterBills.
  ///
  /// In en, this message translates to:
  /// **'Electricity Meter Bills'**
  String get electricityMeterBills;

  /// No description provided for @electricityRateInfoText.
  ///
  /// In en, this message translates to:
  /// **'Electricity Rate Info Text'**
  String get electricityRateInfoText;

  /// No description provided for @electricityRatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Electricity Rates Subtitle'**
  String get electricityRatesSubtitle;

  /// No description provided for @enableAppLock.
  ///
  /// In en, this message translates to:
  /// **'Enable App Lock'**
  String get enableAppLock;

  /// No description provided for @enterValidRate.
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Rate'**
  String get enterValidRate;

  /// No description provided for @firstReminderAfterDueDate.
  ///
  /// In en, this message translates to:
  /// **'First Reminder After Due Date'**
  String get firstReminderAfterDueDate;

  /// No description provided for @generalSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'General Settings Label'**
  String get generalSettingsLabel;

  /// No description provided for @localBackups.
  ///
  /// In en, this message translates to:
  /// **'Local Backups'**
  String get localBackups;

  /// No description provided for @lockAfterInactivity.
  ///
  /// In en, this message translates to:
  /// **'Lock After Inactivity'**
  String get lockAfterInactivity;

  /// No description provided for @lockOnExit.
  ///
  /// In en, this message translates to:
  /// **'Lock On Exit'**
  String get lockOnExit;

  /// No description provided for @lockOnExitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lock On Exit Subtitle'**
  String get lockOnExitSubtitle;

  /// No description provided for @maintenanceCharges.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Charges'**
  String get maintenanceCharges;

  /// No description provided for @messageBody.
  ///
  /// In en, this message translates to:
  /// **'Message Body'**
  String get messageBody;

  /// No description provided for @messageTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Message Templates Subtitle'**
  String get messageTemplatesSubtitle;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutes(int count);

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number Hint'**
  String get mobileNumberHint;

  /// No description provided for @monthlyRentBills.
  ///
  /// In en, this message translates to:
  /// **'Monthly Rent Bills'**
  String get monthlyRentBills;

  /// No description provided for @monthlySummary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary'**
  String get monthlySummary;

  /// No description provided for @monthlySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary Subtitle'**
  String get monthlySummarySubtitle;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @noBiometricsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No Biometrics Enrolled'**
  String get noBiometricsEnrolled;

  /// No description provided for @noLocalBackups.
  ///
  /// In en, this message translates to:
  /// **'No Local Backups'**
  String get noLocalBackups;

  /// No description provided for @noRateHistory.
  ///
  /// In en, this message translates to:
  /// **'No Rate History'**
  String get noRateHistory;

  /// No description provided for @notEnabled.
  ///
  /// In en, this message translates to:
  /// **'Not Enabled'**
  String get notEnabled;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// No description provided for @notificationsWorking.
  ///
  /// In en, this message translates to:
  /// **'Notifications Working'**
  String get notificationsWorking;

  /// No description provided for @oneDayOverdue.
  ///
  /// In en, this message translates to:
  /// **'One Day Overdue'**
  String get oneDayOverdue;

  /// No description provided for @oneMinute.
  ///
  /// In en, this message translates to:
  /// **'One Minute'**
  String get oneMinute;

  /// No description provided for @oneWeekOverdue.
  ///
  /// In en, this message translates to:
  /// **'One Week Overdue'**
  String get oneWeekOverdue;

  /// No description provided for @overdueFollowUps.
  ///
  /// In en, this message translates to:
  /// **'Overdue Follow Ups'**
  String get overdueFollowUps;

  /// No description provided for @paymentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Payment Notifications'**
  String get paymentNotifications;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @paymentReceivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Received Subtitle'**
  String get paymentReceivedSubtitle;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionDenied;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated'**
  String get profileUpdated;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @rateHistory.
  ///
  /// In en, this message translates to:
  /// **'Rate History'**
  String get rateHistory;

  /// No description provided for @ratePerUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate Per Unit Label'**
  String get ratePerUnitLabel;

  /// No description provided for @rateUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rate Updated'**
  String get rateUpdated;

  /// No description provided for @receiptLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt Label'**
  String get receiptLabel;

  /// No description provided for @remindDaysBeforeCycleEnds.
  ///
  /// In en, this message translates to:
  /// **'Remind {days} days before cycle ends'**
  String remindDaysBeforeCycleEnds(int days);

  /// No description provided for @remindDaysBeforeDueDate.
  ///
  /// In en, this message translates to:
  /// **'Remind {days} days before due date'**
  String remindDaysBeforeDueDate(int days);

  /// No description provided for @reminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder Label'**
  String get reminderLabel;

  /// No description provided for @reminderSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Settings Subtitle'**
  String get reminderSettingsSubtitle;

  /// No description provided for @requireBiometric.
  ///
  /// In en, this message translates to:
  /// **'Require Biometric'**
  String get requireBiometric;

  /// No description provided for @resetBtn.
  ///
  /// In en, this message translates to:
  /// **'Reset Btn'**
  String get resetBtn;

  /// No description provided for @resetTemplateWarning.
  ///
  /// In en, this message translates to:
  /// **'Reset Template Warning'**
  String get resetTemplateWarning;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset To Default'**
  String get resetToDefault;

  /// No description provided for @restartNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Restart Now Btn'**
  String get restartNowBtn;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupWarning.
  ///
  /// In en, this message translates to:
  /// **'This will completely overwrite your current data. Are you sure you want to continue?'**
  String get restoreBackupWarning;

  /// No description provided for @restoreBtn.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreBtn;

  /// No description provided for @restoreFailedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Restore failed'**
  String get restoreFailedPrefix;

  /// No description provided for @restoreFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreFromDevice;

  /// No description provided for @restoreFromDeviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load an existing backup from your phone'**
  String get restoreFromDeviceSubtitle;

  /// No description provided for @restoreSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Successful'**
  String get restoreSuccessTitle;

  /// No description provided for @saveDataToFile.
  ///
  /// In en, this message translates to:
  /// **'Save your database to a ZIP file'**
  String get saveDataToFile;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfile;

  /// No description provided for @secondReminder.
  ///
  /// In en, this message translates to:
  /// **'Second Reminder'**
  String get secondReminder;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get sendTestNotification;

  /// No description provided for @setNewRate.
  ///
  /// In en, this message translates to:
  /// **'Set New Rate'**
  String get setNewRate;

  /// No description provided for @setupFingerprintFirst.
  ///
  /// In en, this message translates to:
  /// **'Setup Fingerprint First'**
  String get setupFingerprintFirst;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @templateAlreadyDefault.
  ///
  /// In en, this message translates to:
  /// **'Template Already Default'**
  String get templateAlreadyDefault;

  /// No description provided for @templatePlaceholders.
  ///
  /// In en, this message translates to:
  /// **'Template Placeholders'**
  String get templatePlaceholders;

  /// No description provided for @templateResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template Reset Success'**
  String get templateResetSuccess;

  /// No description provided for @templateSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template Saved Success'**
  String get templateSavedSuccess;

  /// No description provided for @templateUsedWhenSharing.
  ///
  /// In en, this message translates to:
  /// **'Template used when sharing {type}'**
  String templateUsedWhenSharing(String type);

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Notification Title'**
  String get testNotificationTitle;

  /// No description provided for @threeDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'Three Days Overdue'**
  String get threeDaysOverdue;

  /// No description provided for @twoWeeksOverdue.
  ///
  /// In en, this message translates to:
  /// **'Two Weeks Overdue'**
  String get twoWeeksOverdue;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @updateRate.
  ///
  /// In en, this message translates to:
  /// **'Update Rate'**
  String get updateRate;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'Upi Id'**
  String get upiId;

  /// No description provided for @upiIdHelperText.
  ///
  /// In en, this message translates to:
  /// **'Upi Id Helper Text'**
  String get upiIdHelperText;

  /// No description provided for @upiIdHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. yourname@upi'**
  String get upiIdHint;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @weeklyReminder.
  ///
  /// In en, this message translates to:
  /// **'Weekly Reminder'**
  String get weeklyReminder;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @documentPdf.
  ///
  /// In en, this message translates to:
  /// **'document.pdf'**
  String get documentPdf;

  /// No description provided for @errorSharingMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to share message: {error}'**
  String errorSharingMessage(String error);

  /// No description provided for @downloadsFolder.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloadsFolder;

  /// No description provided for @savedToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Saved to Downloads'**
  String get savedToDownloads;

  /// No description provided for @savedToFolder.
  ///
  /// In en, this message translates to:
  /// **'Saved to {folderName}'**
  String savedToFolder(String folderName);

  /// No description provided for @couldNotSavePdf.
  ///
  /// In en, this message translates to:
  /// **'Could not save the PDF. Please try again.'**
  String get couldNotSavePdf;

  /// No description provided for @unableToLoadPdfPreview.
  ///
  /// In en, this message translates to:
  /// **'Unable to load PDF preview'**
  String get unableToLoadPdfPreview;

  /// No description provided for @shareReceipt.
  ///
  /// In en, this message translates to:
  /// **'Share Receipt'**
  String get shareReceipt;

  /// No description provided for @chooseHowToShare.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to share'**
  String get chooseHowToShare;

  /// No description provided for @sendAsMessage.
  ///
  /// In en, this message translates to:
  /// **'Send as Message'**
  String get sendAsMessage;

  /// No description provided for @quickTextWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Quick text with details'**
  String get quickTextWithDetails;

  /// No description provided for @sharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get sharePdf;

  /// No description provided for @formalDocument.
  ///
  /// In en, this message translates to:
  /// **'Formal document'**
  String get formalDocument;

  /// No description provided for @errorGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF: {error}'**
  String errorGeneratingPdf(String error);

  /// No description provided for @paymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'Payment Receipt'**
  String get paymentReceipt;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Never Miss a Payment'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Never miss a payment! Want us to remind you when rent is due?'**
  String get notificationPermissionBody;

  /// No description provided for @biometricPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep Ledger Secure'**
  String get biometricPermissionTitle;

  /// No description provided for @biometricPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Keep your ledger secure. Would you like to lock RentKhata with your Fingerprint?'**
  String get biometricPermissionBody;

  /// No description provided for @yesBtn.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesBtn;

  /// No description provided for @noBtn.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noBtn;

  /// No description provided for @notNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNowBtn;

  /// No description provided for @systemNotificationsDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'System Notifications Disabled'**
  String get systemNotificationsDisabledTitle;

  /// No description provided for @systemNotificationsDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive rent alerts and payment reminders.'**
  String get systemNotificationsDisabledBody;

  /// No description provided for @enableBtn.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableBtn;

  /// No description provided for @appLockEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'App Lock enabled successfully!'**
  String get appLockEnabledSuccess;

  /// No description provided for @appLockSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'App Lock verification failed.'**
  String get appLockSetupFailed;

  /// No description provided for @smartAlerts.
  ///
  /// In en, this message translates to:
  /// **'Smart Alerts'**
  String get smartAlerts;

  /// No description provided for @agreementExpiredAlert.
  ///
  /// In en, this message translates to:
  /// **'Agreement already expired'**
  String get agreementExpiredAlert;

  /// No description provided for @agreementExpiredAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remind after {days} day(s) past agreement end date'**
  String agreementExpiredAlertSubtitle(int days);

  /// No description provided for @billNotGeneratedAlert.
  ///
  /// In en, this message translates to:
  /// **'Bill not generated reminder'**
  String get billNotGeneratedAlert;

  /// No description provided for @billNotGeneratedAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alert when cycle is overdue or within {days} day(s) of ending'**
  String billNotGeneratedAlertSubtitle(int days);

  /// No description provided for @partialPaymentPauseAlert.
  ///
  /// In en, this message translates to:
  /// **'Pause overdue follow-ups after partial payment'**
  String get partialPaymentPauseAlert;

  /// No description provided for @partialPaymentPauseAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pauses escalations once paid amount reaches 50%'**
  String get partialPaymentPauseAlertSubtitle;

  /// No description provided for @depositSettlementAlert.
  ///
  /// In en, this message translates to:
  /// **'Deposit settlement due after move-out'**
  String get depositSettlementAlert;

  /// No description provided for @depositSettlementAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remind after {days} day(s) if settlement is pending'**
  String depositSettlementAlertSubtitle(int days);

  /// No description provided for @depositStatus.
  ///
  /// In en, this message translates to:
  /// **'Deposit Status'**
  String get depositStatus;

  /// No description provided for @settledStatusCap.
  ///
  /// In en, this message translates to:
  /// **'SETTLED'**
  String get settledStatusCap;

  /// No description provided for @manualDeductions.
  ///
  /// In en, this message translates to:
  /// **'Manual Deductions'**
  String get manualDeductions;

  /// No description provided for @finalRefund.
  ///
  /// In en, this message translates to:
  /// **'Final Refund'**
  String get finalRefund;

  /// No description provided for @amountOwed.
  ///
  /// In en, this message translates to:
  /// **'Amount Owed'**
  String get amountOwed;

  /// No description provided for @manualDeductionReason.
  ///
  /// In en, this message translates to:
  /// **'Manual Deduction Reason'**
  String get manualDeductionReason;

  /// No description provided for @utilityAnomalyAlert.
  ///
  /// In en, this message translates to:
  /// **'High utility usage anomaly'**
  String get utilityAnomalyAlert;

  /// No description provided for @utilityAnomalyAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Alerts when latest electricity usage spikes sharply'**
  String get utilityAnomalyAlertSubtitle;

  /// No description provided for @sameAsMoveIn.
  ///
  /// In en, this message translates to:
  /// **'Same as move-in'**
  String get sameAsMoveIn;

  /// No description provided for @selectBillToCollect.
  ///
  /// In en, this message translates to:
  /// **'Select a bill below to review it and collect its pending payment.'**
  String get selectBillToCollect;

  /// No description provided for @overdueSinceDate.
  ///
  /// In en, this message translates to:
  /// **'Overdue since {date}'**
  String overdueSinceDate(String date);

  /// No description provided for @awaitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get awaitingPayment;

  /// No description provided for @unknownTenant.
  ///
  /// In en, this message translates to:
  /// **'Unknown Tenant'**
  String get unknownTenant;

  /// No description provided for @unknownRoom.
  ///
  /// In en, this message translates to:
  /// **'Unknown Room'**
  String get unknownRoom;

  /// No description provided for @collectLabel.
  ///
  /// In en, this message translates to:
  /// **'Collect'**
  String get collectLabel;

  /// No description provided for @pdfReceivedFrom.
  ///
  /// In en, this message translates to:
  /// **'RECEIVED FROM'**
  String get pdfReceivedFrom;

  /// No description provided for @pdfInvoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'INVOICE'**
  String get pdfInvoiceTitle;

  /// No description provided for @pdfReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'RECEIPT'**
  String get pdfReceiptTitle;

  /// No description provided for @pdfBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get pdfBalanceDue;

  /// No description provided for @pdfBillTo.
  ///
  /// In en, this message translates to:
  /// **'BILL TO'**
  String get pdfBillTo;

  /// No description provided for @pdfRoom.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get pdfRoom;

  /// No description provided for @pdfIssued.
  ///
  /// In en, this message translates to:
  /// **'ISSUED'**
  String get pdfIssued;

  /// No description provided for @pdfDueDate.
  ///
  /// In en, this message translates to:
  /// **'DUE DATE'**
  String get pdfDueDate;

  /// No description provided for @pdfDescription.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get pdfDescription;

  /// No description provided for @pdfPeriod.
  ///
  /// In en, this message translates to:
  /// **'PERIOD'**
  String get pdfPeriod;

  /// No description provided for @pdfAmount.
  ///
  /// In en, this message translates to:
  /// **'AMOUNT'**
  String get pdfAmount;

  /// No description provided for @pdfTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get pdfTotalAmount;

  /// No description provided for @pdfAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get pdfAmountPaid;

  /// No description provided for @pdfPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT HISTORY'**
  String get pdfPaymentHistory;

  /// No description provided for @pdfDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pdfDate;

  /// No description provided for @pdfMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get pdfMode;

  /// No description provided for @pdfPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT DETAILS'**
  String get pdfPaymentDetails;

  /// No description provided for @pdfTotalBill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill'**
  String get pdfTotalBill;

  /// No description provided for @pdfTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get pdfTotalPaid;

  /// No description provided for @pdfRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get pdfRemaining;

  /// No description provided for @pdfStatusFullyPaid.
  ///
  /// In en, this message translates to:
  /// **'Status: FULLY PAID ✅'**
  String get pdfStatusFullyPaid;

  /// No description provided for @pdfUpiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get pdfUpiId;

  /// No description provided for @pdfScanToPay.
  ///
  /// In en, this message translates to:
  /// **'Scan to Pay'**
  String get pdfScanToPay;

  /// No description provided for @pdfTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'TERMS & CONDITIONS'**
  String get pdfTermsAndConditions;

  /// No description provided for @pdfTerm1.
  ///
  /// In en, this message translates to:
  /// **'1. Please pay the bill before the due date to avoid late fees.'**
  String get pdfTerm1;

  /// No description provided for @pdfTerm2.
  ///
  /// In en, this message translates to:
  /// **'2. This is a computer-generated invoice and no signature is required unless specified.'**
  String get pdfTerm2;

  /// No description provided for @pdfVoid.
  ///
  /// In en, this message translates to:
  /// **'VOID'**
  String get pdfVoid;

  /// No description provided for @pdfPaid.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get pdfPaid;

  /// No description provided for @shareStatementSubject.
  ///
  /// In en, this message translates to:
  /// **'Khata Statement'**
  String get shareStatementSubject;

  /// No description provided for @shareStatementBody.
  ///
  /// In en, this message translates to:
  /// **'Dear {name},\n\nPlease find your generated Khata Statement attached.'**
  String shareStatementBody(String name);

  /// No description provided for @shareSettlementSubject.
  ///
  /// In en, this message translates to:
  /// **'Move-Out Settlement Receipt'**
  String get shareSettlementSubject;

  /// No description provided for @shareSettlementBody.
  ///
  /// In en, this message translates to:
  /// **'Dear {name},\n\nYour Move-Out Settlement is complete. Please find the detailed Settlement Receipt attached.'**
  String shareSettlementBody(String name);

  /// No description provided for @shareInvoiceSubject.
  ///
  /// In en, this message translates to:
  /// **'Invoice - {period}'**
  String shareInvoiceSubject(String period);

  /// No description provided for @shareReceiptSubject.
  ///
  /// In en, this message translates to:
  /// **'Payment Receipt - {period}'**
  String shareReceiptSubject(String period);

  /// No description provided for @shareDear.
  ///
  /// In en, this message translates to:
  /// **'Dear {name},'**
  String shareDear(String name);

  /// No description provided for @shareInvoiceHeader.
  ///
  /// In en, this message translates to:
  /// **'📋 *INVOICE*'**
  String get shareInvoiceHeader;

  /// No description provided for @shareInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #: {number}'**
  String shareInvoiceNumber(String number);

  /// No description provided for @shareBillDetails.
  ///
  /// In en, this message translates to:
  /// **'*Bill Details:*'**
  String get shareBillDetails;

  /// No description provided for @shareType.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String shareType(String type);

  /// No description provided for @sharePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: {period}'**
  String sharePeriod(String period);

  /// No description provided for @shareRoom.
  ///
  /// In en, this message translates to:
  /// **'Room: {room}'**
  String shareRoom(String room);

  /// No description provided for @shareMeterReadings.
  ///
  /// In en, this message translates to:
  /// **'*Meter Readings:*'**
  String get shareMeterReadings;

  /// No description provided for @sharePrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous: {reading} units'**
  String sharePrevious(String reading);

  /// No description provided for @shareCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {reading} units'**
  String shareCurrent(String reading);

  /// No description provided for @shareUnitsUsed.
  ///
  /// In en, this message translates to:
  /// **'Units Used: {units} units'**
  String shareUnitsUsed(String units);

  /// No description provided for @shareRate.
  ///
  /// In en, this message translates to:
  /// **'Rate: ₹{rate}/unit'**
  String shareRate(String rate);

  /// No description provided for @shareAmountHeader.
  ///
  /// In en, this message translates to:
  /// **'*Amount:*'**
  String get shareAmountHeader;

  /// No description provided for @shareTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: ₹{amount}'**
  String shareTotal(String amount);

  /// No description provided for @sharePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid: ₹{amount}'**
  String sharePaid(String amount);

  /// No description provided for @sharePending.
  ///
  /// In en, this message translates to:
  /// **'*Pending: ₹{amount}*'**
  String sharePending(String amount);

  /// No description provided for @shareDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date: {date}'**
  String shareDueDate(String date);

  /// No description provided for @sharePayViaUpi.
  ///
  /// In en, this message translates to:
  /// **'📱 *Pay via UPI:*'**
  String get sharePayViaUpi;

  /// No description provided for @shareThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you,'**
  String get shareThankYou;

  /// No description provided for @sharePaymentReceived.
  ///
  /// In en, this message translates to:
  /// **'✅ *PAYMENT RECEIVED*'**
  String get sharePaymentReceived;

  /// No description provided for @sharePaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'*Payment Details:*'**
  String get sharePaymentDetails;

  /// No description provided for @shareAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount: ₹{amount}'**
  String shareAmount(String amount);

  /// No description provided for @shareMode.
  ///
  /// In en, this message translates to:
  /// **'Mode: {mode}'**
  String shareMode(String mode);

  /// No description provided for @shareDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String shareDate(String date);

  /// No description provided for @shareBillStatus.
  ///
  /// In en, this message translates to:
  /// **'*Bill Status:*'**
  String get shareBillStatus;

  /// No description provided for @shareTotalBill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill: ₹{amount}'**
  String shareTotalBill(String amount);

  /// No description provided for @shareTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid: ₹{amount}'**
  String shareTotalPaid(String amount);

  /// No description provided for @shareRemaining.
  ///
  /// In en, this message translates to:
  /// **'*Remaining: ₹{amount}*'**
  String shareRemaining(String amount);

  /// No description provided for @shareStatusFullyPaid.
  ///
  /// In en, this message translates to:
  /// **'*Status: FULLY PAID ✅*'**
  String get shareStatusFullyPaid;

  /// No description provided for @shareThankYouPayment.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your payment!'**
  String get shareThankYouPayment;

  /// No description provided for @editRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Room'**
  String get editRoomTitle;

  /// No description provided for @addRoomTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Room'**
  String get addRoomTitle;

  /// No description provided for @roomNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Room Number/Name *'**
  String get roomNumberLabel;

  /// No description provided for @roomNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 101, Ground Floor Left'**
  String get roomNumberHint;

  /// No description provided for @monthlyRentHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 5000'**
  String get monthlyRentHint;

  /// No description provided for @electricityMeterToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Electricity Meter'**
  String get electricityMeterToggleTitle;

  /// No description provided for @electricityMeterToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track meter readings and auto-calculate electricity bills'**
  String get electricityMeterToggleSubtitle;

  /// No description provided for @saveChangesBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesBtn;

  /// No description provided for @roomUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room updated'**
  String get roomUpdatedSuccess;

  /// No description provided for @roomAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Room added'**
  String get roomAddedSuccess;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpenseTitle;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @noteOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (Optional)'**
  String get noteOptionalLabel;

  /// No description provided for @noteExpenseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Pump repair parts'**
  String get noteExpenseHint;

  /// No description provided for @saveExpenseBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Expense'**
  String get saveExpenseBtn;

  /// No description provided for @expenseAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get expenseAddedSuccess;

  /// No description provided for @addDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocumentTitle;

  /// No description provided for @documentTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Document Title'**
  String get documentTitleLabel;

  /// No description provided for @documentTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Rent Agreement, PAN Card'**
  String get documentTitleHint;

  /// No description provided for @tapToAddDocument.
  ///
  /// In en, this message translates to:
  /// **'Tap to add document'**
  String get tapToAddDocument;

  /// No description provided for @imageOrPdf.
  ///
  /// In en, this message translates to:
  /// **'Image or PDF'**
  String get imageOrPdf;

  /// No description provided for @saveDocumentBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Document'**
  String get saveDocumentBtn;

  /// No description provided for @selectPdf.
  ///
  /// In en, this message translates to:
  /// **'Select PDF'**
  String get selectPdf;

  /// No description provided for @selectDocumentError.
  ///
  /// In en, this message translates to:
  /// **'Please select a document'**
  String get selectDocumentError;

  /// No description provided for @skipForNowBtn.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNowBtn;

  /// No description provided for @whatAreYouManaging.
  ///
  /// In en, this message translates to:
  /// **'What are you managing?'**
  String get whatAreYouManaging;

  /// No description provided for @giveFirstPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Give your first property or building a name.'**
  String get giveFirstPropertyTitle;

  /// No description provided for @propertyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Property Name'**
  String get propertyNameLabel;

  /// No description provided for @propertyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Green Valley Apartments'**
  String get propertyNameHint;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @yourProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get yourProfileTitle;

  /// No description provided for @letsSetUpProfile.
  ///
  /// In en, this message translates to:
  /// **'Let\'s set up your profile so you can start managing properties.'**
  String get letsSetUpProfile;

  /// No description provided for @profileBillingInfoText.
  ///
  /// In en, this message translates to:
  /// **'This information will be used for billing and receipts.'**
  String get profileBillingInfoText;

  /// No description provided for @profileUpiInfoText.
  ///
  /// In en, this message translates to:
  /// **'Your UPI ID will be used to generate QR codes for tenants to pay rent easily.'**
  String get profileUpiInfoText;

  /// No description provided for @yourNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name *'**
  String get yourNameLabel;

  /// No description provided for @enterFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullNameHint;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get phoneNumberHint;

  /// No description provided for @upiIdLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiIdLabel;

  /// No description provided for @configureBillingCyclesTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure Billing Cycles'**
  String get configureBillingCyclesTitle;

  /// No description provided for @calculateBillsTenantDateText.
  ///
  /// In en, this message translates to:
  /// **'Calculate bills based on the tenant\'s specific move-in date'**
  String get calculateBillsTenantDateText;

  /// No description provided for @saveAndContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinueBtn;

  /// No description provided for @notificationsEnabledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled successfully!'**
  String get notificationsEnabledSuccess;

  /// No description provided for @notificationsDeniedError.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied.'**
  String get notificationsDeniedError;

  /// No description provided for @appLockNotConfiguredError.
  ///
  /// In en, this message translates to:
  /// **'App Lock was not configured.'**
  String get appLockNotConfiguredError;

  /// No description provided for @upiHelperText.
  ///
  /// In en, this message translates to:
  /// **'For receiving rent payments'**
  String get upiHelperText;

  /// No description provided for @propertyNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Property Name *'**
  String get propertyNameRequiredLabel;

  /// No description provided for @propertySunriseHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Sunrise Apartments'**
  String get propertySunriseHint;

  /// No description provided for @propertyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get propertyAddressLabel;

  /// No description provided for @propertyAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Full address of the property'**
  String get propertyAddressHint;

  /// No description provided for @noDocumentsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No documents added yet.'**
  String get noDocumentsAddedYet;

  /// No description provided for @noAvailableTenantsCreateNew.
  ///
  /// In en, this message translates to:
  /// **'No available tenants. Create a new tenant.'**
  String get noAvailableTenantsCreateNew;

  /// No description provided for @moveInDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Move-in Details'**
  String get moveInDetailsTitle;

  /// No description provided for @olderMoveInDetectedInfo.
  ///
  /// In en, this message translates to:
  /// **'Older move-in detected. Billing starts from this month.'**
  String get olderMoveInDetectedInfo;

  /// No description provided for @noFamilyMembersTap.
  ///
  /// In en, this message translates to:
  /// **'No family members. Tap'**
  String get noFamilyMembersTap;

  /// No description provided for @existingMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Existing members:'**
  String get existingMembersLabel;

  /// No description provided for @newMembersToAddLabel.
  ///
  /// In en, this message translates to:
  /// **'New members to add:'**
  String get newMembersToAddLabel;

  /// No description provided for @panCardHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. PAN Card'**
  String get panCardHint;

  /// No description provided for @nameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get nameRequiredLabel;

  /// No description provided for @relationshipRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship *'**
  String get relationshipRequiredLabel;

  /// No description provided for @phoneOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneOptionalLabel;

  /// Helper text explaining why we collect landlord phone number
  ///
  /// In en, this message translates to:
  /// **'Your phone number will be displayed on PDF invoices to help tenants contact you easily.'**
  String get phonePdfExplanation;

  /// No description provided for @fullNameRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameRequiredLabel;

  /// No description provided for @guardianNameOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Father\'s/Spouse\'s Name (Optional)'**
  String get guardianNameOptionalLabel;

  /// No description provided for @twelveDigitNumberHint.
  ///
  /// In en, this message translates to:
  /// **'12-digit number'**
  String get twelveDigitNumberHint;

  /// No description provided for @agreementEndDateOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Agreement End Date (Optional)'**
  String get agreementEndDateOptionalLabel;

  /// No description provided for @agreedRentLabel.
  ///
  /// In en, this message translates to:
  /// **'Agreed Rent (₹)'**
  String get agreedRentLabel;

  /// No description provided for @manualDeductionAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Manual Deduction Amount (₹)'**
  String get manualDeductionAmountLabel;

  /// No description provided for @deductionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason (e.g. Damages, Painting)'**
  String get deductionReasonHint;

  /// No description provided for @moveInDateInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Move-in Date'**
  String get moveInDateInputLabel;

  /// No description provided for @propertyUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Property updated'**
  String get propertyUpdatedSuccess;

  /// No description provided for @propertyAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Property added'**
  String get propertyAddedSuccess;

  /// No description provided for @editPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Property'**
  String get editPropertyTitle;

  /// No description provided for @addPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Property'**
  String get addPropertyTitle;

  /// No description provided for @aadhaarCardPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card Photos'**
  String get aadhaarCardPhotosLabel;

  /// No description provided for @policeVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Police Verified'**
  String get policeVerifiedLabel;

  /// No description provided for @policeVerifiedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mark if police verification is complete'**
  String get policeVerifiedSubtitle;

  /// No description provided for @profilePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhotoLabel;

  /// No description provided for @enterTenantFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter tenant\'s full name'**
  String get enterTenantFullNameHint;

  /// No description provided for @fathersNameRequiredHint.
  ///
  /// In en, this message translates to:
  /// **'Required for legal agreements'**
  String get fathersNameRequiredHint;

  /// No description provided for @tenDigitMobileHint.
  ///
  /// In en, this message translates to:
  /// **'10-digit mobile number'**
  String get tenDigitMobileHint;

  /// No description provided for @secondaryPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Secondary Phone'**
  String get secondaryPhoneLabel;

  /// No description provided for @emergencyFamilyContactHint.
  ///
  /// In en, this message translates to:
  /// **'Emergency/Family contact'**
  String get emergencyFamilyContactHint;

  /// No description provided for @addressLineLabel.
  ///
  /// In en, this message translates to:
  /// **'Address Line'**
  String get addressLineLabel;

  /// No description provided for @streetLocalityHint.
  ///
  /// In en, this message translates to:
  /// **'Street, Locality'**
  String get streetLocalityHint;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyNameLabel;

  /// No description provided for @officeAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Office Address'**
  String get officeAddressLabel;

  /// No description provided for @aadhaarNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Number'**
  String get aadhaarNumberLabel;

  /// No description provided for @twelveDigitAadhaarHint.
  ///
  /// In en, this message translates to:
  /// **'12-digit Aadhaar number'**
  String get twelveDigitAadhaarHint;

  /// No description provided for @introducerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Introducer Name'**
  String get introducerNameLabel;

  /// No description provided for @vouchedForTenantHint.
  ///
  /// In en, this message translates to:
  /// **'Person who vouched for tenant'**
  String get vouchedForTenantHint;

  /// No description provided for @introducerAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Introducer Address'**
  String get introducerAddressLabel;

  /// No description provided for @introducerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Introducer Phone'**
  String get introducerPhoneLabel;

  /// No description provided for @identityContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity & Contact'**
  String get identityContactTitle;

  /// No description provided for @permanentAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get permanentAddressTitle;

  /// No description provided for @workDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Work Details'**
  String get workDetailsTitle;

  /// No description provided for @idDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'ID Documents'**
  String get idDocumentsTitle;

  /// No description provided for @introducerReferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Introducer / Reference'**
  String get introducerReferenceTitle;

  /// No description provided for @additionalDocumentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Documents'**
  String get additionalDocumentsTitle;

  /// No description provided for @otherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherLabel;

  /// No description provided for @editTenantTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Tenant'**
  String get editTenantTitle;

  /// No description provided for @addTenantTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Tenant'**
  String get addTenantTitle;

  /// No description provided for @tenantUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant updated'**
  String get tenantUpdatedSuccess;

  /// No description provided for @tenantAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant added'**
  String get tenantAddedSuccess;

  /// No description provided for @tenantDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tenant deleted'**
  String get tenantDeletedSuccess;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @moveInAgainBtn.
  ///
  /// In en, this message translates to:
  /// **'Move In Again'**
  String get moveInAgainBtn;

  /// No description provided for @selectRoomToMoveInHint.
  ///
  /// In en, this message translates to:
  /// **'Select a room to move this tenant in'**
  String get selectRoomToMoveInHint;

  /// No description provided for @deleteTenantTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Tenant?'**
  String get deleteTenantTitle;

  /// No description provided for @deleteBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteBtn;

  /// No description provided for @currentLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocationLabel;

  /// No description provided for @unableToLoadImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load image'**
  String get unableToLoadImage;

  /// No description provided for @imageFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image file not found'**
  String get imageFileNotFound;

  /// No description provided for @occupancyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Occupancy History'**
  String get occupancyHistoryTitle;

  /// No description provided for @noOccupancyHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No occupancy history yet'**
  String get noOccupancyHistoryYet;

  /// No description provided for @familyMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembersTitle;

  /// No description provided for @addFamilyMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Family Member'**
  String get addFamilyMemberTitle;

  /// No description provided for @familyMembersActiveOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Family members can only be added to active occupancies'**
  String get familyMembersActiveOnlyHint;

  /// No description provided for @deleteFamilyMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Family Member?'**
  String get deleteFamilyMemberTitle;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @familyMemberDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Family member deleted'**
  String get familyMemberDeletedSuccess;

  /// No description provided for @spouseLabel.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouseLabel;

  /// No description provided for @childLabel.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get childLabel;

  /// No description provided for @parentLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parentLabel;

  /// No description provided for @siblingLabel.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get siblingLabel;

  /// No description provided for @nameAndRelationshipRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and relationship are required'**
  String get nameAndRelationshipRequired;

  /// No description provided for @familyMemberAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Family member added!'**
  String get familyMemberAddedSuccess;

  /// No description provided for @customFieldsTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Fields'**
  String get customFieldsTitle;

  /// No description provided for @noCustomFields.
  ///
  /// In en, this message translates to:
  /// **'No custom fields'**
  String get noCustomFields;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @noDocumentsAttached.
  ///
  /// In en, this message translates to:
  /// **'No documents attached.'**
  String get noDocumentsAttached;

  /// No description provided for @deleteDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Document?'**
  String get deleteDocumentTitle;

  /// No description provided for @confirmDeleteDocumentPrefix.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete '**
  String get confirmDeleteDocumentPrefix;

  /// No description provided for @documentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeletedSuccess;

  /// No description provided for @fieldNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldNameLabel;

  /// No description provided for @fieldValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get fieldValueLabel;

  /// No description provided for @zeroAmount.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get zeroAmount;

  /// No description provided for @letsMakeItProfessionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make it professional!'**
  String get letsMakeItProfessionalTitle;

  /// No description provided for @addNameUpiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your billing profile to issue professional receipts to your tenants.'**
  String get addNameUpiSubtitle;

  /// No description provided for @continueToBillBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue to Bill'**
  String get continueToBillBtn;

  /// No description provided for @yourNameBusinessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name or Business Name'**
  String get yourNameBusinessNameLabel;

  /// No description provided for @upiIdOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get upiIdOptionalLabel;

  /// No description provided for @upiInvoiceHelperText.
  ///
  /// In en, this message translates to:
  /// **'Adds a scannable QR code to your invoices, making it 3x faster for tenants to pay you directly.'**
  String get upiInvoiceHelperText;

  /// No description provided for @occupancyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Details'**
  String get occupancyDetailsTitle;

  /// No description provided for @shareFunctionalityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Share functionality coming soon'**
  String get shareFunctionalityComingSoon;

  /// No description provided for @occupancyNotFound.
  ///
  /// In en, this message translates to:
  /// **'Occupancy not found'**
  String get occupancyNotFound;

  /// No description provided for @viewSettlementReceiptBtn.
  ///
  /// In en, this message translates to:
  /// **'View Settlement Receipt'**
  String get viewSettlementReceiptBtn;

  /// No description provided for @enterPaymentAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount (₹)'**
  String get enterPaymentAmountLabel;

  /// No description provided for @shareTextBtn.
  ///
  /// In en, this message translates to:
  /// **'Share Text'**
  String get shareTextBtn;

  /// No description provided for @pdfInvoiceBtn.
  ///
  /// In en, this message translates to:
  /// **'PDF Invoice'**
  String get pdfInvoiceBtn;

  /// No description provided for @messageCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Message copied to clipboard!'**
  String get messageCopiedSuccess;

  /// No description provided for @generatingPdfMsg.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdfMsg;

  /// No description provided for @noPaymentsRecordedMsg.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded yet'**
  String get noPaymentsRecordedMsg;

  /// No description provided for @paymentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment deleted'**
  String get paymentDeletedSuccess;

  /// No description provided for @enterValidAmountMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterValidAmountMsg;

  /// No description provided for @paymentUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment updated'**
  String get paymentUpdatedSuccess;

  /// No description provided for @noNotificationsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No notifications scheduled.'**
  String get noNotificationsScheduled;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorGeneric;

  /// No description provided for @chooseFromGalleryBtn.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGalleryBtn;

  /// No description provided for @sharePaymentLinkBtn.
  ///
  /// In en, this message translates to:
  /// **'Share Payment Link'**
  String get sharePaymentLinkBtn;

  /// No description provided for @meterTrackingExplanation.
  ///
  /// In en, this message translates to:
  /// **'Enter readings to automatically calculate electricity charges based on your configured rate.'**
  String get meterTrackingExplanation;

  /// No description provided for @archiveProperty.
  ///
  /// In en, this message translates to:
  /// **'Archive Property'**
  String get archiveProperty;

  /// No description provided for @unarchiveProperty.
  ///
  /// In en, this message translates to:
  /// **'Unarchive Property'**
  String get unarchiveProperty;

  /// No description provided for @archiveRoom.
  ///
  /// In en, this message translates to:
  /// **'Archive Room'**
  String get archiveRoom;

  /// No description provided for @unarchiveRoom.
  ///
  /// In en, this message translates to:
  /// **'Unarchive Room'**
  String get unarchiveRoom;

  /// No description provided for @archiveTenant.
  ///
  /// In en, this message translates to:
  /// **'Archive Tenant'**
  String get archiveTenant;

  /// No description provided for @unarchiveTenant.
  ///
  /// In en, this message translates to:
  /// **'Unarchive Tenant'**
  String get unarchiveTenant;

  /// No description provided for @showArchived.
  ///
  /// In en, this message translates to:
  /// **'Show Archived'**
  String get showArchived;

  /// No description provided for @hideArchived.
  ///
  /// In en, this message translates to:
  /// **'Hide Archived'**
  String get hideArchived;

  /// No description provided for @archivedBadge.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedBadge;

  /// No description provided for @validatePhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validatePhoneRequired;

  /// No description provided for @validatePhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
  String get validatePhoneInvalid;

  /// No description provided for @validateUpiInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid UPI ID (e.g., name@upi)'**
  String get validateUpiInvalid;

  /// No description provided for @validateAadharInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 12-digit Aadhar number'**
  String get validateAadharInvalid;

  /// No description provided for @validateRequiredField.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String validateRequiredField(String fieldName);

  /// No description provided for @validatePositiveNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid positive number'**
  String get validatePositiveNumberInvalid;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @pastStayStatus.
  ///
  /// In en, this message translates to:
  /// **'Past Stay'**
  String get pastStayStatus;

  /// No description provided for @billsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bill} other{{count} bills}}'**
  String billsCount(int count);

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'NET PROFIT'**
  String get netProfit;

  /// No description provided for @netLoss.
  ///
  /// In en, this message translates to:
  /// **'NET LOSS'**
  String get netLoss;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'PAID'**
  String get statusPaid;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'OVERDUE'**
  String get statusOverdue;

  /// No description provided for @amountSettled.
  ///
  /// In en, this message translates to:
  /// **'Amount Settled'**
  String get amountSettled;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get amountDue;

  /// No description provided for @expiredDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Expired {days} days ago'**
  String expiredDaysAgo(int days);

  /// No description provided for @expiringInDays.
  ///
  /// In en, this message translates to:
  /// **'Expiring in {days} days'**
  String expiringInDays(int days);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get fieldRequired;

  /// No description provided for @financialYearPrefix.
  ///
  /// In en, this message translates to:
  /// **'FY '**
  String get financialYearPrefix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
