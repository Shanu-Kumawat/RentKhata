// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RentKhata';

  @override
  String get welcomeTitle => 'Effortless Rent Management';

  @override
  String get welcomeSubtitle =>
      'Track tenants, bills, and payments in one beautifully secure, offline ledger.';

  @override
  String get startOrganizing => 'Start Organizing';

  @override
  String get settings => 'Settings';

  @override
  String get setUpProfile => 'Set up profile';

  @override
  String get loading => 'Loading...';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get security => 'Security';

  @override
  String get appLock => 'App Lock';

  @override
  String get biometricAuthentication => 'Biometric authentication';

  @override
  String get billingAndCycles => 'Billing & Cycles';

  @override
  String get dateToDateBilling => 'Date-to-Date Billing';

  @override
  String get configureBillingCycles => 'Configure billing cycles and due dates';

  @override
  String get billing => 'Billing';

  @override
  String get electricityRates => 'Electricity Rates';

  @override
  String get viewAndUpdateElectricityRates =>
      'View and update electricity rates';

  @override
  String get messageTemplates => 'Message Templates';

  @override
  String get customizeInvoice => 'Customize invoice and receipt messages';

  @override
  String get notifications => 'Notifications';

  @override
  String get reminderSettings => 'Reminder Settings';

  @override
  String get dueDateAndOverdue => 'Due date and overdue reminders';

  @override
  String get data => 'Data';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get saveOrRestoreData => 'Save or restore your data';

  @override
  String get about => 'About';

  @override
  String get aboutRentKhata => 'About RentKhata';

  @override
  String get offlineFirstRentalApp =>
      'Offline-first rental management app for Indian landlords.';

  @override
  String get tapToAddUpiId => 'Tap to add UPI ID';

  @override
  String get reports => 'Reports';

  @override
  String get attentionNeeded => 'Attention Needed';

  @override
  String get livePropertyStatus => 'Live Property Status';

  @override
  String get addProperty => 'Add Property';

  @override
  String get addTenant => 'Add Tenant';

  @override
  String get createBill => 'Create Bill';

  @override
  String get goToRoomToCreateBills => 'Go to a room to create bills';

  @override
  String get pendingInvoices => 'Pending Invoices';

  @override
  String tenantsNeedBills(int count) {
    return '$count tenants need bills created';
  }

  @override
  String get collectPayments => 'Collect Payments';

  @override
  String billsAwaitPayment(int count) {
    return '$count generated bills await payment';
  }

  @override
  String get renewAgreements => 'Renew Agreements';

  @override
  String agreementsExpiring(int count) {
    return '$count agreements expiring soon';
  }

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get noBillingCyclesEnding => 'No billing cycles ending soon';

  @override
  String get noActiveRooms => 'No active rooms found';

  @override
  String get tenants => 'Tenants';

  @override
  String get searchByNameOrPhone => 'Search by name or phone...';

  @override
  String get noTenantsYet => 'No tenants yet';

  @override
  String get noTenantsFound => 'No tenants found';

  @override
  String get tenantsAppearHereAfterMoveIn =>
      'Tenants will appear here after you move them into a room';

  @override
  String get tryDifferentSearchTerm => 'Try a different search term';

  @override
  String get current => 'Current';

  @override
  String get past => 'Past';

  @override
  String get property => 'Property';

  @override
  String get na => 'N/A';

  @override
  String get tenantDetail => 'Tenant Detail';

  @override
  String get tenantNotFound => 'Tenant not found';

  @override
  String get deleteTenant => 'Delete Tenant';

  @override
  String get personalDetails => 'Personal Details';

  @override
  String get fathersName => 'Father\'s Name';

  @override
  String get age => 'Age';

  @override
  String years(int count) {
    return '$count years';
  }

  @override
  String get gender => 'Gender';

  @override
  String get contactInformation => 'Contact Information';

  @override
  String get phone => 'Phone';

  @override
  String get secondaryPhone => 'Secondary Phone';

  @override
  String get aadhaar => 'Aadhaar';

  @override
  String get permanentAddress => 'Permanent Address';

  @override
  String get address => 'Address';

  @override
  String get cityState => 'City, State';

  @override
  String get pincode => 'Pincode';

  @override
  String get workDetails => 'Work Details';

  @override
  String get company => 'Company';

  @override
  String get officeAddress => 'Office Address';

  @override
  String get introducerReference => 'Introducer / Reference';

  @override
  String get name => 'Name';

  @override
  String get overview => 'Overview';

  @override
  String get pending => 'Pending';

  @override
  String get history => 'History';

  @override
  String get expenses => 'Expenses';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get financialSummary => 'Financial Summary';

  @override
  String get outstanding => 'Outstanding';

  @override
  String get overdue => 'Overdue';

  @override
  String get collected => 'Collected';

  @override
  String urgent(int count) {
    return '$count urgent';
  }

  @override
  String get allOnTime => 'All on time';

  @override
  String items(int count) {
    return '$count items';
  }

  @override
  String get errorLoadingBills => 'Error loading bills';

  @override
  String get errorLoadingExpenses => 'Error loading expenses';

  @override
  String get errorLoadingFinancials => 'Error loading financials';

  @override
  String get billsByType => 'Bills by Type';

  @override
  String get properties => 'Properties';

  @override
  String get retry => 'Retry';

  @override
  String get noPropertiesYet => 'No properties yet';

  @override
  String get addYourFirstProperty => 'Add your first property to get started';

  @override
  String roomsCount(int count) {
    return '$count rooms';
  }

  @override
  String occupiedPercent(int percent) {
    return '$percent% occupied';
  }

  @override
  String get propertyNotFound => 'Property not found';

  @override
  String get deleteProperty => 'Delete Property';

  @override
  String get noRoomsYet => 'No rooms yet';

  @override
  String get addRoomsToStartManaging => 'Add rooms to start managing tenants';

  @override
  String get addRoom => 'Add Room';

  @override
  String get deletePropertyTitle => 'Delete Property?';

  @override
  String confirmDeleteProperty(String propertyName) {
    return 'Are you sure you want to delete \"$propertyName\"? This will also delete all rooms in this property.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get propertyDeleted => 'Property deleted';

  @override
  String occupancyCount(int count) {
    return '$count occupied';
  }

  @override
  String roomNumber(String number) {
    return 'Room $number';
  }

  @override
  String get vacant => 'Vacant';

  @override
  String get perMonth => '/month';

  @override
  String get billDetails => 'Bill Details';

  @override
  String get editBill => 'Edit Bill';

  @override
  String get deleteBill => 'Delete Bill';

  @override
  String get voidBill => 'Void Bill';

  @override
  String get sendReminder => 'Send Reminder';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get noPaymentsRecorded => 'No payments recorded';

  @override
  String get notes => 'Notes';

  @override
  String get reviewAndSend => 'Review & Send';

  @override
  String get shareInvoice => 'Share Invoice';

  @override
  String payAmount(String amount) {
    return 'Pay $amount';
  }

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get saveInvoicePdf => 'Save Invoice PDF';

  @override
  String get voidBillTitle => 'Void Bill?';

  @override
  String get voidBillWarning =>
      'This will mark the bill as void. This action cannot be undone.';

  @override
  String get voidReasonLabel => 'Reason for voiding';

  @override
  String get voidReasonHint => 'e.g., Incorrect amount';

  @override
  String get billMarkedVoid => 'Bill marked as Void';

  @override
  String get deleteBillTitle => 'Delete Bill?';

  @override
  String confirmDeleteBill(String billType, String period) {
    return 'Are you sure you want to delete this $billType bill for $period?\n\nThis action cannot be undone.';
  }

  @override
  String get billDeleted => 'Bill deleted';

  @override
  String errorDeletingBill(String error) {
    return 'Error deleting bill: $error';
  }

  @override
  String get overdueU => 'OVERDUE';

  @override
  String get total => 'Total';

  @override
  String get paid => 'Paid';

  @override
  String get pendingTitle => 'Pending';

  @override
  String get draft => 'DRAFT';

  @override
  String get sent => 'Sent';

  @override
  String get partiallyPaid => 'Partially Paid';

  @override
  String get overdueBill => 'Overdue';

  @override
  String get voided => 'Voided';

  @override
  String get billNumber => 'Bill Number';

  @override
  String get notAssigned => 'Not assigned';

  @override
  String get type => 'Type';

  @override
  String get billingPeriod => 'Billing Period';

  @override
  String get dueDate => 'Due Date';

  @override
  String get room => 'Room';

  @override
  String get tenant => 'Tenant';

  @override
  String get created => 'Created';

  @override
  String get monthlyRent => 'Monthly Rent';

  @override
  String get electricityBill => 'Electricity Bill';

  @override
  String get waterBill => 'Water Bill';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get otherCharges => 'Other Charges';

  @override
  String get electricityDetails => 'Electricity Details';

  @override
  String get previous => 'Previous';

  @override
  String get meterPhoto => 'Meter Photo';

  @override
  String get tapToViewFullSize => 'Tap to view full size';

  @override
  String get addMeterPhoto => 'Add Meter Photo';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get meterPhotoAdded => 'Meter photo added successfully';

  @override
  String errorAddingPhoto(String error) {
    return 'Error adding photo: $error';
  }

  @override
  String get editPayment => 'Edit Payment';

  @override
  String get deletePayment => 'Delete Payment';

  @override
  String get deletePaymentTitle => 'Delete Payment?';

  @override
  String confirmDeletePayment(String amount, String date) {
    return 'Delete payment of $amount made on $date?\n\nThis will update the bill balance.';
  }

  @override
  String get paymentDeleted => 'Payment deleted';

  @override
  String get cash => 'Cash';

  @override
  String get upi => 'UPI';

  @override
  String get bankTransfer => 'Bank Transfer';

  @override
  String get cheque => 'Cheque';

  @override
  String get other => 'Other';

  @override
  String get auditHistory => 'Audit History';

  @override
  String get noChangesRecorded => 'No changes recorded';

  @override
  String get updated => 'Updated';

  @override
  String get deleted => 'Deleted';

  @override
  String get billAlreadyExists => 'Bill Already Exists';

  @override
  String duplicateBillMessage(
    String type,
    String month,
    int year,
    String number,
  ) {
    return 'A $type bill for $month $year already exists ($number).\n\nDo you want to create another bill anyway?';
  }

  @override
  String get createAnyway => 'Create Anyway';

  @override
  String get billCreated => 'Bill created';

  @override
  String billCreatedWithRate(String rate) {
    return 'Bill created. Global rate updated to ₹$rate/unit';
  }

  @override
  String get meterReadings => 'Meter Readings';

  @override
  String get currentReading => 'Current reading';

  @override
  String get ratePerUnit => 'Rate per unit:';

  @override
  String get electricityCalculation => 'Electricity Calculation';

  @override
  String get units => 'units';

  @override
  String unitsCalculation(String units, String rate) {
    return '$units units × $rate';
  }

  @override
  String get optionalVerification => 'Optional - helps with verification';

  @override
  String get tapToChangePhoto => 'Tap to change photo';

  @override
  String get billAmountLabel => 'Bill Amount (₹) *';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get dateToDate => 'Date-to-Date';

  @override
  String get advance => 'Advance';

  @override
  String get currentLabel => 'Current';

  @override
  String cycleExceedsAgreementWarning(String date) {
    return 'This cycle exceeds the agreement end date ($date)';
  }

  @override
  String amountCannotBeLessThanPaid(String amount) {
    return 'Amount cannot be less than paid amount of $amount';
  }

  @override
  String get billUpdatedSuccessfully => 'Bill updated successfully';

  @override
  String get partiallyPaidBillWarning =>
      'This bill has received payments. Amount can only be increased. It cannot be less than paid amount.';

  @override
  String paidAmount(String amount) {
    return 'Paid: $amount';
  }

  @override
  String minAmount(String amount) {
    return 'Min amount: $amount';
  }

  @override
  String get notSet => 'Not set';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get amountLabel => 'Amount';

  @override
  String amountCannotExceedPendingBalance(String amount) {
    return 'Amount cannot exceed pending balance of $amount';
  }

  @override
  String get recordPayment => 'Record Payment';

  @override
  String dueAmount(String amount) {
    return 'Due: $amount';
  }

  @override
  String get enterAmount => 'Enter Amount';

  @override
  String get payFullDue => 'Pay Full Due';

  @override
  String get date => 'Date';

  @override
  String get addNoteOptional => 'Add note (optional)';

  @override
  String get paymentComplete => 'Payment Complete!';

  @override
  String get paymentRecorded => 'Payment Recorded';

  @override
  String get billFullyPaidLabel => 'Bill has been fully paid';

  @override
  String get partialPaymentRecorded => 'Partial payment recorded';

  @override
  String get invoiceLabel => 'Invoice';

  @override
  String get periodLabel => 'Period';

  @override
  String get roomLabel => 'Room';

  @override
  String get paymentAmountLabel => 'Payment Amount';

  @override
  String get paymentModeLabel => 'Payment Mode';

  @override
  String get billTotalLabel => 'Bill Total';

  @override
  String get paidLabel => 'Paid';

  @override
  String get balanceLabel => 'Balance';

  @override
  String get closeLabel => 'Close';

  @override
  String get electricity => 'Electricity';

  @override
  String get water => 'Water';

  @override
  String amountCannotExceedMax(String amount) {
    return 'Amount cannot exceed $amount';
  }

  @override
  String get paymentUpdated => 'Payment updated';

  @override
  String originalAmount(String amount) {
    return 'Original: $amount';
  }

  @override
  String get paymentAmountRequiredLabel => 'Payment Amount (₹) *';

  @override
  String get paymentDateLabel => 'Payment Date';

  @override
  String get notesOptionalLabel => 'Notes (optional)';

  @override
  String get updatePayment => 'Update Payment';

  @override
  String get invoicePreview => 'Invoice Preview';

  @override
  String get viewPdf => 'View PDF';

  @override
  String errorPreviewingPdf(String error) {
    return 'Error previewing PDF: $error';
  }

  @override
  String errorSharingPdf(String error) {
    return 'Error sharing PDF: $error';
  }

  @override
  String invoiceNumber(String number) {
    return 'Invoice $number';
  }

  @override
  String get billTo => 'Bill To';

  @override
  String unitsAmount(String amount) {
    return '$amount units';
  }

  @override
  String unitsConsumedRate(String units, String rate) {
    return '$units units @ $rate/unit';
  }

  @override
  String get scanToPay => 'Scan to Pay';

  @override
  String generatedOn(String date) {
    return 'Generated on: $date';
  }

  @override
  String get sentStatus => 'SENT';

  @override
  String get partialStatus => 'PARTIAL';

  @override
  String get paidStatus => 'PAID';

  @override
  String get overdueStatus => 'OVERDUE';

  @override
  String get voidedStatus => 'VOIDED';

  @override
  String get landlord => 'Landlord';

  @override
  String get previousReading => 'Previous Reading';

  @override
  String get unitsConsumed => 'Units Consumed';

  @override
  String get notesLabel => 'Notes';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get balanceDueLabel => 'Balance Due';

  @override
  String get amount => 'Amount';

  @override
  String get invoiceSavedToDownloads => 'Invoice saved to Downloads';

  @override
  String get ok => 'OK';

  @override
  String errorSavingPdf(String error) {
    return 'Error saving PDF: $error';
  }

  @override
  String errorLoadingAuditLogs(String error) {
    return 'Error loading audit logs: $error';
  }

  @override
  String get previousCycle => 'Previous cycle';

  @override
  String get nextCycle => 'Next cycle';

  @override
  String get monthLabel => 'Month';

  @override
  String get yearLabel => 'Year';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get mayShort => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Aug';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Dec';

  @override
  String get roomTitle => 'Room';

  @override
  String get roomNotFound => 'Room not found';

  @override
  String get statementLabel => 'Statement';

  @override
  String get occupiedStatus => 'Occupied';

  @override
  String get moveOutBtn => 'Move Out';

  @override
  String get agreedRent => 'Agreed Rent';

  @override
  String get securityDepositLabel => 'Security Deposit';

  @override
  String get billingStartLabel => 'Billing Start';

  @override
  String get editBtn => 'Edit';

  @override
  String get selectBillingStartDate => 'Select Billing Start Date';

  @override
  String get failedToUpdateBillingStart =>
      'Failed to update billing start date';

  @override
  String get roomIsVacant => 'Room is Vacant';

  @override
  String get assignTenantToStartCollecting =>
      'Assign a tenant to start collecting rent';

  @override
  String get moveInTenantBtn => 'Move In Tenant';

  @override
  String get noBillsYet => 'No bills yet';

  @override
  String get activeBills => 'Active Bills';

  @override
  String get paidCaps => 'PAID';

  @override
  String get dueCaps => 'DUE';

  @override
  String get voidLabel => 'VOID';

  @override
  String get remindBtn => 'Remind';

  @override
  String get payNowBtn => 'Pay Now';

  @override
  String get viewBtn => 'View';

  @override
  String get shareBtn => 'Share';

  @override
  String get monthlyRentLabel => 'Monthly Rent';

  @override
  String get electricityBillLabel => 'Electricity Bill';

  @override
  String get waterBillLabel => 'Water Bill';

  @override
  String get maintenanceLabel => 'Maintenance';

  @override
  String get sendInvoiceBtn => 'Send Invoice';

  @override
  String viewBillHistory(int count) {
    return 'View Bill History ($count)';
  }

  @override
  String get otherChargesLabel => 'Other Charges';

  @override
  String get documentTitle => 'Document Title';

  @override
  String get addBtn => 'Add';

  @override
  String get pleaseSelectTenant => 'Please select a tenant';

  @override
  String get tenantMovedInSuccess => 'Tenant moved in successfully';

  @override
  String get incompleteProfile => 'Incomplete Profile';

  @override
  String get completeLaterMsg =>
      'Complete these later from the Edit Tenant page';

  @override
  String get goBack => 'Go Back';

  @override
  String get saveAnyway => 'Save Anyway';

  @override
  String get addFamilyMember => 'Add Family Member';

  @override
  String get spouse => 'Spouse';

  @override
  String get child => 'Child';

  @override
  String get parent => 'Parent';

  @override
  String get sibling => 'Sibling';

  @override
  String get otherRelation => 'Other';

  @override
  String get ageLabel => 'Age';

  @override
  String get genderLabel => 'Gender';

  @override
  String get maleLabel => 'Male';

  @override
  String get femaleLabel => 'Female';

  @override
  String get nameAndRelRequired => 'Name and relationship required';

  @override
  String get moveInTenantTitle => 'Move In Tenant';

  @override
  String get existingTenant => 'Existing Tenant';

  @override
  String get newTenant => 'New Tenant';

  @override
  String get essentialInfo => 'Essential Information';

  @override
  String get nameLabel => 'Name';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get addressLine => 'Address Line';

  @override
  String get cityLabel => 'City';

  @override
  String get stateLabel => 'State';

  @override
  String get pincodeLabel => 'Pincode';

  @override
  String get idDocuments => 'ID Documents';

  @override
  String get aadhaarNumber => 'Aadhaar Number';

  @override
  String get aadhaarCardPhotos => 'Aadhaar Card Photos';

  @override
  String get frontLabel => 'Front';

  @override
  String get backLabel => 'Back';

  @override
  String get policeVerificationStatus => 'Police Verification Status';

  @override
  String get clearBtn => 'Clear';

  @override
  String get takePhotoBtn => 'Take Photo';

  @override
  String get uploadGalleryBtn => 'Upload Gallery';

  @override
  String get addMemberMsg => 'Add Member';

  @override
  String get electricitySetup => 'Electricity Setup';

  @override
  String get currentMeterReading => 'Current Meter Reading';

  @override
  String get currentRatePerUnit => 'Current Rate per Unit';

  @override
  String get aadhaarFrontPhoto => 'Aadhaar Front Photo';

  @override
  String get aadhaarBackPhoto => 'Aadhaar Back Photo';

  @override
  String get companyName => 'Company Name';

  @override
  String get introducerName => 'Introducer Name';

  @override
  String get introducerAddress => 'Introducer Address';

  @override
  String get introducerPhone => 'Introducer Phone';

  @override
  String get additionalDocuments => 'Additional Documents';

  @override
  String get addDocumentBtn => 'Add Document';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get addNewBtn => 'Add New';

  @override
  String get noFamilyMembersYet => 'No family members added yet';

  @override
  String get selectTenant => 'Select Tenant';

  @override
  String get futureLabel => 'Future';

  @override
  String get startBillingFrom => 'Start Billing From';

  @override
  String get billsNotTrackedMsg => 'Bills before this date will not be tracked';

  @override
  String get autoLabel => 'Auto';

  @override
  String get noAgreementDateSet => 'No agreement date set';

  @override
  String get rent => 'Rent';

  @override
  String get pastTenant => 'Past Tenant';

  @override
  String get moveOutSettlement => 'Move Out Settlement';

  @override
  String get pendingBillsToDeduct => 'Pending Bills to Deduct';

  @override
  String get undoVoid => 'Undo Void';

  @override
  String get markAsVoid => 'Mark as Void';

  @override
  String get otherDeductionsTitle => 'Other Deductions';

  @override
  String get totalDeposit => 'Total Deposit';

  @override
  String get billDeductions => 'Bill Deductions';

  @override
  String get tenantOwes => 'Tenant Owes';

  @override
  String get refundableAmount => 'Refundable Amount';

  @override
  String get settledViaDeposit => 'Settled via Deposit Deduction';

  @override
  String get confirmMoveOutRecord => 'Confirm Move Out & Record Pending';

  @override
  String get confirmMoveOutSettle => 'Confirm Move Out & Settle';

  @override
  String get moveOutDate => 'Move Out Date';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get ledgerNotFound => 'Ledger not found';

  @override
  String get tenantT => 'T';

  @override
  String overdueByDays(int days) {
    return 'Overdue by $days days';
  }

  @override
  String amountDueSuffix(String amount) {
    return '$amount due';
  }

  @override
  String get khataStatement => 'KHATA STATEMENT';

  @override
  String get fromLabel => 'From:';

  @override
  String get toLabel => 'To:';

  @override
  String roomNoLabel(String roomNumber) {
    return 'Room No: $roomNumber';
  }

  @override
  String get totalBilledLabel => 'Total Billed';

  @override
  String get totalPaidLabel => 'Total Paid';

  @override
  String get dateLabel => 'Date';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get billedLabel => 'Billed';

  @override
  String advanceLabel(String amount) {
    return '$amount (Adv)';
  }

  @override
  String get systemGeneratedMsg =>
      'This is a system-generated statement and does not require a physical signature.';

  @override
  String get moveOutSettlementTitle => 'MOVE-OUT SETTLEMENT';

  @override
  String moveOutDateLabel(String date) {
    return 'Move Out Date: $date';
  }

  @override
  String moveInDateLabel(String date) {
    return 'Move In: $date';
  }

  @override
  String get initialSecurityDeposit => 'Initial Security Deposit';

  @override
  String get deductionsLabel => 'Deductions';

  @override
  String get amountDeductedLabel => 'Amount Deducted';

  @override
  String get finalRefundAmount => 'Final Refund Amount';

  @override
  String get amountTenantOwes => 'Amount Tenant Owes';

  @override
  String get accountSettledMsg => 'ACCOUNT SETTLED - NO CURRENT DUES';

  @override
  String get tenantSignature => 'Tenant Signature';

  @override
  String get landlordSignature => 'Landlord Signature';

  @override
  String get computerGeneratedMsg =>
      'This is a computer-generated statement and does not require a physical signature.';

  @override
  String get aboutLabel => 'About Label';

  @override
  String get aboutRentKhataDescription => 'About Rent Khata Description';

  @override
  String alertDaysBeforeCycle(int count) {
    return 'Alert $count days before';
  }

  @override
  String get dateToDateBillingByBillType => 'Date-to-Date Billing By Bill Type';

  @override
  String get dateToDateBillingSubtitle =>
      'Auto-calculate billing period based on move-in date.';

  @override
  String get backupAndRestoreSubtitle => 'Backup And Restore Subtitle';

  @override
  String get backupCreatedShare => 'Backup Created Share';

  @override
  String get backupInfoText => 'Backup Info Text';

  @override
  String get backupRestoredSuccess => 'Backup Restored Success';

  @override
  String get billDueSoon => 'Bill Due Soon';

  @override
  String get billFullyPaid => 'Bill Fully Paid';

  @override
  String get billFullyPaidSubtitle => 'Bill Fully Paid Subtitle';

  @override
  String get billingCycleEnding => 'Billing Cycle Ending';

  @override
  String get billingLabel => 'Billing Label';

  @override
  String get billingReminders => 'Billing Reminders';

  @override
  String get biometricFallbackInfo => 'Biometric Fallback Info';

  @override
  String get biometricLock => 'Biometric Lock';

  @override
  String get biometricLockSubtitle => 'Biometric Lock Subtitle';

  @override
  String get biometricsNotAvailable => 'Biometrics Not Available';

  @override
  String get changesSavedAutomatically => 'Changes Saved Automatically';

  @override
  String get createBackupToKeepSafe => 'Create Backup To Keep Safe';

  @override
  String get createShareBackup => 'Create Share Backup';

  @override
  String get criticalUrgentAttention => 'Critical Urgent Attention';

  @override
  String get currentRate => 'Current Rate';

  @override
  String get dataLabel => 'Data Label';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get deviceDoesNotSupportBiometrics =>
      'Device Does Not Support Biometrics';

  @override
  String get discard => 'Discard';

  @override
  String get dueDateOffsetSubtitle => 'Due Date Offset Subtitle';

  @override
  String dueDaysAfterCycle(int count) {
    return 'Due $count days after cycle ends';
  }

  @override
  String get dueSoonAlert => 'Due Soon Alert';

  @override
  String get dueSoonAlertSubtitle => 'Due Soon Alert Subtitle';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String effectiveFrom(String date) {
    return 'Effective from $date';
  }

  @override
  String get electricityMeterBills => 'Electricity Meter Bills';

  @override
  String get electricityRateInfoText => 'Electricity Rate Info Text';

  @override
  String get electricityRatesSubtitle => 'Electricity Rates Subtitle';

  @override
  String get enableAppLock => 'Enable App Lock';

  @override
  String get enterValidRate => 'Enter Valid Rate';

  @override
  String get firstReminderAfterDueDate => 'First Reminder After Due Date';

  @override
  String get generalSettingsLabel => 'General Settings Label';

  @override
  String get localBackups => 'Local Backups';

  @override
  String get lockAfterInactivity => 'Lock After Inactivity';

  @override
  String get lockOnExit => 'Lock On Exit';

  @override
  String get lockOnExitSubtitle => 'Lock On Exit Subtitle';

  @override
  String get maintenanceCharges => 'Maintenance Charges';

  @override
  String get messageBody => 'Message Body';

  @override
  String get messageTemplatesSubtitle => 'Message Templates Subtitle';

  @override
  String minutes(int count) {
    return '$count minutes';
  }

  @override
  String get mobileNumberHint => 'Mobile Number Hint';

  @override
  String get monthlyRentBills => 'Monthly Rent Bills';

  @override
  String get monthlySummary => 'Monthly Summary';

  @override
  String get monthlySummarySubtitle => 'Monthly Summary Subtitle';

  @override
  String get never => 'Never';

  @override
  String get noBiometricsEnrolled => 'No Biometrics Enrolled';

  @override
  String get noLocalBackups => 'No Local Backups';

  @override
  String get noRateHistory => 'No Rate History';

  @override
  String get notEnabled => 'Not Enabled';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get notificationsWorking => 'Notifications Working';

  @override
  String get oneDayOverdue => 'One Day Overdue';

  @override
  String get oneMinute => 'One Minute';

  @override
  String get oneWeekOverdue => 'One Week Overdue';

  @override
  String get overdueFollowUps => 'Overdue Follow Ups';

  @override
  String get paymentNotifications => 'Payment Notifications';

  @override
  String get paymentReceived => 'Payment Received';

  @override
  String get paymentReceivedSubtitle => 'Payment Received Subtitle';

  @override
  String get permissionDenied => 'Permission Denied';

  @override
  String get profileUpdated => 'Profile Updated';

  @override
  String get quietHours => 'Quiet Hours';

  @override
  String get rateHistory => 'Rate History';

  @override
  String get ratePerUnitLabel => 'Rate Per Unit Label';

  @override
  String get rateUpdated => 'Rate Updated';

  @override
  String get receiptLabel => 'Receipt Label';

  @override
  String remindDaysBeforeCycleEnds(int days) {
    return 'Remind $days days before cycle ends';
  }

  @override
  String remindDaysBeforeDueDate(int days) {
    return 'Remind $days days before due date';
  }

  @override
  String get reminderLabel => 'Reminder Label';

  @override
  String get reminderSettingsSubtitle => 'Reminder Settings Subtitle';

  @override
  String get requireBiometric => 'Require Biometric';

  @override
  String get resetBtn => 'Reset Btn';

  @override
  String get resetTemplateWarning => 'Reset Template Warning';

  @override
  String get resetToDefault => 'Reset To Default';

  @override
  String get restartNowBtn => 'Restart Now Btn';

  @override
  String get restoreBackupTitle => 'Restore Backup Title';

  @override
  String get restoreBackupWarning => 'Restore Backup Warning';

  @override
  String get restoreBtn => 'Restore Btn';

  @override
  String get restoreFailedPrefix => 'Restore Failed Prefix';

  @override
  String get restoreFromDevice => 'Restore From Device';

  @override
  String get restoreFromDeviceSubtitle => 'Restore From Device Subtitle';

  @override
  String get restoreSuccessTitle => 'Restore Success Title';

  @override
  String get saveDataToFile => 'Save Data To File';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get secondReminder => 'Second Reminder';

  @override
  String get sendTestNotification => 'Send Test Notification';

  @override
  String get setNewRate => 'Set New Rate';

  @override
  String get setupFingerprintFirst => 'Setup Fingerprint First';

  @override
  String get template => 'Template';

  @override
  String get templateAlreadyDefault => 'Template Already Default';

  @override
  String get templatePlaceholders => 'Template Placeholders';

  @override
  String get templateResetSuccess => 'Template Reset Success';

  @override
  String get templateSavedSuccess => 'Template Saved Success';

  @override
  String templateUsedWhenSharing(String type) {
    return 'Template used when sharing $type';
  }

  @override
  String get testNotificationTitle => 'Test Notification Title';

  @override
  String get threeDaysOverdue => 'Three Days Overdue';

  @override
  String get twoWeeksOverdue => 'Two Weeks Overdue';

  @override
  String get unit => 'Unit';

  @override
  String get updateRate => 'Update Rate';

  @override
  String get upiId => 'Upi Id';

  @override
  String get upiIdHelperText => 'Upi Id Helper Text';

  @override
  String get upiIdHint => 'Upi Id Hint';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get weeklyReminder => 'Weekly Reminder';

  @override
  String get yourName => 'Your Name';

  @override
  String get documentPdf => 'document.pdf';

  @override
  String errorSharingMessage(String error) {
    return 'Failed to share message: $error';
  }

  @override
  String get downloadsFolder => 'Downloads';

  @override
  String get savedToDownloads => 'Saved to Downloads';

  @override
  String savedToFolder(String folderName) {
    return 'Saved to $folderName';
  }

  @override
  String get couldNotSavePdf => 'Could not save the PDF. Please try again.';

  @override
  String get unableToLoadPdfPreview => 'Unable to load PDF preview';

  @override
  String get shareReceipt => 'Share Receipt';

  @override
  String get chooseHowToShare => 'Choose how you want to share';

  @override
  String get sendAsMessage => 'Send as Message';

  @override
  String get quickTextWithDetails => 'Quick text with details';

  @override
  String get sharePdf => 'Share PDF';

  @override
  String get formalDocument => 'Formal document';

  @override
  String errorGeneratingPdf(String error) {
    return 'Error generating PDF: $error';
  }

  @override
  String get paymentReceipt => 'Payment Receipt';

  @override
  String get notificationPermissionTitle => 'Never Miss a Payment';

  @override
  String get notificationPermissionBody =>
      'Never miss a payment! Want us to remind you when rent is due?';

  @override
  String get biometricPermissionTitle => 'Keep Ledger Secure';

  @override
  String get biometricPermissionBody =>
      'Keep your ledger secure. Would you like to lock RentKhata with your Fingerprint?';

  @override
  String get yesBtn => 'Yes';

  @override
  String get noBtn => 'No';

  @override
  String get notNowBtn => 'Not Now';

  @override
  String get systemNotificationsDisabledTitle =>
      'System Notifications Disabled';

  @override
  String get systemNotificationsDisabledBody =>
      'Enable notifications to receive rent alerts and payment reminders.';

  @override
  String get enableBtn => 'Enable';

  @override
  String get appLockEnabledSuccess => 'App Lock enabled successfully!';

  @override
  String get appLockSetupFailed => 'App Lock verification failed.';

  @override
  String get smartAlerts => 'Smart Alerts';

  @override
  String get agreementExpiredAlert => 'Agreement already expired';

  @override
  String agreementExpiredAlertSubtitle(int days) {
    return 'Remind after $days day(s) past agreement end date';
  }

  @override
  String get billNotGeneratedAlert => 'Bill not generated reminder';

  @override
  String billNotGeneratedAlertSubtitle(int days) {
    return 'Alert when cycle is overdue or within $days day(s) of ending';
  }

  @override
  String get partialPaymentPauseAlert =>
      'Pause overdue follow-ups after partial payment';

  @override
  String get partialPaymentPauseAlertSubtitle =>
      'Pauses escalations once paid amount reaches 50%';

  @override
  String get depositSettlementAlert => 'Deposit settlement due after move-out';

  @override
  String depositSettlementAlertSubtitle(int days) {
    return 'Remind after $days day(s) if settlement is pending';
  }

  @override
  String get depositStatus => 'Deposit Status';

  @override
  String get settledStatusCap => 'SETTLED';

  @override
  String get manualDeductions => 'Manual Deductions';

  @override
  String get finalRefund => 'Final Refund';

  @override
  String get amountOwed => 'Amount Owed';

  @override
  String get manualDeductionReason => 'Manual Deduction Reason';

  @override
  String get utilityAnomalyAlert => 'High utility usage anomaly';

  @override
  String get utilityAnomalyAlertSubtitle =>
      'Alerts when latest electricity usage spikes sharply';

  @override
  String get sameAsMoveIn => 'Same as move-in';

  @override
  String get selectBillToCollect =>
      'Select a bill below to review it and collect its pending payment.';

  @override
  String overdueSinceDate(String date) {
    return 'Overdue since $date';
  }

  @override
  String get awaitingPayment => 'Awaiting payment';

  @override
  String get unknownTenant => 'Unknown Tenant';

  @override
  String get unknownRoom => 'Unknown Room';

  @override
  String get collectLabel => 'Collect';
}
