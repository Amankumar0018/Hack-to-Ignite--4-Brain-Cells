import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'app_language.dart';

/// Centralized localization model providing typed strings for English, Hindi, and Marathi.
class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static final Map<String, AppLocalizations> _instances = {
    AppLanguage.english.code: AppLocalizations(AppLanguage.english),
    AppLanguage.hindi.code: AppLocalizations(AppLanguage.hindi),
    AppLanguage.marathi.code: AppLocalizations(AppLanguage.marathi),
  };

  /// Factory accessor for a given [Locale].
  static AppLocalizations ofLocale(Locale locale) {
    final lang = AppLanguage.fromLocale(locale);
    return _instances[lang.code] ?? _instances[AppLanguage.english.code]!;
  }

  /// Convenience accessor from [BuildContext].
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        _instances[AppLanguage.english.code]!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // ---------------------------------------------------------------------------
  // App Branding & Identity
  // ---------------------------------------------------------------------------
  String get appName => 'Pukaar';

  String get appTagline {
    switch (language) {
      case AppLanguage.hindi:
        return 'त्वरित सहायता, एकीकृत आपातकालीन प्रतिक्रिया';
      case AppLanguage.marathi:
        return 'त्वरित मदत, एकात्मिक आणीबाणी निवारण';
      case AppLanguage.english:
        return 'Instant Help, Unified Emergency Response';
    }
  }

  String get appDescription {
    switch (language) {
      case AppLanguage.hindi:
        return 'नागरिकों को त्वरित आपातकालीन सेवाओं से जोड़ने वाला स्मार्ट सुरक्षा मंच।';
      case AppLanguage.marathi:
        return 'नागरिकांना त्वरित आणीबाणी सेवांशी जोडणारे स्मार्ट सुरक्षा व्यासपीठ.';
      case AppLanguage.english:
        return 'Smart emergency coordination platform connecting citizens with rapid response services.';
    }
  }

  // ---------------------------------------------------------------------------
  // Core Safety Pillars / Emergency Categories
  // ---------------------------------------------------------------------------
  String get medicalEmergency {
    switch (language) {
      case AppLanguage.hindi:
        return 'चिकित्सा आपातकाल';
      case AppLanguage.marathi:
        return 'वैद्यकीय आणीबाणी';
      case AppLanguage.english:
        return 'Medical Emergency';
    }
  }

  String get medicalEmergencyDesc {
    switch (language) {
      case AppLanguage.hindi:
        return 'एम्बुलेंस, प्राथमिक चिकित्सा एवं गंभीर स्वास्थ्य सहायता';
      case AppLanguage.marathi:
        return 'रुग्णवाहिका, प्रथमोपचार आणि गंभीर आरोग्य सेवा मदत';
      case AppLanguage.english:
        return 'Ambulance, first aid, & critical healthcare support';
    }
  }

  String get womenSafety {
    switch (language) {
      case AppLanguage.hindi:
        return 'महिला सुरक्षा';
      case AppLanguage.marathi:
        return 'महिला सुरक्षा';
      case AppLanguage.english:
        return "Women's Safety";
    }
  }

  String get womenSafetyDesc {
    switch (language) {
      case AppLanguage.hindi:
        return 'त्वरित सहायता, एसओएस अलर्ट एवं सुरक्षित क्षेत्र मार्गदर्शन';
      case AppLanguage.marathi:
        return 'त्वरित मदत, एसओएस अलर्ट आणि सुरक्षित मार्ग दर्शन';
      case AppLanguage.english:
        return 'Urgent assistance, SOS alerts, & safe zone routing';
    }
  }

  String get disasterManagement {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपदा प्रबंधन';
      case AppLanguage.marathi:
        return 'आपत्ती व्यवस्थापन';
      case AppLanguage.english:
        return 'Disaster Management';
    }
  }

  String get disasterManagementDesc {
    switch (language) {
      case AppLanguage.hindi:
        return 'बाढ़, आग, भूकंप अलर्ट एवं बचाव अभियान';
      case AppLanguage.marathi:
        return 'पूर, आग, भूकंप चेतावणी आणि बचाव कार्य';
      case AppLanguage.english:
        return 'Flood, fire, earthquake alerts & rescue operations';
    }
  }

  String get campusEmergency {
    switch (language) {
      case AppLanguage.hindi:
        return 'परिसर आपातकाल';
      case AppLanguage.marathi:
        return 'कॅम्पस आणीबाणी';
      case AppLanguage.english:
        return 'Campus Emergency';
    }
  }

  String get campusEmergencyDesc {
    switch (language) {
      case AppLanguage.hindi:
        return 'सुरक्षा, त्वरित चेतावनी एवं विश्वविद्यालय घटना प्रतिक्रिया';
      case AppLanguage.marathi:
        return 'सुरक्षा, जलद इशारा आणि विद्यापीठ घटना निवारण';
      case AppLanguage.english:
        return 'Security, quick alert, & university incident response';
    }
  }

  // ---------------------------------------------------------------------------
  // Common Actions & Buttons
  // ---------------------------------------------------------------------------
  String get triggerSos {
    switch (language) {
      case AppLanguage.hindi:
        return 'एसओएस ट्रिगर करें';
      case AppLanguage.marathi:
        return 'एसओएस सुरू करा';
      case AppLanguage.english:
        return 'TRIGGER SOS';
    }
  }

  String get cancelSos {
    switch (language) {
      case AppLanguage.hindi:
        return 'एसओएस रद्द करें';
      case AppLanguage.marathi:
        return 'एसओएस रद्द करा';
      case AppLanguage.english:
        return 'Cancel SOS';
    }
  }

  String get login {
    switch (language) {
      case AppLanguage.hindi:
        return 'लॉग इन';
      case AppLanguage.marathi:
        return 'लॉग इन';
      case AppLanguage.english:
        return 'Log In';
    }
  }

  String get register {
    switch (language) {
      case AppLanguage.hindi:
        return 'पंजीकरण';
      case AppLanguage.marathi:
        return 'नोंदणी';
      case AppLanguage.english:
        return 'Register';
    }
  }

  String get signIn {
    switch (language) {
      case AppLanguage.hindi:
        return 'साइन इन';
      case AppLanguage.marathi:
        return 'साइन इन';
      case AppLanguage.english:
        return 'Sign In';
    }
  }

  String get signUp {
    switch (language) {
      case AppLanguage.hindi:
        return 'साइन अप';
      case AppLanguage.marathi:
        return 'साइन अप';
      case AppLanguage.english:
        return 'Sign Up';
    }
  }

  String get getStarted {
    switch (language) {
      case AppLanguage.hindi:
        return 'शुरू करें';
      case AppLanguage.marathi:
        return 'सुरू करा';
      case AppLanguage.english:
        return 'Get Started';
    }
  }

  String get continueText {
    switch (language) {
      case AppLanguage.hindi:
        return 'जारी रखें';
      case AppLanguage.marathi:
        return 'पुढे चला';
      case AppLanguage.english:
        return 'Continue';
    }
  }

  String get retry {
    switch (language) {
      case AppLanguage.hindi:
        return 'पुनः प्रयास करें';
      case AppLanguage.marathi:
        return 'पुन्हा प्रयत्न करा';
      case AppLanguage.english:
        return 'Retry';
    }
  }

  String get save {
    switch (language) {
      case AppLanguage.hindi:
        return 'सहेजें';
      case AppLanguage.marathi:
        return 'जतन करा';
      case AppLanguage.english:
        return 'Save';
    }
  }

  String get cancel {
    switch (language) {
      case AppLanguage.hindi:
        return 'रद्द करें';
      case AppLanguage.marathi:
        return 'रद्द करा';
      case AppLanguage.english:
        return 'Cancel';
    }
  }

  String get back {
    switch (language) {
      case AppLanguage.hindi:
        return 'पीछे';
      case AppLanguage.marathi:
        return 'मागे';
      case AppLanguage.english:
        return 'Back';
    }
  }

  String get skip {
    switch (language) {
      case AppLanguage.hindi:
        return 'छोड़ें';
      case AppLanguage.marathi:
        return 'वगळा';
      case AppLanguage.english:
        return 'Skip';
    }
  }

  String get signOut {
    switch (language) {
      case AppLanguage.hindi:
        return 'साइन आउट';
      case AppLanguage.marathi:
        return 'साइन आउट';
      case AppLanguage.english:
        return 'Sign Out';
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation & Screen Titles
  // ---------------------------------------------------------------------------
  String get home {
    switch (language) {
      case AppLanguage.hindi:
        return 'होम';
      case AppLanguage.marathi:
        return 'मुख्यपृष्ठ';
      case AppLanguage.english:
        return 'Home';
    }
  }

  String get emergency {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकाल';
      case AppLanguage.marathi:
        return 'आणीबाणी';
      case AppLanguage.english:
        return 'Emergency';
    }
  }

  String get profile {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रोफ़ाइल';
      case AppLanguage.marathi:
        return 'प्रोफाइल';
      case AppLanguage.english:
        return 'Profile';
    }
  }

  String get emergencyContacts {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन संपर्क';
      case AppLanguage.marathi:
        return 'आणीबाणी संपर्क';
      case AppLanguage.english:
        return 'Emergency Contacts';
    }
  }

  String get medicalId {
    switch (language) {
      case AppLanguage.hindi:
        return 'मेडिकल आईडी';
      case AppLanguage.marathi:
        return 'वैद्यकीय ओळखपत्र';
      case AppLanguage.english:
        return 'Medical ID';
    }
  }

  String get settings {
    switch (language) {
      case AppLanguage.hindi:
        return 'सेटिंग्स';
      case AppLanguage.marathi:
        return 'सेटिंग्ज';
      case AppLanguage.english:
        return 'Settings';
    }
  }

  String get responderDashboard {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रत्युत्तरकर्ता डैशबोर्ड';
      case AppLanguage.marathi:
        return 'मदतनीस डॅशबोर्ड';
      case AppLanguage.english:
        return 'Responder Dashboard';
    }
  }

  String get languageSelectionTitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'भाषा चुनें';
      case AppLanguage.marathi:
        return 'भाषा निवडा';
      case AppLanguage.english:
        return 'Select Language';
    }
  }

  // ---------------------------------------------------------------------------
  // UI States & Generic Feedback
  // ---------------------------------------------------------------------------
  String get loading {
    switch (language) {
      case AppLanguage.hindi:
        return 'लोड हो रहा है...';
      case AppLanguage.marathi:
        return 'लोड होत आहे...';
      case AppLanguage.english:
        return 'Loading...';
    }
  }

  String get noDataFound {
    switch (language) {
      case AppLanguage.hindi:
        return 'कोई रिकॉर्ड नहीं मिला';
      case AppLanguage.marathi:
        return 'कोणतीही नोंद आढळली नाही';
      case AppLanguage.english:
        return 'No records found';
    }
  }

  String get somethingWentWrong {
    switch (language) {
      case AppLanguage.hindi:
        return 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';
      case AppLanguage.marathi:
        return 'काहीतरी चूक झाली. कृपया पुन्हा प्रयत्न करा.';
      case AppLanguage.english:
        return 'Something went wrong. Please try again.';
    }
  }

  // ---------------------------------------------------------------------------
  // Onboarding Screen
  // ---------------------------------------------------------------------------
  String get welcomeToPukaar {
    switch (language) {
      case AppLanguage.hindi:
        return 'पुकार में आपका स्वागत है';
      case AppLanguage.marathi:
        return 'पुकार मध्ये आपले स्वागत आहे';
      case AppLanguage.english:
        return 'Welcome to Pukaar';
    }
  }

  String get onboardingSlide1Title {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन सहायता के लिए एक मंच।';
      case AppLanguage.marathi:
        return 'आणीबाणी मदतीसाठी एकच व्यासपीठ.';
      case AppLanguage.english:
        return 'One platform for emergency help.';
    }
  }

  String get onboardingSlide1Body {
    switch (language) {
      case AppLanguage.hindi:
        return 'पुकार एक स्मार्ट आपातकालीन प्रतिक्रिया प्रणाली है जो गंभीर परिस्थितियों में आपको सुरक्षित रखने के लिए बनाई गई है।';
      case AppLanguage.marathi:
        return 'पुकार ही एक स्मार्ट आणीबाणी प्रतिसाद प्रणाली आहे जी गंभीर परिस्थितीत आपल्याला सुरक्षित ठेवण्यासाठी तयार केली आहे.';
      case AppLanguage.english:
        return 'Pukaar is a smart emergency response framework tailored to keep you safe in critical situations.';
    }
  }

  String get onboardingSlide2Title {
    switch (language) {
      case AppLanguage.hindi:
        return 'चार मुख्य सुरक्षा स्तंभ';
      case AppLanguage.marathi:
        return 'चार मुख्य सुरक्षा स्तंभ';
      case AppLanguage.english:
        return 'Four Core Safety Pillars';
    }
  }

  String get onboardingSlide3Title {
    switch (language) {
      case AppLanguage.hindi:
        return 'सीधा संपर्क';
      case AppLanguage.marathi:
        return 'थेट संपर्क';
      case AppLanguage.english:
        return 'Direct Connections';
    }
  }

  String get onboardingSlide3Body {
    switch (language) {
      case AppLanguage.hindi:
        return 'हम संकट में फंसे व्यक्ति को तुरंत स्थानीय प्रत्युत्तरकर्ताओं, परिसर सुरक्षा और सार्वजनिक आपातकालीन सेवाओं से जोड़ते हैं।';
      case AppLanguage.marathi:
        return 'आम्ही संकटात असलेल्या व्यक्तीला त्वरित स्थानिक मदतनीस, कॅम्पस सुरक्षा आणि सार्वजनिक आणीबाणी सेवांशी जोडतो.';
      case AppLanguage.english:
        return 'We immediately connect a person in distress with appropriate local responders, campus security, and public emergency support services.';
    }
  }

  // ---------------------------------------------------------------------------
  // Authentication & Registration
  // ---------------------------------------------------------------------------
  String get welcomeBack {
    switch (language) {
      case AppLanguage.hindi:
        return 'वापसी पर स्वागत है';
      case AppLanguage.marathi:
        return 'पुन्हा स्वागत आहे';
      case AppLanguage.english:
        return 'Welcome Back';
    }
  }

  String get loginSubtitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'अपने पुकार आपातकालीन खाते में साइन इन करें';
      case AppLanguage.marathi:
        return 'आपल्या पुकार आणीबाणी खात्यात साइन इन करा';
      case AppLanguage.english:
        return 'Sign in to your Pukaar emergency account';
    }
  }

  String get mobileNumber {
    switch (language) {
      case AppLanguage.hindi:
        return 'मोबाइल नंबर';
      case AppLanguage.marathi:
        return 'मोबाईल नंबर';
      case AppLanguage.english:
        return 'Mobile Number';
    }
  }

  String get enterMobileNumber {
    switch (language) {
      case AppLanguage.hindi:
        return '10 अंकों का मोबाइल नंबर दर्ज करें';
      case AppLanguage.marathi:
        return '१० अंकी मोबाईल नंबर टाका';
      case AppLanguage.english:
        return 'Enter 10-digit mobile number';
    }
  }

  String get password {
    switch (language) {
      case AppLanguage.hindi:
        return 'पासवर्ड';
      case AppLanguage.marathi:
        return 'पासवर्ड';
      case AppLanguage.english:
        return 'Password';
    }
  }

  String get enterPassword {
    switch (language) {
      case AppLanguage.hindi:
        return 'पासवर्ड दर्ज करें';
      case AppLanguage.marathi:
        return 'पासवर्ड टाका';
      case AppLanguage.english:
        return 'Enter password';
    }
  }

  String get enterOtp {
    switch (language) {
      case AppLanguage.hindi:
        return '6 अंकों का ओटीपी दर्ज करें';
      case AppLanguage.marathi:
        return '६ अंकी ओटीपी टाका';
      case AppLanguage.english:
        return 'Enter 6-digit OTP';
    }
  }

  String get sendOtp {
    switch (language) {
      case AppLanguage.hindi:
        return 'ओटीपी भेजें';
      case AppLanguage.marathi:
        return 'ओटीपी पाठवा';
      case AppLanguage.english:
        return 'Send OTP';
    }
  }

  String get verifyOtpAndSignIn {
    switch (language) {
      case AppLanguage.hindi:
        return 'ओटीपी सत्यापित करें एवं साइन इन करें';
      case AppLanguage.marathi:
        return 'ओटीपी पडताळा आणि साइन इन करा';
      case AppLanguage.english:
        return 'Verify OTP & Sign In';
    }
  }

  String get resendOtp {
    switch (language) {
      case AppLanguage.hindi:
        return 'ओटीपी पुनः भेजें';
      case AppLanguage.marathi:
        return 'ओटीपी पुन्हा पाठवा';
      case AppLanguage.english:
        return 'Resend OTP';
    }
  }

  String resendInSeconds(int seconds) {
    switch (language) {
      case AppLanguage.hindi:
        return '$seconds सेकंड में पुनः भेजें';
      case AppLanguage.marathi:
        return '$seconds सेकंदात पुन्हा पाठवा';
      case AppLanguage.english:
        return 'Resend in ${seconds}s';
    }
  }

  String get changePhoneNumber {
    switch (language) {
      case AppLanguage.hindi:
        return 'फ़ोन नंबर बदलें';
      case AppLanguage.marathi:
        return 'फोन नंबर बदला';
      case AppLanguage.english:
        return 'Change phone number';
    }
  }

  String get completeProfile {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रोफ़ाइल पूर्ण करें';
      case AppLanguage.marathi:
        return 'प्रोफाइल पूर्ण करा';
      case AppLanguage.english:
        return 'Complete Profile';
    }
  }

  String get emergencyProfile {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन प्रोफ़ाइल';
      case AppLanguage.marathi:
        return 'आणीबाणी प्रोफाइल';
      case AppLanguage.english:
        return 'Emergency Profile';
    }
  }

  String get emergencyProfileDesc {
    switch (language) {
      case AppLanguage.hindi:
        return 'यह महत्वपूर्ण जानकारी सुरक्षित रूप से संग्रहीत है और आपातकालीन प्रत्युत्तरकर्ताओं को दिखाई देगी।';
      case AppLanguage.marathi:
        return 'ही महत्त्वाची माहिती सुरक्षितपणे साठवली असून आणीबाणी मदतनीसांना दिसेल.';
      case AppLanguage.english:
        return 'This critical information is stored locally and will be visible to emergency responders.';
    }
  }

  String get personalInfo {
    switch (language) {
      case AppLanguage.hindi:
        return 'व्यक्तिगत जानकारी';
      case AppLanguage.marathi:
        return 'वैयक्तिक माहिती';
      case AppLanguage.english:
        return 'Personal Information';
    }
  }

  String get fullName {
    switch (language) {
      case AppLanguage.hindi:
        return 'पूरा नाम';
      case AppLanguage.marathi:
        return 'पूर्ण नाव';
      case AppLanguage.english:
        return 'Full Name';
    }
  }

  String get ageYears {
    switch (language) {
      case AppLanguage.hindi:
        return 'आयु (वर्ष)';
      case AppLanguage.marathi:
        return 'वय (वर्षे)';
      case AppLanguage.english:
        return 'Age (Years)';
    }
  }

  String get emailOptional {
    switch (language) {
      case AppLanguage.hindi:
        return 'ईमेल (वैकल्पिक)';
      case AppLanguage.marathi:
        return 'ईमेल (पर्यायी)';
      case AppLanguage.english:
        return 'Email (Optional)';
    }
  }

  String get primaryEmergencyContact {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्राथमिक आपातकालीन संपर्क';
      case AppLanguage.marathi:
        return 'प्राथमिक आणीबाणी संपर्क';
      case AppLanguage.english:
        return 'Primary Emergency Contact';
    }
  }

  String get contactPersonName {
    switch (language) {
      case AppLanguage.hindi:
        return 'संपर्क व्यक्ति का नाम';
      case AppLanguage.marathi:
        return 'संपर्क व्यक्तीचे नाव';
      case AppLanguage.english:
        return 'Contact Person Name';
    }
  }

  String get contactPersonMobile {
    switch (language) {
      case AppLanguage.hindi:
        return 'संपर्क व्यक्ति का मोबाइल';
      case AppLanguage.marathi:
        return 'संपर्क व्यक्तीचा मोबाईल';
      case AppLanguage.english:
        return 'Contact Person Mobile';
    }
  }

  String get saveEmergencyProfile {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन प्रोफ़ाइल सहेजें';
      case AppLanguage.marathi:
        return 'आणीबाणी प्रोफाइल जतन करा';
      case AppLanguage.english:
        return 'Save Emergency Profile';
    }
  }

  String get createAccount {
    switch (language) {
      case AppLanguage.hindi:
        return 'खाता बनाएं';
      case AppLanguage.marathi:
        return 'खाते तयार करा';
      case AppLanguage.english:
        return 'Create Account';
    }
  }

  String get selectAccountRole {
    switch (language) {
      case AppLanguage.hindi:
        return 'खाता भूमिका चुनें';
      case AppLanguage.marathi:
        return 'खाते भूमिका निवडा';
      case AppLanguage.english:
        return 'Select Account Role';
    }
  }

  String get citizenRole {
    switch (language) {
      case AppLanguage.hindi:
        return 'नागरिक';
      case AppLanguage.marathi:
        return 'नागरिक';
      case AppLanguage.english:
        return 'Citizen';
    }
  }

  String get responderRole {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन प्रत्युत्तरकर्ता';
      case AppLanguage.marathi:
        return 'आणीबाणी मदतनीस';
      case AppLanguage.english:
        return 'Emergency Responder';
    }
  }

  String get dualRole {
    switch (language) {
      case AppLanguage.hindi:
        return 'दोहरी भूमिका (नागरिक + प्रत्युत्तरकर्ता)';
      case AppLanguage.marathi:
        return 'दुहेरी भूमिका (नागरिक + मदतनीस)';
      case AppLanguage.english:
        return 'Dual Role (Citizen + Responder)';
    }
  }

  String get createPukaarProfile {
    switch (language) {
      case AppLanguage.hindi:
        return 'पुकार प्रोफ़ाइल बनाएं';
      case AppLanguage.marathi:
        return 'पुकार प्रोफाइल तयार करा';
      case AppLanguage.english:
        return 'Create Pukaar Profile';
    }
  }

  String get roleResponder {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रत्युत्तरकर्ता';
      case AppLanguage.marathi:
        return 'मदतनीस';
      case AppLanguage.english:
        return 'Responder';
    }
  }

  String get roleDual {
    switch (language) {
      case AppLanguage.hindi:
        return 'दोहरी भूमिका (दोनों)';
      case AppLanguage.marathi:
        return 'दुहेरी (दोन्ही)';
      case AppLanguage.english:
        return 'Dual (Both)';
    }
  }

  String get createAccountAndSignIn {
    switch (language) {
      case AppLanguage.hindi:
        return 'खाता बनाएं एवं साइन इन करें';
      case AppLanguage.marathi:
        return 'खाते तयार करा आणि साइन इन करा';
      case AppLanguage.english:
        return 'Create Account & Sign In';
    }
  }

  String get cancelEmergency {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकाल रद्द करें';
      case AppLanguage.marathi:
        return 'आणीबाणी रद्द करा';
      case AppLanguage.english:
        return 'Cancel Emergency';
    }
  }

  // ---------------------------------------------------------------------------
  // Home Screen Dashboard
  // ---------------------------------------------------------------------------
  String get immediateEmergencyBroadcast {
    switch (language) {
      case AppLanguage.hindi:
        return 'त्वरित आपातकालीन प्रसारण';
      case AppLanguage.marathi:
        return 'त्वरित आणीबाणी प्रसारण';
      case AppLanguage.english:
        return 'IMMEDIATE EMERGENCY BROADCAST';
    }
  }

  String get tapSosInstruction {
    switch (language) {
      case AppLanguage.hindi:
        return 'सभी स्थानीय बचाव दलों को तुरंत सूचित करने के लिए एसओएस दबाएं।';
      case AppLanguage.marathi:
        return 'सर्व स्थानिक बचाव पथकांना त्वरित सूचित करण्यासाठी एसओएस दाबा.';
      case AppLanguage.english:
        return 'Tap and hold/press SOS to notify all local emergency rescue teams immediately.';
    }
  }

  String get broadcastingIn {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रसारण शुरू होने में...';
      case AppLanguage.marathi:
        return 'प्रसारण सुरू होण्यास...';
      case AppLanguage.english:
        return 'BROADCASTING IN...';
    }
  }

  String get cancelDispatch {
    switch (language) {
      case AppLanguage.hindi:
        return 'डिस्पैच रद्द करें';
      case AppLanguage.marathi:
        return 'डिस्पॅच रद्द करा';
      case AppLanguage.english:
        return 'CANCEL DISPATCH';
    }
  }

  String get sosBroadcastActive {
    switch (language) {
      case AppLanguage.hindi:
        return 'एसओएस प्रसारण सक्रिय';
      case AppLanguage.marathi:
        return 'एसओएस प्रसारण सुरू आहे';
      case AppLanguage.english:
        return 'SOS BROADCAST ACTIVE';
    }
  }

  String get liveLocationUpdating {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपकी लाइव लोकेशन अपडेट की जा रही है।';
      case AppLanguage.marathi:
        return 'आपले थेट स्थान अपडेट केले जात आहे.';
      case AppLanguage.english:
        return 'Your location is being updated live.';
    }
  }

  String get deactivateSosAlert {
    switch (language) {
      case AppLanguage.hindi:
        return 'एसओएस अलर्ट निष्क्रिय करें';
      case AppLanguage.marathi:
        return 'एसओएस अलर्ट थांबवा';
      case AppLanguage.english:
        return 'DEACTIVATE SOS ALERT';
    }
  }

  String get selectEmergencyCategory {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन श्रेणी चुनें';
      case AppLanguage.marathi:
        return 'आणीबाणी प्रकार निवडा';
      case AppLanguage.english:
        return 'Select Emergency Category';
    }
  }

  String get selectEmergencyCategorySubtitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'सटीक सहायता के लिए उपयुक्त विकल्प चुनें';
      case AppLanguage.marathi:
        return 'अचूक मदतीसाठी योग्य पर्याय निवडा';
      case AppLanguage.english:
        return 'Directly open specific triage incident routing';
    }
  }

  String get reportIncident {
    switch (language) {
      case AppLanguage.hindi:
        return 'घटना दर्ज करें';
      case AppLanguage.marathi:
        return 'घटना नोंदवा';
      case AppLanguage.english:
        return 'Report Incident';
    }
  }

  String get preparednessAndHealthId {
    switch (language) {
      case AppLanguage.hindi:
        return 'तैयारी एवं स्वास्थ्य आईडी';
      case AppLanguage.marathi:
        return 'पूर्वनोंदणी आणि आरोग्य ओळखपत्र';
      case AppLanguage.english:
        return 'Preparedness & Health ID';
    }
  }

  String get preparednessSubtitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'स्थानीय चिकित्सा प्रत्युत्तरकर्ताओं के लिए उपलब्ध जानकारी';
      case AppLanguage.marathi:
        return 'स्थानिक वैद्यकीय मदतनीसांसाठी उपलब्ध माहिती';
      case AppLanguage.english:
        return 'Information available for local medical responders';
    }
  }

  String get manageTrustedContacts {
    switch (language) {
      case AppLanguage.hindi:
        return 'विश्वसनीय संपर्क प्रबंधित करें';
      case AppLanguage.marathi:
        return 'विश्वासू संपर्क व्यवस्थापित करा';
      case AppLanguage.english:
        return 'Manage trusted contacts';
    }
  }

  String get bloodGroupAndAllergies {
    switch (language) {
      case AppLanguage.hindi:
        return 'रक्त समूह एवं एलर्जी विवरण';
      case AppLanguage.marathi:
        return 'रक्तगट आणि ॲलर्जी तपशील';
      case AppLanguage.english:
        return 'Blood group & allergies';
    }
  }

  String get gpsActiveHighAccuracy {
    switch (language) {
      case AppLanguage.hindi:
        return 'जीपीएस सक्रिय • उच्च सटीकता';
      case AppLanguage.marathi:
        return 'जीपीएस सक्रिय • उच्च अचूकता';
      case AppLanguage.english:
        return 'GPS Active • High Accuracy';
    }
  }

  String get checkingGps {
    switch (language) {
      case AppLanguage.hindi:
        return 'जीपीएस जांचा जा रहा है...';
      case AppLanguage.marathi:
        return 'जीपीएस तपासत आहे...';
      case AppLanguage.english:
        return 'Checking GPS...';
    }
  }

  String get locationDisabled {
    switch (language) {
      case AppLanguage.hindi:
        return 'स्थान सेवा अक्षम है';
      case AppLanguage.marathi:
        return 'स्थान सेवा बंद आहे';
      case AppLanguage.english:
        return 'Location services disabled';
    }
  }

  // ---------------------------------------------------------------------------
  // Emergency SOS Screen
  // ---------------------------------------------------------------------------
  String get emergencyTrigger {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन ट्रिगर';
      case AppLanguage.marathi:
        return 'आणीबाणी ट्रिगर';
      case AppLanguage.english:
        return 'Emergency Trigger';
    }
  }

  String get sosBroadcastNotice {
    switch (language) {
      case AppLanguage.hindi:
        return 'एसओएस दबाने से आपके वर्तमान जीपीएस निर्देशांक निकटतम प्रत्युत्तरकर्ताओं और विश्वसनीय संपर्कों को प्रसारित हो जाएंगे।';
      case AppLanguage.marathi:
        return 'एसओएस दाबल्यास आपले सध्याचे जीपीएस स्थान जवळच्या मदतनीसांना आणि विश्वासू संपर्कांना पाठवले जाईल.';
      case AppLanguage.english:
        return 'Pressing SOS will broadcast your current GPS coordinates to nearest response dispatchers and trusted contacts.';
    }
  }

  String get locationReadyGpsActive {
    switch (language) {
      case AppLanguage.hindi:
        return 'स्थान तैयार: जीपीएस सक्रिय';
      case AppLanguage.marathi:
        return 'स्थान तयार: जीपीएस सक्रिय';
      case AppLanguage.english:
        return 'Location ready: GPS status active';
    }
  }

  // ---------------------------------------------------------------------------
  // Emergency Intent / Triage Screen
  // ---------------------------------------------------------------------------
  String get specifyEmergencyIntent {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन प्रकार निर्दिष्ट करें';
      case AppLanguage.marathi:
        return 'आणीबाणीचा प्रकार स्पष्ट करा';
      case AppLanguage.english:
        return 'Specify Emergency Intent';
    }
  }

  String get specifyEmergencyIntentSubtitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'सही प्रत्युत्तर टीम भेजने में सहायता के लिए सबसे उपयुक्त विकल्प चुनें।';
      case AppLanguage.marathi:
        return 'योग्य मदत पथक पाठवण्यासाठी सर्वात जवळचा पर्याय निवडा.';
      case AppLanguage.english:
        return 'Select the closest option to help dispatch the correct response team.';
    }
  }

  String get confirmEmergencyRequest {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन अनुरोध की पुष्टि करें';
      case AppLanguage.marathi:
        return 'आणीबाणी विनंतीची पुष्टी करा';
      case AppLanguage.english:
        return 'Confirm Emergency Request';
    }
  }

  // ---------------------------------------------------------------------------
  // Emergency Tracking Screen
  // ---------------------------------------------------------------------------
  String get emergencyStatus {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन स्थिति';
      case AppLanguage.marathi:
        return 'आणीबाणी स्थिती';
      case AppLanguage.english:
        return 'Emergency Status';
    }
  }

  String get assignedResponder {
    switch (language) {
      case AppLanguage.hindi:
        return 'नियुक्त प्रत्युत्तरकर्ता';
      case AppLanguage.marathi:
        return 'नेमलेला मदतनीस';
      case AppLanguage.english:
        return 'Assigned Responder';
    }
  }

  String get cancelEmergencyTitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकाल रद्द करें?';
      case AppLanguage.marathi:
        return 'आणीबाणी रद्द करायची?';
      case AppLanguage.english:
        return 'Cancel Emergency?';
    }
  }

  String get cancelEmergencyContent {
    switch (language) {
      case AppLanguage.hindi:
        return 'क्या आप वाकई इस आपातकालीन अनुरोध को रद्द करना चाहते हैं? प्रत्युत्तरकर्ताओं को रुकने की सूचना दी जाएगी।';
      case AppLanguage.marathi:
        return 'आपण खात्रीने ही आणीबाणी विनंती रद्द करू इच्छिता? मदतनीसांना थांबण्याची सूचना दिली जाईल.';
      case AppLanguage.english:
        return 'Are you sure you want to cancel this emergency request? Responders will be notified to stand down.';
    }
  }

  String get keepActive {
    switch (language) {
      case AppLanguage.hindi:
        return 'नहीं, सक्रिय रखें';
      case AppLanguage.marathi:
        return 'नाही, सुरू ठेवा';
      case AppLanguage.english:
        return 'No, Keep Active';
    }
  }

  String get yesCancel {
    switch (language) {
      case AppLanguage.hindi:
        return 'हाँ, रद्द करें';
      case AppLanguage.marathi:
        return 'होय, रद्द करा';
      case AppLanguage.english:
        return 'Yes, Cancel';
    }
  }

  String get incidentCancelledBanner {
    switch (language) {
      case AppLanguage.hindi:
        return 'यह आपातकालीन घटना रद्द कर दी गई है।';
      case AppLanguage.marathi:
        return 'ही आणीबाणी घटना रद्द करण्यात आली आहे.';
      case AppLanguage.english:
        return 'This emergency incident has been cancelled.';
    }
  }

  String get liveDispatchTracking {
    switch (language) {
      case AppLanguage.hindi:
        return 'लाइव डिस्पैच ट्रैकिंग';
      case AppLanguage.marathi:
        return 'थेट डिस्पॅच ट्रॅकिंग';
      case AppLanguage.english:
        return 'Live Dispatch Tracking';
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle Status Names
  // ---------------------------------------------------------------------------
  String get statusCreated {
    switch (language) {
      case AppLanguage.hindi:
        return 'घटना दर्ज की गई';
      case AppLanguage.marathi:
        return 'घटना नोंदवली गेली';
      case AppLanguage.english:
        return 'Incident Created';
    }
  }

  String get statusSearching {
    switch (language) {
      case AppLanguage.hindi:
        return 'निकटतम प्रत्युत्तरकर्ताओं की खोज जारी';
      case AppLanguage.marathi:
        return 'जवळच्या मदतनीसांचा शोध सुरू आहे';
      case AppLanguage.english:
        return 'Searching Nearest Responders';
    }
  }

  String get statusDispatched {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रत्युत्तरकर्ता रवाना किया गया';
      case AppLanguage.marathi:
        return 'मदतनीस रवाना झाला आहे';
      case AppLanguage.english:
        return 'Responder Dispatched';
    }
  }

  String get statusAccepted {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रत्युत्तरकर्ता ने स्वीकार किया';
      case AppLanguage.marathi:
        return 'मदतनीसाने विनंती स्वीकारली';
      case AppLanguage.english:
        return 'Responder Accepted';
    }
  }

  String get statusInProgress {
    switch (language) {
      case AppLanguage.hindi:
        return 'बचाव कार्य प्रगति पर है';
      case AppLanguage.marathi:
        return 'बचाव कार्य सुरू आहे';
      case AppLanguage.english:
        return 'Rescue In Progress';
    }
  }

  String get statusResolved {
    switch (language) {
      case AppLanguage.hindi:
        return 'समाधान हो गया';
      case AppLanguage.marathi:
        return 'सोडवले';
      case AppLanguage.english:
        return 'Resolved';
    }
  }

  String get statusCancelled {
    switch (language) {
      case AppLanguage.hindi:
        return 'रद्द किया गया';
      case AppLanguage.marathi:
        return 'रद्द केले';
      case AppLanguage.english:
        return 'Cancelled';
    }
  }

  // ---------------------------------------------------------------------------
  // First Responder Dashboard & Incident Actions
  // ---------------------------------------------------------------------------
  String get acceptIncidentResponse {
    switch (language) {
      case AppLanguage.hindi:
        return 'घटना प्रतिक्रिया स्वीकार करें';
      case AppLanguage.marathi:
        return 'घटना प्रतिसाद स्वीकारा';
      case AppLanguage.english:
        return 'Accept Incident Response';
    }
  }

  String get startResponseInProgress {
    switch (language) {
      case AppLanguage.hindi:
        return 'प्रतिक्रिया शुरू करें (प्रगति पर)';
      case AppLanguage.marathi:
        return 'प्रतिसाद सुरू करा (काम सुरू)';
      case AppLanguage.english:
        return 'Start Response (In Progress)';
    }
  }

  String get markIncidentResolved {
    switch (language) {
      case AppLanguage.hindi:
        return 'घटना को सुलझा हुआ चिह्नित करें';
      case AppLanguage.marathi:
        return 'घटना सोडवली म्हणून नोंदवा';
      case AppLanguage.english:
        return 'Mark Incident Resolved';
    }
  }

  String get noActiveEmergencies {
    switch (language) {
      case AppLanguage.hindi:
        return 'कोई सक्रिय आपातकाल नहीं';
      case AppLanguage.marathi:
        return 'कोणतीही आणीबाणी सक्रिय नाही';
      case AppLanguage.english:
        return 'No Active Emergencies';
    }
  }

  String get allClearNotice {
    switch (language) {
      case AppLanguage.hindi:
        return 'सभी आपातकालीन अनुरोध वर्तमान में सुरक्षित या सुलझा लिए गए हैं।';
      case AppLanguage.marathi:
        return 'सर्व आणीबाणी विनंत्या सध्या सुरक्षित किंवा सोडवण्यात आल्या आहेत.';
      case AppLanguage.english:
        return 'All emergency requests are currently clear or resolved.';
    }
  }

  String get returnToCitizenHome {
    switch (language) {
      case AppLanguage.hindi:
        return 'नागरिक होम पर लौटें';
      case AppLanguage.marathi:
        return 'नागरिक मुख्यपृष्ठावर परत जा';
      case AppLanguage.english:
        return 'Return to Citizen Home';
    }
  }

  // ---------------------------------------------------------------------------
  // AI Incident Intelligence
  // ---------------------------------------------------------------------------
  String get aiIncidentIntelligence {
    switch (language) {
      case AppLanguage.hindi:
        return 'एआई घटना विश्लेषण';
      case AppLanguage.marathi:
        return 'एआय घटना बुद्धिमत्ता';
      case AppLanguage.english:
        return 'AI INCIDENT INTELLIGENCE';
    }
  }

  String get aiAdvisoryDisclaimer {
    switch (language) {
      case AppLanguage.hindi:
        return 'एआई सलाह — कार्रवाई से पहले सत्यापन करें';
      case AppLanguage.marathi:
        return 'एआय सल्ला — कारवाईपूर्वी खात्री करा';
      case AppLanguage.english:
        return 'AI Advisory — Verify before action';
    }
  }

  String get identifiedHazards {
    switch (language) {
      case AppLanguage.hindi:
        return 'पहचाने गए खतरे / जोखिम';
      case AppLanguage.marathi:
        return 'ओळखलेले धोके / जोखीम';
      case AppLanguage.english:
        return 'IDENTIFIED HAZARDS / RISKS';
    }
  }

  String get recommendedGuidance {
    switch (language) {
      case AppLanguage.hindi:
        return 'अनुशंसित प्रत्युत्तरकर्ता मार्गदर्शन';
      case AppLanguage.marathi:
        return 'शिफारस केलेले मदतनीस मार्गदर्शन';
      case AppLanguage.english:
        return 'RECOMMENDED RESPONDER GUIDANCE';
    }
  }

  String get missingInfo {
    switch (language) {
      case AppLanguage.hindi:
        return 'लापता जानकारी (पहुंचने पर सत्यापित करें)';
      case AppLanguage.marathi:
        return 'गहाळ माहिती (पोहोचल्यावर खात्री करा)';
      case AppLanguage.english:
        return 'MISSING INFORMATION (VERIFY ON ARRIVAL)';
    }
  }

  // ---------------------------------------------------------------------------
  // Voice Emergency Input Card
  // ---------------------------------------------------------------------------
  String get describeEmergencyByVoice {
    switch (language) {
      case AppLanguage.hindi:
        return 'बोलकर आपातकाल का वर्णन करें';
      case AppLanguage.marathi:
        return 'आणीबाणीचे वर्णन बोलून सांगा';
      case AppLanguage.english:
        return 'Describe Emergency by Voice';
    }
  }

  String get voiceInputRecorded {
    switch (language) {
      case AppLanguage.hindi:
        return 'आवाज़ इनपुट दर्ज हुआ';
      case AppLanguage.marathi:
        return 'आवाज इनपुट नोंदवला गेला';
      case AppLanguage.english:
        return 'Voice Input Recorded';
    }
  }

  String get listeningSpeakNow {
    switch (language) {
      case AppLanguage.hindi:
        return 'सुन रहे हैं... अब बोलें';
      case AppLanguage.marathi:
        return 'ऐकत आहे... आता बोला';
      case AppLanguage.english:
        return 'Listening... Speak now';
    }
  }

  String get tapMicToStop {
    switch (language) {
      case AppLanguage.hindi:
        return 'बोलने के बाद माइक दबाएं';
      case AppLanguage.marathi:
        return 'पूर्ण झाल्यावर माइक टॅप करा';
      case AppLanguage.english:
        return 'Tap mic to stop when done';
    }
  }

  String get tapMicToSpeakAgain {
    switch (language) {
      case AppLanguage.hindi:
        return 'पुनः बोलने के लिए माइक दबाएं या नीचे संपादित करें';
      case AppLanguage.marathi:
        return 'पुन्हा बोलण्यासाठी माइक टॅप करा किंवा खाली संपादित करा';
      case AppLanguage.english:
        return 'Tap mic to speak again or edit below';
    }
  }

  String get tapMicOrType {
    switch (language) {
      case AppLanguage.hindi:
        return 'माइक दबाकर बोलें, या सीधे टाइप करें';
      case AppLanguage.marathi:
        return 'माइक टॅप करून बोला किंवा थेट टाइप करा';
      case AppLanguage.english:
        return 'Tap mic and speak, or type directly';
    }
  }

  String get micPermissionDenied {
    switch (language) {
      case AppLanguage.hindi:
        return 'माइक्रोफ़ोन अनुमति अस्वीकृत। आप नीचे स्थिति टाइप कर सकते हैं।';
      case AppLanguage.marathi:
        return 'मायक्रोफोन परवानगी नाकारली. आपण खाली टाईप करू शकता.';
      case AppLanguage.english:
        return 'Microphone permission denied. You can still type your description below.';
    }
  }

  String get speechUnavailable {
    switch (language) {
      case AppLanguage.hindi:
        return 'आवाज़ पहचान अनुपलब्ध है। आप नीचे स्थिति टाइप कर सकते हैं।';
      case AppLanguage.marathi:
        return 'आवाज ओळख अनुपलब्ध आहे. आपण खाली टाईप करू शकता.';
      case AppLanguage.english:
        return 'Speech recognition unavailable. You can type your description below.';
    }
  }

  String get speechError {
    switch (language) {
      case AppLanguage.hindi:
        return 'आवाज़ पहचान में समस्या आई। पुनः प्रयास करें या नीचे टाइप करें।';
      case AppLanguage.marathi:
        return 'आवाज ओळखीमध्ये त्रुटी आढळली. पुन्हा प्रयत्न करा किंवा खाली टाईप करा.';
      case AppLanguage.english:
        return 'Speech recognition encountered an issue. Tap Retry or type below.';
    }
  }

  String get voiceInputHint {
    switch (language) {
      case AppLanguage.hindi:
        return 'स्थिति का वर्णन करें (बोलकर या टाइप करके)...';
      case AppLanguage.marathi:
        return 'परिस्थितीचे वर्णन करा (बोलून किंवा टाईप करून)...';
      case AppLanguage.english:
        return 'Describe the situation (voice or typed)...';
    }
  }

  // ---------------------------------------------------------------------------
  // Profile, Medical ID & Emergency Contacts
  // ---------------------------------------------------------------------------
  String get editPersonalInformation {
    switch (language) {
      case AppLanguage.hindi:
        return 'व्यक्तिगत जानकारी संपादित करें';
      case AppLanguage.marathi:
        return 'वैयक्तिक माहिती संपादित करा';
      case AppLanguage.english:
        return 'Edit Personal Information';
    }
  }

  String get emergencyConfigurations {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन विन्यास';
      case AppLanguage.marathi:
        return 'आणीबाणी संरचना';
      case AppLanguage.english:
        return 'Emergency Configurations';
    }
  }

  String get systemPermissionsAndStatus {
    switch (language) {
      case AppLanguage.hindi:
        return 'सिस्टम अनुमतियां एवं स्थिति';
      case AppLanguage.marathi:
        return 'सिस्टम परवानग्या आणि स्थिती';
      case AppLanguage.english:
        return 'System Permissions & Status';
    }
  }

  String get locationServicesStatus {
    switch (language) {
      case AppLanguage.hindi:
        return 'स्थान सेवा स्थिति';
      case AppLanguage.marathi:
        return 'स्थान सेवा स्थिती';
      case AppLanguage.english:
        return 'Location Services Status';
    }
  }

  String get emergencyBroadcastAlerts {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपातकालीन प्रसारण अलर्ट';
      case AppLanguage.marathi:
        return 'आणीबाणी प्रसारण सूचना';
      case AppLanguage.english:
        return 'Emergency Broadcast Alerts';
    }
  }

  String get appLanguageLabel {
    switch (language) {
      case AppLanguage.hindi:
        return 'ऐप की भाषा';
      case AppLanguage.marathi:
        return 'अ‍ॅपची भाषा';
      case AppLanguage.english:
        return 'App Language';
    }
  }

  String get bloodGroup {
    switch (language) {
      case AppLanguage.hindi:
        return 'रक्त समूह';
      case AppLanguage.marathi:
        return 'रक्तगट';
      case AppLanguage.english:
        return 'Blood Group';
    }
  }

  String get allergies {
    switch (language) {
      case AppLanguage.hindi:
        return 'एलर्जी';
      case AppLanguage.marathi:
        return 'ॲलर्जी';
      case AppLanguage.english:
        return 'Allergies';
    }
  }

  String get medications {
    switch (language) {
      case AppLanguage.hindi:
        return 'दवाएं';
      case AppLanguage.marathi:
        return 'औषधे';
      case AppLanguage.english:
        return 'Medications';
    }
  }

  String get medicalIdSubtitle {
    switch (language) {
      case AppLanguage.hindi:
        return 'महत्वपूर्ण स्वास्थ्य जानकारी ताकि आपातकालीन टीमें तुरंत उपयुक्त उपचार कर सकें।';
      case AppLanguage.marathi:
        return 'महत्त्वाची आरोग्य माहिती जेणेकरून आणीबाणी पथके त्वरित योग्य उपचार करू शकतील.';
      case AppLanguage.english:
        return 'Critical healthcare details to assist first responders in triage and treatment.';
    }
  }
}

/// Flutter [LocalizationsDelegate] for [AppLocalizations].
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLanguage.values.any((lang) => lang.code == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations.ofLocale(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// Extension for convenient syntactic access on [BuildContext].
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
