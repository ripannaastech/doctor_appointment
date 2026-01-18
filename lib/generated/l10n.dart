// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `hello`
  String get hello {
    return Intl.message('hello', name: 'hello', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message('Version', name: 'version', desc: '', args: []);
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email and password`
  String get loginHeadline {
    return Intl.message(
      'Please enter your email and password',
      name: 'loginHeadline',
      desc: '',
      args: [],
    );
  }

  /// `Book Appointment`
  String get bookAppointment {
    return Intl.message(
      'Book Appointment',
      name: 'bookAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Select Doctor`
  String get selectDoctor {
    return Intl.message(
      'Select Doctor',
      name: 'selectDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Search doctor`
  String get searchDoctor {
    return Intl.message(
      'Search doctor',
      name: 'searchDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Dr. Mohamed Ali`
  String get doctor1Name {
    return Intl.message(
      'Dr. Mohamed Ali',
      name: 'doctor1Name',
      desc: '',
      args: [],
    );
  }

  /// `Senior Cardiologist`
  String get doctor1Specialty {
    return Intl.message(
      'Senior Cardiologist',
      name: 'doctor1Specialty',
      desc: '',
      args: [],
    );
  }

  /// `Dr. Fatima Ahmed`
  String get doctor2Name {
    return Intl.message(
      'Dr. Fatima Ahmed',
      name: 'doctor2Name',
      desc: '',
      args: [],
    );
  }

  /// `Cardiologist`
  String get doctor2Specialty {
    return Intl.message(
      'Cardiologist',
      name: 'doctor2Specialty',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Confirmed!`
  String get appointmentConfirmed {
    return Intl.message(
      'Appointment Confirmed!',
      name: 'appointmentConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Your appointment has been\nsuccessfully booked`
  String get appointmentSuccessfullyBooked {
    return Intl.message(
      'Your appointment has been\nsuccessfully booked',
      name: 'appointmentSuccessfullyBooked',
      desc: '',
      args: [],
    );
  }

  /// `Back To Home`
  String get backToHome {
    return Intl.message('Back To Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Department:`
  String get department {
    return Intl.message('Department:', name: 'department', desc: '', args: []);
  }

  /// `Cardiology`
  String get cardiology {
    return Intl.message('Cardiology', name: 'cardiology', desc: '', args: []);
  }

  /// `Doctor`
  String get doctor {
    return Intl.message('Doctor', name: 'doctor', desc: '', args: []);
  }

  /// `Date:`
  String get date {
    return Intl.message('Date:', name: 'date', desc: '', args: []);
  }

  /// `Time:`
  String get time {
    return Intl.message('Time:', name: 'time', desc: '', args: []);
  }

  /// `My Appointment`
  String get myAppointment {
    return Intl.message(
      'My Appointment',
      name: 'myAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming`
  String get upcoming {
    return Intl.message('Upcoming', name: 'upcoming', desc: '', args: []);
  }

  /// `Past`
  String get past {
    return Intl.message('Past', name: 'past', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Dermatologist`
  String get dermatologist {
    return Intl.message(
      'Dermatologist',
      name: 'dermatologist',
      desc: '',
      args: [],
    );
  }

  /// `Dr. Hassan Omar`
  String get drHassanOmar {
    return Intl.message(
      'Dr. Hassan Omar',
      name: 'drHassanOmar',
      desc: '',
      args: [],
    );
  }

  /// `Pediatrician`
  String get pediatrician {
    return Intl.message(
      'Pediatrician',
      name: 'pediatrician',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Dr. Ahmed Hassan`
  String get drAhmedHassan {
    return Intl.message(
      'Dr. Ahmed Hassan',
      name: 'drAhmedHassan',
      desc: '',
      args: [],
    );
  }

  /// `General Physician`
  String get generalPhysician {
    return Intl.message(
      'General Physician',
      name: 'generalPhysician',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Dr. Khadija Yusuf`
  String get drKhadijaYusuf {
    return Intl.message(
      'Dr. Khadija Yusuf',
      name: 'drKhadijaYusuf',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message('Select Date', name: 'selectDate', desc: '', args: []);
  }

  /// `Sun`
  String get sun {
    return Intl.message('Sun', name: 'sun', desc: '', args: []);
  }

  /// `Mon`
  String get mon {
    return Intl.message('Mon', name: 'mon', desc: '', args: []);
  }

  /// `Tue`
  String get tue {
    return Intl.message('Tue', name: 'tue', desc: '', args: []);
  }

  /// `Wed`
  String get wed {
    return Intl.message('Wed', name: 'wed', desc: '', args: []);
  }

  /// `Thu`
  String get thu {
    return Intl.message('Thu', name: 'thu', desc: '', args: []);
  }

  /// `Select Time Slot`
  String get selectTimeSlot {
    return Intl.message(
      'Select Time Slot',
      name: 'selectTimeSlot',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Booking`
  String get confirmBooking {
    return Intl.message(
      'Confirm Booking',
      name: 'confirmBooking',
      desc: '',
      args: [],
    );
  }

  /// `Log in to your account`
  String get logInToYourAccount {
    return Intl.message(
      'Log in to your account',
      name: 'logInToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back! Please enter your details.`
  String get welcomeBackPleaseEnterYourDetails {
    return Intl.message(
      'Welcome Back! Please enter your details.',
      name: 'welcomeBackPleaseEnterYourDetails',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter phone number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message('Welcome!', name: 'welcome', desc: '', args: []);
  }

  /// `Please complete your profile`
  String get pleaseCompleteYourProfile {
    return Intl.message(
      'Please complete your profile',
      name: 'pleaseCompleteYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Enter your full name`
  String get enterYourFullName {
    return Intl.message(
      'Enter your full name',
      name: 'enterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of Birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Language`
  String get preferredLanguage {
    return Intl.message(
      'Preferred Language',
      name: 'preferredLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Somali`
  String get somali {
    return Intl.message('Somali', name: 'somali', desc: '', args: []);
  }

  /// `Complete Registration`
  String get completeRegistration {
    return Intl.message(
      'Complete Registration',
      name: 'completeRegistration',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message('Log In', name: 'logIn', desc: '', args: []);
  }

  /// `OTP Verification`
  String get otpVerification {
    return Intl.message(
      'OTP Verification',
      name: 'otpVerification',
      desc: '',
      args: [],
    );
  }

  /// `An authentication code has been sent to\n+01846786763`
  String get authenticationCodeSent {
    return Intl.message(
      'An authentication code has been sent to\n+01846786763',
      name: 'authenticationCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Didn’t receive code? 1:30`
  String get didNotReceiveCode {
    return Intl.message(
      'Didn’t receive code? 1:30',
      name: 'didNotReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Appointment`
  String get appointment {
    return Intl.message('Appointment', name: 'appointment', desc: '', args: []);
  }

  /// `Pharmacy`
  String get pharmacy {
    return Intl.message('Pharmacy', name: 'pharmacy', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Good Morning!`
  String get goodMorning {
    return Intl.message(
      'Good Morning!',
      name: 'goodMorning',
      desc: '',
      args: [],
    );
  }

  /// `My Appointments`
  String get myAppointments {
    return Intl.message(
      'My Appointments',
      name: 'myAppointments',
      desc: '',
      args: [],
    );
  }

  /// `My Results`
  String get myResults {
    return Intl.message('My Results', name: 'myResults', desc: '', args: []);
  }

  /// `See all`
  String get seeAll {
    return Intl.message('See all', name: 'seeAll', desc: '', args: []);
  }

  /// `Need Help?`
  String get needHelp {
    return Intl.message('Need Help?', name: 'needHelp', desc: '', args: []);
  }

  /// `We're here for you 24/7`
  String get wereHereForYou247 {
    return Intl.message(
      'We\'re here for you 24/7',
      name: 'wereHereForYou247',
      desc: '',
      args: [],
    );
  }

  /// `Call Us`
  String get callUs {
    return Intl.message('Call Us', name: 'callUs', desc: '', args: []);
  }

  /// `WhatsApp`
  String get whatsApp {
    return Intl.message('WhatsApp', name: 'whatsApp', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Unread`
  String get unread {
    return Intl.message('Unread', name: 'unread', desc: '', args: []);
  }

  /// `Appointment Details`
  String get appointmentDetails {
    return Intl.message(
      'Appointment Details',
      name: 'appointmentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Expert Medical Care`
  String get expertMedicalCare {
    return Intl.message(
      'Expert Medical Care',
      name: 'expertMedicalCare',
      desc: '',
      args: [],
    );
  }

  /// `Psychiatrist`
  String get psychiatrist {
    return Intl.message(
      'Psychiatrist',
      name: 'psychiatrist',
      desc: '',
      args: [],
    );
  }

  /// `09:00 AM - 11:30 AM`
  String get morningTime {
    return Intl.message(
      '09:00 AM - 11:30 AM',
      name: 'morningTime',
      desc: '',
      args: [],
    );
  }

  /// `Tue, 29 Jun, 2025`
  String get appointmentDate {
    return Intl.message(
      'Tue, 29 Jun, 2025',
      name: 'appointmentDate',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
