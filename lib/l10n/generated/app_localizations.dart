import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_ro.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl'),
    Locale('ro')
  ];

  /// No description provided for @languagesSelectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get languagesSelectLanguage;

  /// No description provided for @languagesChoosePreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languagesChoosePreferredLanguage;

  /// No description provided for @languagesLanguageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languagesLanguageChangedTo(String language);

  /// No description provided for @languagesSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get languagesSelected;

  /// No description provided for @languagesRomanian.
  ///
  /// In en, this message translates to:
  /// **'Romanian'**
  String get languagesRomanian;

  /// No description provided for @languagesFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languagesFrench;

  /// No description provided for @languagesGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languagesGerman;

  /// No description provided for @languagesItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get languagesItalian;

  /// No description provided for @languagesSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languagesSpanish;

  /// No description provided for @languagesDutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get languagesDutch;

  /// No description provided for @languagesEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languagesEnglish;

  /// No description provided for @entryScreenWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get entryScreenWelcome;

  /// No description provided for @entryScreenYourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get entryScreenYourName;

  /// No description provided for @entryScreenEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get entryScreenEnterFullName;

  /// No description provided for @entryScreenIAgreeToThe.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get entryScreenIAgreeToThe;

  /// No description provided for @entryScreenGdprPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'GDPR Privacy Policy'**
  String get entryScreenGdprPrivacyPolicy;

  /// No description provided for @entryScreenContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get entryScreenContinue;

  /// No description provided for @questionsNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get questionsNext;

  /// No description provided for @questionsPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get questionsPrevious;

  /// No description provided for @questionsFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get questionsFinish;

  /// No description provided for @questionStudyLevel.
  ///
  /// In en, this message translates to:
  /// **'What is your current level of study?'**
  String get questionStudyLevel;

  /// No description provided for @questionStillStudent.
  ///
  /// In en, this message translates to:
  /// **'Are you still a student?'**
  String get questionStillStudent;

  /// No description provided for @questionWhatYear.
  ///
  /// In en, this message translates to:
  /// **'What year are you in?'**
  String get questionWhatYear;

  /// No description provided for @questionWhenFinish.
  ///
  /// In en, this message translates to:
  /// **'When will you be done with your studies?'**
  String get questionWhenFinish;

  /// No description provided for @questionUniversityType.
  ///
  /// In en, this message translates to:
  /// **'What kind of university do/did you attend?'**
  String get questionUniversityType;

  /// No description provided for @questionStudyField.
  ///
  /// In en, this message translates to:
  /// **'What is the field of your study?'**
  String get questionStudyField;

  /// No description provided for @questionEngineeringType.
  ///
  /// In en, this message translates to:
  /// **'What type of engineering?'**
  String get questionEngineeringType;

  /// No description provided for @questionItArea.
  ///
  /// In en, this message translates to:
  /// **'What area of IT & Data Science?'**
  String get questionItArea;

  /// No description provided for @questionOtherSpecializations.
  ///
  /// In en, this message translates to:
  /// **'Do you have other specializations/minor?'**
  String get questionOtherSpecializations;

  /// No description provided for @questionPriorExperience.
  ///
  /// In en, this message translates to:
  /// **'Do you have any prior experience in these fields?'**
  String get questionPriorExperience;

  /// No description provided for @questionOtherFields.
  ///
  /// In en, this message translates to:
  /// **'What other fields have you worked in before?'**
  String get questionOtherFields;

  /// No description provided for @questionSoftSkills.
  ///
  /// In en, this message translates to:
  /// **'What soft skills do you master?'**
  String get questionSoftSkills;

  /// No description provided for @questionHardSkills.
  ///
  /// In en, this message translates to:
  /// **'What hard skills do you master?'**
  String get questionHardSkills;

  /// No description provided for @questionLanguagesComfortable.
  ///
  /// In en, this message translates to:
  /// **'What languages are you comfortable doing the internship in?'**
  String get questionLanguagesComfortable;

  /// No description provided for @questionCountriesSearch.
  ///
  /// In en, this message translates to:
  /// **'What countries are you searching an internship in?'**
  String get questionCountriesSearch;

  /// No description provided for @questionAvailability.
  ///
  /// In en, this message translates to:
  /// **'What is your availability?'**
  String get questionAvailability;

  /// No description provided for @questionInternshipLength.
  ///
  /// In en, this message translates to:
  /// **'How long should the internship be?'**
  String get questionInternshipLength;

  /// No description provided for @questionRequireVisa.
  ///
  /// In en, this message translates to:
  /// **'Do you require VISA to work?'**
  String get questionRequireVisa;

  /// No description provided for @questionConsiderTraineeships.
  ///
  /// In en, this message translates to:
  /// **'Would you also consider traineeships?'**
  String get questionConsiderTraineeships;

  /// No description provided for @optionHighschool.
  ///
  /// In en, this message translates to:
  /// **'Highschool'**
  String get optionHighschool;

  /// No description provided for @optionBachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor'**
  String get optionBachelor;

  /// No description provided for @optionMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get optionMaster;

  /// No description provided for @optionPhd.
  ///
  /// In en, this message translates to:
  /// **'PhD'**
  String get optionPhd;

  /// No description provided for @optionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get optionYes;

  /// No description provided for @optionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get optionNo;

  /// No description provided for @optionMaybe.
  ///
  /// In en, this message translates to:
  /// **'Maybe'**
  String get optionMaybe;

  /// No description provided for @optionFirstYear.
  ///
  /// In en, this message translates to:
  /// **'1st Year'**
  String get optionFirstYear;

  /// No description provided for @optionSecondYear.
  ///
  /// In en, this message translates to:
  /// **'2nd Year'**
  String get optionSecondYear;

  /// No description provided for @optionThirdYear.
  ///
  /// In en, this message translates to:
  /// **'3rd Year'**
  String get optionThirdYear;

  /// No description provided for @optionFourthYear.
  ///
  /// In en, this message translates to:
  /// **'4th Year'**
  String get optionFourthYear;

  /// No description provided for @optionResearch.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get optionResearch;

  /// No description provided for @optionApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get optionApplied;

  /// No description provided for @optionEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get optionEngineering;

  /// No description provided for @optionItDataScience.
  ///
  /// In en, this message translates to:
  /// **'IT & Data Science'**
  String get optionItDataScience;

  /// No description provided for @optionMarketingCommunication.
  ///
  /// In en, this message translates to:
  /// **'Marketing & Communication'**
  String get optionMarketingCommunication;

  /// No description provided for @optionFinanceEconomics.
  ///
  /// In en, this message translates to:
  /// **'Finance & Economics'**
  String get optionFinanceEconomics;

  /// No description provided for @optionPoliticalScience.
  ///
  /// In en, this message translates to:
  /// **'Political Science & Public Administration'**
  String get optionPoliticalScience;

  /// No description provided for @optionSalesBusiness.
  ///
  /// In en, this message translates to:
  /// **'Sales & Business Administration'**
  String get optionSalesBusiness;

  /// No description provided for @optionArtsCulture.
  ///
  /// In en, this message translates to:
  /// **'Arts & Culture'**
  String get optionArtsCulture;

  /// No description provided for @optionBiologyChemistry.
  ///
  /// In en, this message translates to:
  /// **'Biology, Chemistry, & Life Sciences'**
  String get optionBiologyChemistry;

  /// No description provided for @optionNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get optionNone;

  /// No description provided for @optionMechanical.
  ///
  /// In en, this message translates to:
  /// **'Mechanical'**
  String get optionMechanical;

  /// No description provided for @optionElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get optionElectrical;

  /// No description provided for @optionAerospace.
  ///
  /// In en, this message translates to:
  /// **'Aerospace'**
  String get optionAerospace;

  /// No description provided for @optionCivil.
  ///
  /// In en, this message translates to:
  /// **'Civil'**
  String get optionCivil;

  /// No description provided for @optionChemical.
  ///
  /// In en, this message translates to:
  /// **'Chemical'**
  String get optionChemical;

  /// No description provided for @optionSoftwareDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Software Development & Debugging'**
  String get optionSoftwareDevelopment;

  /// No description provided for @optionFullStackDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Full-stack Development'**
  String get optionFullStackDevelopment;

  /// No description provided for @optionCloudComputing.
  ///
  /// In en, this message translates to:
  /// **'Cloud Computing (AWS, Azure, GCP)'**
  String get optionCloudComputing;

  /// No description provided for @optionDevOps.
  ///
  /// In en, this message translates to:
  /// **'DevOps & CI/CD'**
  String get optionDevOps;

  /// No description provided for @optionItSupport.
  ///
  /// In en, this message translates to:
  /// **'IT Support & System Administration'**
  String get optionItSupport;

  /// No description provided for @optionProductManagement.
  ///
  /// In en, this message translates to:
  /// **'Product Management'**
  String get optionProductManagement;

  /// No description provided for @optionMachineLearning.
  ///
  /// In en, this message translates to:
  /// **'Machine Learning & AI'**
  String get optionMachineLearning;

  /// No description provided for @optionDataAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Data Analysis'**
  String get optionDataAnalysis;

  /// No description provided for @optionYesInternship.
  ///
  /// In en, this message translates to:
  /// **'Yes, internship'**
  String get optionYesInternship;

  /// No description provided for @optionYesPartTime.
  ///
  /// In en, this message translates to:
  /// **'Yes, part-time job'**
  String get optionYesPartTime;

  /// No description provided for @optionYesPersonalProjects.
  ///
  /// In en, this message translates to:
  /// **'Yes, personal projects'**
  String get optionYesPersonalProjects;

  /// No description provided for @optionAnytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get optionAnytime;

  /// No description provided for @optionSummer.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get optionSummer;

  /// No description provided for @optionAutumn.
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get optionAutumn;

  /// No description provided for @optionWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get optionWinter;

  /// No description provided for @optionSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get optionSpring;

  /// No description provided for @optionOneToThreeMonths.
  ///
  /// In en, this message translates to:
  /// **'1-3 months'**
  String get optionOneToThreeMonths;

  /// No description provided for @optionThreeToSixMonths.
  ///
  /// In en, this message translates to:
  /// **'3-6 months'**
  String get optionThreeToSixMonths;

  /// No description provided for @optionSixToTwelveMonths.
  ///
  /// In en, this message translates to:
  /// **'6-12 months'**
  String get optionSixToTwelveMonths;

  /// No description provided for @optionMoreThanTwelveMonths.
  ///
  /// In en, this message translates to:
  /// **'More than 12 months'**
  String get optionMoreThanTwelveMonths;

  /// No description provided for @optionYesEuUk.
  ///
  /// In en, this message translates to:
  /// **'Yes, for EU/EEA and UK'**
  String get optionYesEuUk;

  /// No description provided for @optionYesEu.
  ///
  /// In en, this message translates to:
  /// **'Yes, for EU/EEA'**
  String get optionYesEu;

  /// No description provided for @optionYesUk.
  ///
  /// In en, this message translates to:
  /// **'Yes, for UK'**
  String get optionYesUk;

  /// No description provided for @languageAlbanian.
  ///
  /// In en, this message translates to:
  /// **'Albanian'**
  String get languageAlbanian;

  /// No description provided for @languageBosnian.
  ///
  /// In en, this message translates to:
  /// **'Bosnian'**
  String get languageBosnian;

  /// No description provided for @languageBulgarian.
  ///
  /// In en, this message translates to:
  /// **'Bulgarian'**
  String get languageBulgarian;

  /// No description provided for @languageCatalan.
  ///
  /// In en, this message translates to:
  /// **'Catalan'**
  String get languageCatalan;

  /// No description provided for @languageCroatian.
  ///
  /// In en, this message translates to:
  /// **'Croatian'**
  String get languageCroatian;

  /// No description provided for @languageCzech.
  ///
  /// In en, this message translates to:
  /// **'Czech'**
  String get languageCzech;

  /// No description provided for @languageDanish.
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get languageDanish;

  /// No description provided for @languageDutch.
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get languageDutch;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageEstonian.
  ///
  /// In en, this message translates to:
  /// **'Estonian'**
  String get languageEstonian;

  /// No description provided for @languageFinnish.
  ///
  /// In en, this message translates to:
  /// **'Finnish'**
  String get languageFinnish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageGreek.
  ///
  /// In en, this message translates to:
  /// **'Greek'**
  String get languageGreek;

  /// No description provided for @languageHungarian.
  ///
  /// In en, this message translates to:
  /// **'Hungarian'**
  String get languageHungarian;

  /// No description provided for @languageIcelandic.
  ///
  /// In en, this message translates to:
  /// **'Icelandic'**
  String get languageIcelandic;

  /// No description provided for @languageIrish.
  ///
  /// In en, this message translates to:
  /// **'Irish'**
  String get languageIrish;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get languageItalian;

  /// No description provided for @languageLatvian.
  ///
  /// In en, this message translates to:
  /// **'Latvian'**
  String get languageLatvian;

  /// No description provided for @languageLithuanian.
  ///
  /// In en, this message translates to:
  /// **'Lithuanian'**
  String get languageLithuanian;

  /// No description provided for @languageLuxembourgish.
  ///
  /// In en, this message translates to:
  /// **'Luxembourgish'**
  String get languageLuxembourgish;

  /// No description provided for @languageMacedonian.
  ///
  /// In en, this message translates to:
  /// **'Macedonian'**
  String get languageMacedonian;

  /// No description provided for @languageMaltese.
  ///
  /// In en, this message translates to:
  /// **'Maltese'**
  String get languageMaltese;

  /// No description provided for @languageMontenegrin.
  ///
  /// In en, this message translates to:
  /// **'Montenegrin'**
  String get languageMontenegrin;

  /// No description provided for @languageNorwegian.
  ///
  /// In en, this message translates to:
  /// **'Norwegian'**
  String get languageNorwegian;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get languagePolish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get languagePortuguese;

  /// No description provided for @languageRomanian.
  ///
  /// In en, this message translates to:
  /// **'Romanian'**
  String get languageRomanian;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageSerbian.
  ///
  /// In en, this message translates to:
  /// **'Serbian'**
  String get languageSerbian;

  /// No description provided for @languageSlovak.
  ///
  /// In en, this message translates to:
  /// **'Slovak'**
  String get languageSlovak;

  /// No description provided for @languageSlovenian.
  ///
  /// In en, this message translates to:
  /// **'Slovenian'**
  String get languageSlovenian;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageSwedish.
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get languageSwedish;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @languageUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get languageUkrainian;

  /// No description provided for @countryAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get countryAny;

  /// No description provided for @countryAlbania.
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get countryAlbania;

  /// No description provided for @countryAndorra.
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get countryAndorra;

  /// No description provided for @countryAustria.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get countryAustria;

  /// No description provided for @countryBelgium.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get countryBelgium;

  /// No description provided for @countryBosniaHerzegovina.
  ///
  /// In en, this message translates to:
  /// **'Bosnia and Herzegovina'**
  String get countryBosniaHerzegovina;

  /// No description provided for @countryBulgaria.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get countryBulgaria;

  /// No description provided for @countryCroatia.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get countryCroatia;

  /// No description provided for @countryCyprus.
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get countryCyprus;

  /// No description provided for @countryCzechRepublic.
  ///
  /// In en, this message translates to:
  /// **'Czech Republic'**
  String get countryCzechRepublic;

  /// No description provided for @countryDenmark.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get countryDenmark;

  /// No description provided for @countryEstonia.
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get countryEstonia;

  /// No description provided for @countryFinland.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get countryFinland;

  /// No description provided for @countryFrance.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryGreece.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryGreece;

  /// No description provided for @countryHungary.
  ///
  /// In en, this message translates to:
  /// **'Hungary'**
  String get countryHungary;

  /// No description provided for @countryIceland.
  ///
  /// In en, this message translates to:
  /// **'Iceland'**
  String get countryIceland;

  /// No description provided for @countryIreland.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get countryIreland;

  /// No description provided for @countryItaly.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryItaly;

  /// No description provided for @countryKosovo.
  ///
  /// In en, this message translates to:
  /// **'Kosovo'**
  String get countryKosovo;

  /// No description provided for @countryLatvia.
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get countryLatvia;

  /// No description provided for @countryLithuania.
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get countryLithuania;

  /// No description provided for @countryLuxembourg.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get countryLuxembourg;

  /// No description provided for @countryMalta.
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get countryMalta;

  /// No description provided for @countryMoldova.
  ///
  /// In en, this message translates to:
  /// **'Moldova'**
  String get countryMoldova;

  /// No description provided for @countryMonaco.
  ///
  /// In en, this message translates to:
  /// **'Monaco'**
  String get countryMonaco;

  /// No description provided for @countryMontenegro.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get countryMontenegro;

  /// No description provided for @countryNetherlands.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryNetherlands;

  /// No description provided for @countryNorthMacedonia.
  ///
  /// In en, this message translates to:
  /// **'North Macedonia'**
  String get countryNorthMacedonia;

  /// No description provided for @countryNorway.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get countryNorway;

  /// No description provided for @countryPoland.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get countryPoland;

  /// No description provided for @countryPortugal.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get countryPortugal;

  /// No description provided for @countryRomania.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get countryRomania;

  /// No description provided for @countrySanMarino.
  ///
  /// In en, this message translates to:
  /// **'San Marino'**
  String get countrySanMarino;

  /// No description provided for @countrySerbia.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get countrySerbia;

  /// No description provided for @countrySlovakia.
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get countrySlovakia;

  /// No description provided for @countrySlovenia.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get countrySlovenia;

  /// No description provided for @countrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// No description provided for @countrySweden.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get countrySweden;

  /// No description provided for @countrySwitzerland.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get countrySwitzerland;

  /// No description provided for @countryUkraine.
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get countryUkraine;

  /// No description provided for @countryUnitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUnitedKingdom;

  /// No description provided for @countryVaticanCity.
  ///
  /// In en, this message translates to:
  /// **'Vatican City'**
  String get countryVaticanCity;

  /// No description provided for @hintSelectOne.
  ///
  /// In en, this message translates to:
  /// **'Select one option'**
  String get hintSelectOne;

  /// No description provided for @hintSelectMultiple.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get hintSelectMultiple;

  /// No description provided for @hintSearchAndSelect.
  ///
  /// In en, this message translates to:
  /// **'Search and select'**
  String get hintSearchAndSelect;

  /// No description provided for @hintTypeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Type your answer here'**
  String get hintTypeAnswer;

  /// No description provided for @hintOtherSpecify.
  ///
  /// In en, this message translates to:
  /// **'Other, specify'**
  String get hintOtherSpecify;

  /// No description provided for @hintChipsEmptyList.
  ///
  /// In en, this message translates to:
  /// **'No items selected'**
  String get hintChipsEmptyList;

  /// No description provided for @restrictedChipsNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches found'**
  String get restrictedChipsNoMatches;

  /// No description provided for @restrictedChipsStartTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get restrictedChipsStartTyping;

  /// No description provided for @pleaseSelectAtLeastOneOption.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one option'**
  String get pleaseSelectAtLeastOneOption;

  /// No description provided for @questionnaireCompleted.
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed the questionnaire!'**
  String get questionnaireCompleted;

  /// No description provided for @clearAllSelections.
  ///
  /// In en, this message translates to:
  /// **'Clear all selections'**
  String get clearAllSelections;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected ({count})'**
  String selectedCount(Object count);

  /// No description provided for @reviewAnswersTitle.
  ///
  /// In en, this message translates to:
  /// **'Review your answers'**
  String get reviewAnswersTitle;

  /// No description provided for @reviewAnswersLetsFind.
  ///
  /// In en, this message translates to:
  /// **'Let\'s find it!'**
  String get reviewAnswersLetsFind;

  /// No description provided for @reviewNoAnswer.
  ///
  /// In en, this message translates to:
  /// **'No answer'**
  String get reviewNoAnswer;

  /// No description provided for @reviewNoAnswersToDisplay.
  ///
  /// In en, this message translates to:
  /// **'No answers to display'**
  String get reviewNoAnswersToDisplay;

  /// No description provided for @reviewAnswerUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Answer updated successfully'**
  String get reviewAnswerUpdatedSuccessfully;

  /// No description provided for @uploadCvTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Your CV'**
  String get uploadCvTitle;

  /// No description provided for @uploadCvOneLastStep.
  ///
  /// In en, this message translates to:
  /// **'One last step'**
  String get uploadCvOneLastStep;

  /// No description provided for @uploadCvDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload your CV to help us match you with relevant internships'**
  String get uploadCvDescription;

  /// No description provided for @uploadCvHelpInfo.
  ///
  /// In en, this message translates to:
  /// **'This helps us understand your skills and experience better'**
  String get uploadCvHelpInfo;

  /// No description provided for @uploadCvUploadPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload your CV (PDF)'**
  String get uploadCvUploadPdf;

  /// No description provided for @uploadCvSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip it for now'**
  String get uploadCvSkipForNow;

  /// No description provided for @uploadCvLetsGetIt.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get It'**
  String get uploadCvLetsGetIt;

  /// No description provided for @uploadCvReadyToUpload.
  ///
  /// In en, this message translates to:
  /// **'CV ready to upload'**
  String get uploadCvReadyToUpload;

  /// No description provided for @uploadCvChooseDifferentFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a different file'**
  String get uploadCvChooseDifferentFile;

  /// No description provided for @uploadCvPleaseUploadFirst.
  ///
  /// In en, this message translates to:
  /// **'Please upload your CV first'**
  String get uploadCvPleaseUploadFirst;

  /// No description provided for @uploadCvFailedToPick.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick CV file'**
  String get uploadCvFailedToPick;

  /// No description provided for @uploadCvSuccessfullySaved.
  ///
  /// In en, this message translates to:
  /// **'CV successfully saved'**
  String get uploadCvSuccessfullySaved;

  /// No description provided for @uploadCvFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save CV'**
  String get uploadCvFailedToSave;

  /// No description provided for @processingFindingOpportunities.
  ///
  /// In en, this message translates to:
  /// **'Finding the perfect opportunities for you...'**
  String get processingFindingOpportunities;

  /// No description provided for @processingAnalyzingProfile.
  ///
  /// In en, this message translates to:
  /// **'We\'re analyzing your profile to match you with the best jobs'**
  String get processingAnalyzingProfile;

  /// No description provided for @processingFailedToProcess.
  ///
  /// In en, this message translates to:
  /// **'Failed to process your data. Please try again.'**
  String get processingFailedToProcess;

  /// No description provided for @processingErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String processingErrorOccurred(Object error);

  /// No description provided for @processingTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get processingTryAgain;

  /// No description provided for @processingGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get processingGoBack;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get greeting;

  /// No description provided for @internshipSearchQuestion.
  ///
  /// In en, this message translates to:
  /// **'In search for an internship?'**
  String get internshipSearchQuestion;

  /// No description provided for @profileUploadCvTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload your CV'**
  String get profileUploadCvTitle;

  /// No description provided for @uploadCvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'and get more accurate recommendations'**
  String get uploadCvSubtitle;

  /// No description provided for @cvUploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your CV has been successfully uploaded!'**
  String get cvUploadSuccess;

  /// No description provided for @cvUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV updated successfully'**
  String get cvUpdateSuccess;

  /// No description provided for @cvSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV saved successfully'**
  String get cvSaveSuccess;

  /// No description provided for @cvRemoveSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV removed successfully'**
  String get cvRemoveSuccess;

  /// No description provided for @cvRetrieveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve saved CV'**
  String get cvRetrieveError;

  /// No description provided for @cvPickError.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick CV'**
  String get cvPickError;

  /// No description provided for @cvUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update CV'**
  String get cvUpdateError;

  /// No description provided for @cvSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save CV'**
  String get cvSaveError;

  /// No description provided for @cvRemoveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove CV'**
  String get cvRemoveError;

  /// No description provided for @documentPreviewNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Document preview not supported'**
  String get documentPreviewNotSupported;

  /// No description provided for @replaceCvTooltip.
  ///
  /// In en, this message translates to:
  /// **'Replace CV'**
  String get replaceCvTooltip;

  /// No description provided for @deleteCvTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete CV'**
  String get deleteCvTooltip;

  /// No description provided for @uploadCvButtonText.
  ///
  /// In en, this message translates to:
  /// **'Upload CV'**
  String get uploadCvButtonText;

  /// No description provided for @questionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get questionSave;

  /// No description provided for @buttonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get buttonSave;

  /// No description provided for @editAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Answer'**
  String get editAnswerTitle;

  /// No description provided for @xyzFormulaTitle.
  ///
  /// In en, this message translates to:
  /// **'We recommend using the XYZ formula when writing your CV'**
  String get xyzFormulaTitle;

  /// No description provided for @xyzFormulaQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is the XYZ formula?'**
  String get xyzFormulaQuestion;

  /// No description provided for @xyzFormulaDescription.
  ///
  /// In en, this message translates to:
  /// **'A resume-writing technique used to showcase accomplishments in a clear and impactful way'**
  String get xyzFormulaDescription;

  /// No description provided for @xyzFormulaFormula.
  ///
  /// In en, this message translates to:
  /// **'Accomplished [X] as measured by [Y] by doing [Z]'**
  String get xyzFormulaFormula;

  /// No description provided for @xyzFormulaExampleLabel.
  ///
  /// In en, this message translates to:
  /// **'Example:'**
  String get xyzFormulaExampleLabel;

  /// No description provided for @xyzFormulaExampleText.
  ///
  /// In en, this message translates to:
  /// **'Increased sales (X = achievement) by 25% (Y = metric) by launching a new line of business in Q1 (Z = action)'**
  String get xyzFormulaExampleText;

  /// No description provided for @xyzFormulaTip.
  ///
  /// In en, this message translates to:
  /// **'Use this formula to make your achievements stand out in your CV'**
  String get xyzFormulaTip;

  /// No description provided for @settingsPageSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageSettings;

  /// No description provided for @settingsPageUserSettings.
  ///
  /// In en, this message translates to:
  /// **'User settings'**
  String get settingsPageUserSettings;

  /// No description provided for @settingsPageLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsPageLanguage;

  /// No description provided for @settingsPagePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPagePrivacyPolicy;

  /// No description provided for @settingsPageTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get settingsPageTermsOfUse;

  /// No description provided for @settingsPageGdprPolicy.
  ///
  /// In en, this message translates to:
  /// **'GDPR Policy'**
  String get settingsPageGdprPolicy;

  /// No description provided for @settingsPageFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get settingsPageFeedback;

  /// No description provided for @settingsPageRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get settingsPageRateUs;

  /// No description provided for @settingsPageUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get settingsPageUsername;

  /// No description provided for @settingsPageNoUsernameSet.
  ///
  /// In en, this message translates to:
  /// **'No username set'**
  String get settingsPageNoUsernameSet;

  /// No description provided for @settingsPageEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get settingsPageEnterUsername;

  /// No description provided for @settingsPageSaveProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your progress!'**
  String get settingsPageSaveProgressTitle;

  /// No description provided for @settingsPageSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'{email}!'**
  String settingsPageSignedInAs(String email);

  /// No description provided for @settingsPageSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In or Create Account'**
  String get settingsPageSignIn;

  /// No description provided for @settingsPageSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsPageSignOut;

  /// No description provided for @settingsPageYouAreSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You are signed in'**
  String get settingsPageYouAreSignedIn;

  /// No description provided for @settingsPageGuestMode.
  ///
  /// In en, this message translates to:
  /// **'*You are currently in Guest Mode'**
  String get settingsPageGuestMode;

  /// No description provided for @settingsPageQuestions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get settingsPageQuestions;

  /// No description provided for @settingsPageReviewAnsweredQuestions.
  ///
  /// In en, this message translates to:
  /// **'Review answered questions'**
  String get settingsPageReviewAnsweredQuestions;

  /// No description provided for @settingsPageTapToViewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Tap to view your answers'**
  String get settingsPageTapToViewAnswers;

  /// No description provided for @settingsPageDangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settingsPageDangerZone;

  /// No description provided for @settingsPageDeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsPageDeleteAllData;

  /// No description provided for @settingsPageActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get settingsPageActionCannotBeUndone;

  /// No description provided for @settingsPageDeleteAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get settingsPageDeleteAllDataConfirm;

  /// No description provided for @settingsPageDeleteAllDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. You will be returned to the welcome screen.'**
  String get settingsPageDeleteAllDataMessage;

  /// No description provided for @settingsPageCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsPageCancel;

  /// No description provided for @settingsPageDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get settingsPageDeleteAll;

  /// No description provided for @settingsPageUsernameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get settingsPageUsernameCannotBeEmpty;

  /// No description provided for @settingsPageUsernameUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Username updated successfully'**
  String get settingsPageUsernameUpdatedSuccessfully;

  /// No description provided for @settingsPageFailedToUpdateUsername.
  ///
  /// In en, this message translates to:
  /// **'Failed to update username'**
  String get settingsPageFailedToUpdateUsername;

  /// No description provided for @settingsPageErrorDeletingData.
  ///
  /// In en, this message translates to:
  /// **'Error deleting data: {error}'**
  String settingsPageErrorDeletingData(String error);

  /// No description provided for @settingsPageSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsPageSave;

  /// No description provided for @settingsPageEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get settingsPageEdit;

  /// No description provided for @settingsPageEditUsername.
  ///
  /// In en, this message translates to:
  /// **'Edit username'**
  String get settingsPageEditUsername;

  /// No description provided for @settingsPageTapToSaveOrCancel.
  ///
  /// In en, this message translates to:
  /// **'Tap ✓ to save or ✗ to cancel'**
  String get settingsPageTapToSaveOrCancel;

  /// No description provided for @settingsPageCouldNotLaunch.
  ///
  /// In en, this message translates to:
  /// **'Could not launch {url}'**
  String settingsPageCouldNotLaunch(String url);

  /// No description provided for @settingsGDPRPageTitle.
  ///
  /// In en, this message translates to:
  /// **'GDPR Policy'**
  String get settingsGDPRPageTitle;

  /// No description provided for @settingsGDPRPageCommitment.
  ///
  /// In en, this message translates to:
  /// **'Our Commitment to GDPR Compliance'**
  String get settingsGDPRPageCommitment;

  /// No description provided for @settingsGDPRPageCommitmentText.
  ///
  /// In en, this message translates to:
  /// **'At you\'ll get it, we are committed to ensuring the privacy and protection of your personal data in compliance with the General Data Protection Regulation (GDPR) and relevant Romanian data protection laws.'**
  String get settingsGDPRPageCommitmentText;

  /// No description provided for @settingsGDPRPageDataSubjectRights.
  ///
  /// In en, this message translates to:
  /// **'Data Subject Rights'**
  String get settingsGDPRPageDataSubjectRights;

  /// No description provided for @settingsGDPRPageDataSubjectRightsText.
  ///
  /// In en, this message translates to:
  /// **'Under the GDPR, you have the following rights:'**
  String get settingsGDPRPageDataSubjectRightsText;

  /// No description provided for @settingsGDPRPageRightToInformation.
  ///
  /// In en, this message translates to:
  /// **'Right to Information: Receive clear information about how we use your data.'**
  String get settingsGDPRPageRightToInformation;

  /// No description provided for @settingsGDPRPageRightOfAccess.
  ///
  /// In en, this message translates to:
  /// **'Right of Access: Obtain confirmation that we are processing your data and access your personal data.'**
  String get settingsGDPRPageRightOfAccess;

  /// No description provided for @settingsGDPRPageRightToRectification.
  ///
  /// In en, this message translates to:
  /// **'Right to Rectification: Have inaccurate personal data corrected or completed if incomplete.'**
  String get settingsGDPRPageRightToRectification;

  /// No description provided for @settingsGDPRPageRightToErasure.
  ///
  /// In en, this message translates to:
  /// **'Right to Erasure: Request deletion of your personal data in certain circumstances.'**
  String get settingsGDPRPageRightToErasure;

  /// No description provided for @settingsGDPRPageRightToRestriction.
  ///
  /// In en, this message translates to:
  /// **'Right to Restriction of Processing: Request restriction of processing in certain circumstances.'**
  String get settingsGDPRPageRightToRestriction;

  /// No description provided for @settingsGDPRPageRightToDataPortability.
  ///
  /// In en, this message translates to:
  /// **'Right to Data Portability: Receive your personal data in a structured, commonly used, machine-readable format.'**
  String get settingsGDPRPageRightToDataPortability;

  /// No description provided for @settingsGDPRPageRightToObject.
  ///
  /// In en, this message translates to:
  /// **'Right to Object: Object to processing based on legitimate interests or direct marketing.'**
  String get settingsGDPRPageRightToObject;

  /// No description provided for @settingsGDPRPageRightAutomatedDecision.
  ///
  /// In en, this message translates to:
  /// **'Rights Related to Automated Decision Making and Profiling: Not be subject to decisions based solely on automated processing that produce legal effects.'**
  String get settingsGDPRPageRightAutomatedDecision;

  /// No description provided for @settingsGDPRPageExerciseRights.
  ///
  /// In en, this message translates to:
  /// **'To exercise these rights, please contact us at '**
  String get settingsGDPRPageExerciseRights;

  /// No description provided for @settingsGDPRPageDataProtectionOfficer.
  ///
  /// In en, this message translates to:
  /// **'Data Protection Officer'**
  String get settingsGDPRPageDataProtectionOfficer;

  /// No description provided for @settingsGDPRPageContactUsAt.
  ///
  /// In en, this message translates to:
  /// **'Contact us at:'**
  String get settingsGDPRPageContactUsAt;

  /// No description provided for @settingsGDPRPageCompanyName.
  ///
  /// In en, this message translates to:
  /// **'YOU\'LL GET IT S.R.L.'**
  String get settingsGDPRPageCompanyName;

  /// No description provided for @settingsGDPRPageRegNo.
  ///
  /// In en, this message translates to:
  /// **'Reg. No: J2025027781008'**
  String get settingsGDPRPageRegNo;

  /// No description provided for @settingsGDPRPageCUI.
  ///
  /// In en, this message translates to:
  /// **'CUI: 51649682'**
  String get settingsGDPRPageCUI;

  /// No description provided for @settingsGDPRPageEUID.
  ///
  /// In en, this message translates to:
  /// **'EUID: ROONRC.J2025027781008'**
  String get settingsGDPRPageEUID;

  /// No description provided for @settingsGDPRPageContactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get settingsGDPRPageContactInformation;

  /// No description provided for @settingsGDPRPageContactUsText.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about our GDPR compliance, please contact: Email: '**
  String get settingsGDPRPageContactUsText;

  /// No description provided for @settingsGDPRPageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: April 9, 2025'**
  String get settingsGDPRPageLastUpdated;

  /// No description provided for @settingsPrivacyPolicyPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicyPageTitle;

  /// No description provided for @settingsPrivacyPolicyPageIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get settingsPrivacyPolicyPageIntroduction;

  /// No description provided for @settingsPrivacyPolicyPageIntroductionText.
  ///
  /// In en, this message translates to:
  /// **'At you\'ll get it, we respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application and website (collectively, the \"Platform\").'**
  String get settingsPrivacyPolicyPageIntroductionText;

  /// No description provided for @settingsPrivacyPolicyPageIntroductionText2.
  ///
  /// In en, this message translates to:
  /// **'We encourage you to read this Privacy Policy carefully to understand our practices regarding your personal data.'**
  String get settingsPrivacyPolicyPageIntroductionText2;

  /// No description provided for @settingsPrivacyPolicyPageInformationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get settingsPrivacyPolicyPageInformationWeCollect;

  /// No description provided for @settingsPrivacyPolicyPageInformationWeCollectText.
  ///
  /// In en, this message translates to:
  /// **'We may collect the following types of information:'**
  String get settingsPrivacyPolicyPageInformationWeCollectText;

  /// No description provided for @settingsPrivacyPolicyPagePersonalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get settingsPrivacyPolicyPagePersonalData;

  /// No description provided for @settingsPrivacyPolicyPagePersonalDataText.
  ///
  /// In en, this message translates to:
  /// **'Information that identifies you or can be used to identify you directly or indirectly, such as:'**
  String get settingsPrivacyPolicyPagePersonalDataText;

  /// No description provided for @settingsPrivacyPolicyPageContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact information (name, email address, phone number)'**
  String get settingsPrivacyPolicyPageContactInfo;

  /// No description provided for @settingsPrivacyPolicyPageAccountCredentials.
  ///
  /// In en, this message translates to:
  /// **'Account credentials (username, password)'**
  String get settingsPrivacyPolicyPageAccountCredentials;

  /// No description provided for @settingsPrivacyPolicyPageProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile information (profile picture, preferences)'**
  String get settingsPrivacyPolicyPageProfileInfo;

  /// No description provided for @settingsPrivacyPolicyPageDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device information (device ID, IP address, operating system)'**
  String get settingsPrivacyPolicyPageDeviceInfo;

  /// No description provided for @settingsPrivacyPolicyPageLocationData.
  ///
  /// In en, this message translates to:
  /// **'Location data (with your consent)'**
  String get settingsPrivacyPolicyPageLocationData;

  /// No description provided for @settingsPrivacyPolicyPageUsageData.
  ///
  /// In en, this message translates to:
  /// **'Usage data (how you interact with our Platform)'**
  String get settingsPrivacyPolicyPageUsageData;

  /// No description provided for @settingsPrivacyPolicyPageNonPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Non-Personal Data'**
  String get settingsPrivacyPolicyPageNonPersonalData;

  /// No description provided for @settingsPrivacyPolicyPageNonPersonalDataText.
  ///
  /// In en, this message translates to:
  /// **'Information that does not directly identify you, such as:'**
  String get settingsPrivacyPolicyPageNonPersonalDataText;

  /// No description provided for @settingsPrivacyPolicyPageAnonymousStats.
  ///
  /// In en, this message translates to:
  /// **'Anonymous usage statistics and analytics'**
  String get settingsPrivacyPolicyPageAnonymousStats;

  /// No description provided for @settingsPrivacyPolicyPageDemographicInfo.
  ///
  /// In en, this message translates to:
  /// **'Demographic information'**
  String get settingsPrivacyPolicyPageDemographicInfo;

  /// No description provided for @settingsPrivacyPolicyPageAggregatedBehavior.
  ///
  /// In en, this message translates to:
  /// **'Aggregated user behavior'**
  String get settingsPrivacyPolicyPageAggregatedBehavior;

  /// No description provided for @settingsPrivacyPolicyPageHowWeCollect.
  ///
  /// In en, this message translates to:
  /// **'How We Collect Information'**
  String get settingsPrivacyPolicyPageHowWeCollect;

  /// No description provided for @settingsPrivacyPolicyPageHowWeCollectText.
  ///
  /// In en, this message translates to:
  /// **'We collect information through:'**
  String get settingsPrivacyPolicyPageHowWeCollectText;

  /// No description provided for @settingsPrivacyPolicyPageDirectInteractions.
  ///
  /// In en, this message translates to:
  /// **'Direct interactions (when you register, contact us, or use our services)'**
  String get settingsPrivacyPolicyPageDirectInteractions;

  /// No description provided for @settingsPrivacyPolicyPageAutomatedTech.
  ///
  /// In en, this message translates to:
  /// **'Automated technologies (cookies, server logs, analytics tools)'**
  String get settingsPrivacyPolicyPageAutomatedTech;

  /// No description provided for @settingsPrivacyPolicyPageThirdPartySources.
  ///
  /// In en, this message translates to:
  /// **'Third-party sources (when permitted by law)'**
  String get settingsPrivacyPolicyPageThirdPartySources;

  /// No description provided for @settingsPrivacyPolicyPageHowWeUse.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get settingsPrivacyPolicyPageHowWeUse;

  /// No description provided for @settingsPrivacyPolicyPageHowWeUseText.
  ///
  /// In en, this message translates to:
  /// **'We use your information for the following purposes:'**
  String get settingsPrivacyPolicyPageHowWeUseText;

  /// No description provided for @settingsPrivacyPolicyPageProvideServices.
  ///
  /// In en, this message translates to:
  /// **'To provide and maintain our services'**
  String get settingsPrivacyPolicyPageProvideServices;

  /// No description provided for @settingsPrivacyPolicyPagePersonalize.
  ///
  /// In en, this message translates to:
  /// **'To personalize your experience'**
  String get settingsPrivacyPolicyPagePersonalize;

  /// No description provided for @settingsPrivacyPolicyPageCommunicate.
  ///
  /// In en, this message translates to:
  /// **'To communicate with you about our services'**
  String get settingsPrivacyPolicyPageCommunicate;

  /// No description provided for @settingsPrivacyPolicyPageProcessPayments.
  ///
  /// In en, this message translates to:
  /// **'To process payments and transactions'**
  String get settingsPrivacyPolicyPageProcessPayments;

  /// No description provided for @settingsPrivacyPolicyPageImprove.
  ///
  /// In en, this message translates to:
  /// **'To improve our Platform and develop new features'**
  String get settingsPrivacyPolicyPageImprove;

  /// No description provided for @settingsPrivacyPolicyPageAnalyze.
  ///
  /// In en, this message translates to:
  /// **'To analyze usage patterns and run analytics'**
  String get settingsPrivacyPolicyPageAnalyze;

  /// No description provided for @settingsPrivacyPolicyPageDetectIssues.
  ///
  /// In en, this message translates to:
  /// **'To detect, prevent, and address technical or security issues'**
  String get settingsPrivacyPolicyPageDetectIssues;

  /// No description provided for @settingsPrivacyPolicyPageComplyLegal.
  ///
  /// In en, this message translates to:
  /// **'To comply with legal obligations'**
  String get settingsPrivacyPolicyPageComplyLegal;

  /// No description provided for @settingsPrivacyPolicyPageLegalBasis.
  ///
  /// In en, this message translates to:
  /// **'Legal Basis for Processing'**
  String get settingsPrivacyPolicyPageLegalBasis;

  /// No description provided for @settingsPrivacyPolicyPageLegalBasisText.
  ///
  /// In en, this message translates to:
  /// **'We process your personal data on the following legal grounds:'**
  String get settingsPrivacyPolicyPageLegalBasisText;

  /// No description provided for @settingsPrivacyPolicyPageYourConsent.
  ///
  /// In en, this message translates to:
  /// **'Your consent'**
  String get settingsPrivacyPolicyPageYourConsent;

  /// No description provided for @settingsPrivacyPolicyPageContractPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance of a contract with you'**
  String get settingsPrivacyPolicyPageContractPerformance;

  /// No description provided for @settingsPrivacyPolicyPageLegalCompliance.
  ///
  /// In en, this message translates to:
  /// **'Compliance with legal obligations'**
  String get settingsPrivacyPolicyPageLegalCompliance;

  /// No description provided for @settingsPrivacyPolicyPageLegitimateInterests.
  ///
  /// In en, this message translates to:
  /// **'Our legitimate interests (which do not override your fundamental rights and freedoms)'**
  String get settingsPrivacyPolicyPageLegitimateInterests;

  /// No description provided for @settingsPrivacyPolicyPageInfoSharing.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing and Disclosure'**
  String get settingsPrivacyPolicyPageInfoSharing;

  /// No description provided for @settingsPrivacyPolicyPageInfoSharingText.
  ///
  /// In en, this message translates to:
  /// **'We may share your information with:'**
  String get settingsPrivacyPolicyPageInfoSharingText;

  /// No description provided for @settingsPrivacyPolicyPageServiceProviders.
  ///
  /// In en, this message translates to:
  /// **'Service providers who help us deliver our services'**
  String get settingsPrivacyPolicyPageServiceProviders;

  /// No description provided for @settingsPrivacyPolicyPageBusinessPartners.
  ///
  /// In en, this message translates to:
  /// **'Business partners with your consent'**
  String get settingsPrivacyPolicyPageBusinessPartners;

  /// No description provided for @settingsPrivacyPolicyPageLegalAuthorities.
  ///
  /// In en, this message translates to:
  /// **'Legal authorities when required by law'**
  String get settingsPrivacyPolicyPageLegalAuthorities;

  /// No description provided for @settingsPrivacyPolicyPageAffiliatedCompanies.
  ///
  /// In en, this message translates to:
  /// **'Affiliated companies within our corporate group'**
  String get settingsPrivacyPolicyPageAffiliatedCompanies;

  /// No description provided for @settingsPrivacyPolicyPageSuccessorEntity.
  ///
  /// In en, this message translates to:
  /// **'A successor entity in the event of a merger, acquisition, or similar transaction'**
  String get settingsPrivacyPolicyPageSuccessorEntity;

  /// No description provided for @settingsPrivacyPolicyPageNoSelling.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal data to third parties.'**
  String get settingsPrivacyPolicyPageNoSelling;

  /// No description provided for @settingsPrivacyPolicyPageDataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get settingsPrivacyPolicyPageDataSecurity;

  /// No description provided for @settingsPrivacyPolicyPageDataSecurityText.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the Internet or electronic storage is 100% secure, so we cannot guarantee absolute security.'**
  String get settingsPrivacyPolicyPageDataSecurityText;

  /// No description provided for @settingsPrivacyPolicyPageDataRetention.
  ///
  /// In en, this message translates to:
  /// **'Data Retention'**
  String get settingsPrivacyPolicyPageDataRetention;

  /// No description provided for @settingsPrivacyPolicyPageDataRetentionText.
  ///
  /// In en, this message translates to:
  /// **'We retain your personal data only for as long as necessary to fulfill the purposes for which it was collected, including for legal, accounting, or reporting requirements. When determining the appropriate retention period, we consider the amount, nature, and sensitivity of the data, the potential risk of harm from unauthorized use or disclosure, and the purposes for which we process the data.'**
  String get settingsPrivacyPolicyPageDataRetentionText;

  /// No description provided for @settingsPrivacyPolicyPageDataProtectionRights.
  ///
  /// In en, this message translates to:
  /// **'Your Data Protection Rights'**
  String get settingsPrivacyPolicyPageDataProtectionRights;

  /// No description provided for @settingsPrivacyPolicyPageDataProtectionRightsText.
  ///
  /// In en, this message translates to:
  /// **'Under applicable data protection laws, you may have the following rights:'**
  String get settingsPrivacyPolicyPageDataProtectionRightsText;

  /// No description provided for @settingsPrivacyPolicyPageRightAccess.
  ///
  /// In en, this message translates to:
  /// **'Right to access your personal data'**
  String get settingsPrivacyPolicyPageRightAccess;

  /// No description provided for @settingsPrivacyPolicyPageRightRectify.
  ///
  /// In en, this message translates to:
  /// **'Right to rectify inaccurate or incomplete data'**
  String get settingsPrivacyPolicyPageRightRectify;

  /// No description provided for @settingsPrivacyPolicyPageRightErasure.
  ///
  /// In en, this message translates to:
  /// **'Right to erasure (the \"right to be forgotten\")'**
  String get settingsPrivacyPolicyPageRightErasure;

  /// No description provided for @settingsPrivacyPolicyPageRightRestrict.
  ///
  /// In en, this message translates to:
  /// **'Right to restrict processing'**
  String get settingsPrivacyPolicyPageRightRestrict;

  /// No description provided for @settingsPrivacyPolicyPageRightPortability.
  ///
  /// In en, this message translates to:
  /// **'Right to data portability'**
  String get settingsPrivacyPolicyPageRightPortability;

  /// No description provided for @settingsPrivacyPolicyPageRightObject.
  ///
  /// In en, this message translates to:
  /// **'Right to object to processing'**
  String get settingsPrivacyPolicyPageRightObject;

  /// No description provided for @settingsPrivacyPolicyPageRightWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Right to withdraw consent'**
  String get settingsPrivacyPolicyPageRightWithdraw;

  /// No description provided for @settingsPrivacyPolicyPageRightComplaint.
  ///
  /// In en, this message translates to:
  /// **'Right to lodge a complaint with a supervisory authority'**
  String get settingsPrivacyPolicyPageRightComplaint;

  /// No description provided for @settingsPrivacyPolicyPageExerciseRights.
  ///
  /// In en, this message translates to:
  /// **'To exercise these rights, please contact us using the information provided at the end of this Privacy Policy.'**
  String get settingsPrivacyPolicyPageExerciseRights;

  /// No description provided for @settingsPrivacyPolicyPageChildrensPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get settingsPrivacyPolicyPageChildrensPrivacy;

  /// No description provided for @settingsPrivacyPolicyPageChildrensPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'Our Platform is not intended for children under 16 years of age. We do not knowingly collect personal data from children under 16. If we learn that we have collected personal data from a child under 16, we will take steps to delete that information as quickly as possible. If you believe we might have any information from or about a child under 16, please contact us.'**
  String get settingsPrivacyPolicyPageChildrensPrivacyText;

  /// No description provided for @settingsPrivacyPolicyPageCookies.
  ///
  /// In en, this message translates to:
  /// **'Cookies and Tracking Technologies'**
  String get settingsPrivacyPolicyPageCookies;

  /// No description provided for @settingsPrivacyPolicyPageCookiesText.
  ///
  /// In en, this message translates to:
  /// **'We use cookies and similar tracking technologies to collect information about your browsing activities and to remember your preferences. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Platform.'**
  String get settingsPrivacyPolicyPageCookiesText;

  /// No description provided for @settingsPrivacyPolicyPageInternationalTransfers.
  ///
  /// In en, this message translates to:
  /// **'International Data Transfers'**
  String get settingsPrivacyPolicyPageInternationalTransfers;

  /// No description provided for @settingsPrivacyPolicyPageInternationalTransfersText.
  ///
  /// In en, this message translates to:
  /// **'Your personal data may be transferred to and processed in countries other than the country in which you reside. These countries may have different data protection laws than your country. When we transfer your data internationally, we take measures to ensure that appropriate safeguards are in place to protect your data and to ensure that you can exercise your rights effectively.'**
  String get settingsPrivacyPolicyPageInternationalTransfersText;

  /// No description provided for @settingsPrivacyPolicyPageChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Privacy Policy'**
  String get settingsPrivacyPolicyPageChanges;

  /// No description provided for @settingsPrivacyPolicyPageChangesText.
  ///
  /// In en, this message translates to:
  /// **'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last Updated\" date. You are advised to review this Privacy Policy periodically for any changes.'**
  String get settingsPrivacyPolicyPageChangesText;

  /// No description provided for @settingsPrivacyPolicyPageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settingsPrivacyPolicyPageContactUs;

  /// No description provided for @settingsPrivacyPolicyPageContactUsText.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at '**
  String get settingsPrivacyPolicyPageContactUsText;

  /// No description provided for @settingsPrivacyPolicyPageCompanyInformation.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get settingsPrivacyPolicyPageCompanyInformation;

  /// No description provided for @settingsPrivacyPolicyPageCompanyName.
  ///
  /// In en, this message translates to:
  /// **'YOU\'LL GET IT S.R.L.'**
  String get settingsPrivacyPolicyPageCompanyName;

  /// No description provided for @settingsPrivacyPolicyPageRegNo.
  ///
  /// In en, this message translates to:
  /// **'Reg. No: J2025027781008'**
  String get settingsPrivacyPolicyPageRegNo;

  /// No description provided for @settingsPrivacyPolicyPageCUI.
  ///
  /// In en, this message translates to:
  /// **'CUI: 51649682'**
  String get settingsPrivacyPolicyPageCUI;

  /// No description provided for @settingsPrivacyPolicyPageEUID.
  ///
  /// In en, this message translates to:
  /// **'EUID: ROONRC.J2025027781008'**
  String get settingsPrivacyPolicyPageEUID;

  /// No description provided for @settingsPrivacyPolicyPageEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: '**
  String get settingsPrivacyPolicyPageEmail;

  /// No description provided for @settingsPrivacyPolicyPageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: April 9, 2025'**
  String get settingsPrivacyPolicyPageLastUpdated;

  /// No description provided for @settingsTermsOfServicePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfServicePageTitle;

  /// No description provided for @settingsTermsOfServicePageIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get settingsTermsOfServicePageIntroduction;

  /// No description provided for @settingsTermsOfServicePageIntroductionText.
  ///
  /// In en, this message translates to:
  /// **'These Terms of Service (\"Terms\") govern your access to and use of you\'ll get it\'s website and mobile application (collectively, the \"Platform\"). Please read these Terms carefully before using our Platform.'**
  String get settingsTermsOfServicePageIntroductionText;

  /// No description provided for @settingsTermsOfServicePageAcceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get settingsTermsOfServicePageAcceptanceOfTerms;

  /// No description provided for @settingsTermsOfServicePageAcceptanceOfTermsText.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using our Platform, you agree to be bound by these Terms. If you do not agree to these Terms, you must not access or use our Platform.'**
  String get settingsTermsOfServicePageAcceptanceOfTermsText;

  /// No description provided for @settingsTermsOfServicePageEligibility.
  ///
  /// In en, this message translates to:
  /// **'Eligibility'**
  String get settingsTermsOfServicePageEligibility;

  /// No description provided for @settingsTermsOfServicePageEligibilityText.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 16 years old to use our Platform. By using our Platform, you represent and warrant that you meet this requirement.'**
  String get settingsTermsOfServicePageEligibilityText;

  /// No description provided for @settingsTermsOfServicePageAccountRegistration.
  ///
  /// In en, this message translates to:
  /// **'Account Registration'**
  String get settingsTermsOfServicePageAccountRegistration;

  /// No description provided for @settingsTermsOfServicePageAccountRegistrationText.
  ///
  /// In en, this message translates to:
  /// **'To access certain features of our Platform, you must register for an account. When you register, you agree to:'**
  String get settingsTermsOfServicePageAccountRegistrationText;

  /// No description provided for @settingsTermsOfServicePageProvideAccurateInfo.
  ///
  /// In en, this message translates to:
  /// **'Provide accurate, current, and complete information'**
  String get settingsTermsOfServicePageProvideAccurateInfo;

  /// No description provided for @settingsTermsOfServicePageMaintainAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Maintain and promptly update your account information'**
  String get settingsTermsOfServicePageMaintainAccountInfo;

  /// No description provided for @settingsTermsOfServicePageKeepPasswordSecure.
  ///
  /// In en, this message translates to:
  /// **'Keep your password secure and confidential'**
  String get settingsTermsOfServicePageKeepPasswordSecure;

  /// No description provided for @settingsTermsOfServicePageBeResponsible.
  ///
  /// In en, this message translates to:
  /// **'Be responsible for all activities that occur under your account'**
  String get settingsTermsOfServicePageBeResponsible;

  /// No description provided for @settingsTermsOfServicePageDisableAccount.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to disable any account if we believe you have violated these Terms.'**
  String get settingsTermsOfServicePageDisableAccount;

  /// No description provided for @settingsTermsOfServicePagePlatformUse.
  ///
  /// In en, this message translates to:
  /// **'Platform Use and Restrictions'**
  String get settingsTermsOfServicePagePlatformUse;

  /// No description provided for @settingsTermsOfServicePagePlatformUseText.
  ///
  /// In en, this message translates to:
  /// **'You may use our Platform only for lawful purposes and in accordance with these Terms. You agree not to:'**
  String get settingsTermsOfServicePagePlatformUseText;

  /// No description provided for @settingsTermsOfServicePageNoViolateLaws.
  ///
  /// In en, this message translates to:
  /// **'Use the Platform in any way that violates applicable laws or regulations'**
  String get settingsTermsOfServicePageNoViolateLaws;

  /// No description provided for @settingsTermsOfServicePageNoImpersonate.
  ///
  /// In en, this message translates to:
  /// **'Impersonate any person or entity or misrepresent your affiliation'**
  String get settingsTermsOfServicePageNoImpersonate;

  /// No description provided for @settingsTermsOfServicePageNoRestrictUse.
  ///
  /// In en, this message translates to:
  /// **'Engage in any conduct that restricts or inhibits anyone\'s use of the Platform'**
  String get settingsTermsOfServicePageNoRestrictUse;

  /// No description provided for @settingsTermsOfServicePageNoUnauthorizedAccess.
  ///
  /// In en, this message translates to:
  /// **'Attempt to gain unauthorized access to any part of the Platform'**
  String get settingsTermsOfServicePageNoUnauthorizedAccess;

  /// No description provided for @settingsTermsOfServicePageNoAutomatedDevices.
  ///
  /// In en, this message translates to:
  /// **'Use any robot, spider, or other automated device to access the Platform except for search engines and public archives'**
  String get settingsTermsOfServicePageNoAutomatedDevices;

  /// No description provided for @settingsTermsOfServicePageNoUnsolicitedComms.
  ///
  /// In en, this message translates to:
  /// **'Use the Platform to send unsolicited communications'**
  String get settingsTermsOfServicePageNoUnsolicitedComms;

  /// No description provided for @settingsTermsOfServicePageNoHarvestInfo.
  ///
  /// In en, this message translates to:
  /// **'Harvest or collect email addresses or other contact information'**
  String get settingsTermsOfServicePageNoHarvestInfo;

  /// No description provided for @settingsTermsOfServicePageNoCommercialUse.
  ///
  /// In en, this message translates to:
  /// **'Use the Platform for any commercial purpose not expressly approved by us'**
  String get settingsTermsOfServicePageNoCommercialUse;

  /// No description provided for @settingsTermsOfServicePageIntellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property Rights'**
  String get settingsTermsOfServicePageIntellectualProperty;

  /// No description provided for @settingsTermsOfServicePageIntellectualPropertyText.
  ///
  /// In en, this message translates to:
  /// **'The Platform and its content, features, and functionality are owned by you\'ll get it and are protected by copyright, trademark, and other intellectual property laws.'**
  String get settingsTermsOfServicePageIntellectualPropertyText;

  /// No description provided for @settingsTermsOfServicePageUserContent.
  ///
  /// In en, this message translates to:
  /// **'User Content'**
  String get settingsTermsOfServicePageUserContent;

  /// No description provided for @settingsTermsOfServicePageUserContentText.
  ///
  /// In en, this message translates to:
  /// **'You retain any rights you may have in content you submit to the Platform (\"User Content\"). By submitting User Content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, distribute, and display such User Content.'**
  String get settingsTermsOfServicePageUserContentText;

  /// No description provided for @settingsTermsOfServicePageRepresentWarrant.
  ///
  /// In en, this message translates to:
  /// **'You represent and warrant that:'**
  String get settingsTermsOfServicePageRepresentWarrant;

  /// No description provided for @settingsTermsOfServicePageOwnRights.
  ///
  /// In en, this message translates to:
  /// **'You own or have the necessary rights to your User Content'**
  String get settingsTermsOfServicePageOwnRights;

  /// No description provided for @settingsTermsOfServicePageNoViolateRights.
  ///
  /// In en, this message translates to:
  /// **'Your User Content does not violate the rights of any third party'**
  String get settingsTermsOfServicePageNoViolateRights;

  /// No description provided for @settingsTermsOfServicePageCompliesTerms.
  ///
  /// In en, this message translates to:
  /// **'Your User Content complies with these Terms and applicable laws'**
  String get settingsTermsOfServicePageCompliesTerms;

  /// No description provided for @settingsTermsOfServicePageRemoveContent.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to remove any User Content that violates these Terms or that we find objectionable.'**
  String get settingsTermsOfServicePageRemoveContent;

  /// No description provided for @settingsTermsOfServicePageThirdPartyLinks.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Links and Content'**
  String get settingsTermsOfServicePageThirdPartyLinks;

  /// No description provided for @settingsTermsOfServicePageThirdPartyLinksText.
  ///
  /// In en, this message translates to:
  /// **'The Platform may contain links to third-party websites or services. We do not control or endorse these websites or services and are not responsible for their content, privacy policies, or practices.'**
  String get settingsTermsOfServicePageThirdPartyLinksText;

  /// No description provided for @settingsTermsOfServicePageDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer of Warranties'**
  String get settingsTermsOfServicePageDisclaimer;

  /// No description provided for @settingsTermsOfServicePageDisclaimerText.
  ///
  /// In en, this message translates to:
  /// **'THE PLATFORM IS PROVIDED \"AS IS\" AND \"AS AVAILABLE\" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. TO THE FULLEST EXTENT PERMITTED BY LAW, WE DISCLAIM ALL WARRANTIES, INCLUDING IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.'**
  String get settingsTermsOfServicePageDisclaimerText;

  /// No description provided for @settingsTermsOfServicePageLimitationLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get settingsTermsOfServicePageLimitationLiability;

  /// No description provided for @settingsTermsOfServicePageLimitationLiabilityText.
  ///
  /// In en, this message translates to:
  /// **'TO THE FULLEST EXTENT PERMITTED BY LAW, you\'ll get it SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING OUT OF OR RELATING TO YOUR USE OF THE PLATFORM.'**
  String get settingsTermsOfServicePageLimitationLiabilityText;

  /// No description provided for @settingsTermsOfServicePageIndemnification.
  ///
  /// In en, this message translates to:
  /// **'Indemnification'**
  String get settingsTermsOfServicePageIndemnification;

  /// No description provided for @settingsTermsOfServicePageIndemnificationText.
  ///
  /// In en, this message translates to:
  /// **'You agree to indemnify and hold harmless you\'ll get it and its officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses arising out of or relating to your use of the Platform or violation of these Terms.'**
  String get settingsTermsOfServicePageIndemnificationText;

  /// No description provided for @settingsTermsOfServicePageGoverningLaw.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get settingsTermsOfServicePageGoverningLaw;

  /// No description provided for @settingsTermsOfServicePageGoverningLawText.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed by and construed in accordance with the laws of Romania, without regard to its conflict of law provisions.'**
  String get settingsTermsOfServicePageGoverningLawText;

  /// No description provided for @settingsTermsOfServicePageDisputeResolution.
  ///
  /// In en, this message translates to:
  /// **'Dispute Resolution'**
  String get settingsTermsOfServicePageDisputeResolution;

  /// No description provided for @settingsTermsOfServicePageDisputeResolutionText.
  ///
  /// In en, this message translates to:
  /// **'Any dispute arising out of or relating to these Terms or the Platform shall be resolved by the courts of Romania.'**
  String get settingsTermsOfServicePageDisputeResolutionText;

  /// No description provided for @settingsTermsOfServicePageChangesToTerms.
  ///
  /// In en, this message translates to:
  /// **'Changes to These Terms'**
  String get settingsTermsOfServicePageChangesToTerms;

  /// No description provided for @settingsTermsOfServicePageChangesToTermsText.
  ///
  /// In en, this message translates to:
  /// **'We may update these Terms from time to time. The updated version will be indicated by an updated \"Last Updated\" date.'**
  String get settingsTermsOfServicePageChangesToTermsText;

  /// No description provided for @settingsTermsOfServicePageTermination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get settingsTermsOfServicePageTermination;

  /// No description provided for @settingsTermsOfServicePageTerminationText.
  ///
  /// In en, this message translates to:
  /// **'We may terminate or suspend your access to the Platform immediately, without prior notice or liability, for any reason, including if you breach these Terms.'**
  String get settingsTermsOfServicePageTerminationText;

  /// No description provided for @settingsTermsOfServicePageSeverability.
  ///
  /// In en, this message translates to:
  /// **'Severability'**
  String get settingsTermsOfServicePageSeverability;

  /// No description provided for @settingsTermsOfServicePageSeverabilityText.
  ///
  /// In en, this message translates to:
  /// **'If any provision of these Terms is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall be enforced.'**
  String get settingsTermsOfServicePageSeverabilityText;

  /// No description provided for @settingsTermsOfServicePageEntireAgreement.
  ///
  /// In en, this message translates to:
  /// **'Entire Agreement'**
  String get settingsTermsOfServicePageEntireAgreement;

  /// No description provided for @settingsTermsOfServicePageEntireAgreementText.
  ///
  /// In en, this message translates to:
  /// **'These Terms constitute the entire agreement between you and you\'ll get it regarding the Platform.'**
  String get settingsTermsOfServicePageEntireAgreementText;

  /// No description provided for @settingsTermsOfServicePageContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get settingsTermsOfServicePageContactUs;

  /// No description provided for @settingsTermsOfServicePageContactUsText.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms, please contact us at '**
  String get settingsTermsOfServicePageContactUsText;

  /// No description provided for @settingsTermsOfServicePageLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: April 9, 2025'**
  String get settingsTermsOfServicePageLastUpdated;

  /// No description provided for @settingsPageDeletingData.
  ///
  /// In en, this message translates to:
  /// **'Deleting data...'**
  String get settingsPageDeletingData;

  /// No description provided for @jobCardSwiperWaitingForConnection.
  ///
  /// In en, this message translates to:
  /// **'Waiting for internet connection...'**
  String get jobCardSwiperWaitingForConnection;

  /// No description provided for @jobCardSwiperRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get jobCardSwiperRetry;

  /// No description provided for @jobCardSwiperLoadingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Loading job recommendations...'**
  String get jobCardSwiperLoadingRecommendations;

  /// No description provided for @jobCardSwiperOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Some features may be limited.'**
  String get jobCardSwiperOfflineNotice;

  /// No description provided for @jobCardDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline:'**
  String get jobCardDeadline;

  /// No description provided for @jobCardJobDetails.
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobCardJobDetails;

  /// No description provided for @jobCardMonths.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get jobCardMonths;

  /// No description provided for @jobCardEducationRequirements.
  ///
  /// In en, this message translates to:
  /// **'Education Requirements'**
  String get jobCardEducationRequirements;

  /// No description provided for @jobCardRequiredLanguages.
  ///
  /// In en, this message translates to:
  /// **'Required Languages'**
  String get jobCardRequiredLanguages;

  /// No description provided for @jobCardVisaSupport.
  ///
  /// In en, this message translates to:
  /// **'Visa Support'**
  String get jobCardVisaSupport;

  /// No description provided for @jobCardRelatedFields.
  ///
  /// In en, this message translates to:
  /// **'Related Fields'**
  String get jobCardRelatedFields;

  /// No description provided for @jobCardTapToSeeSkills.
  ///
  /// In en, this message translates to:
  /// **'Tap to see skills'**
  String get jobCardTapToSeeSkills;

  /// No description provided for @jobCardSkillsRequirements.
  ///
  /// In en, this message translates to:
  /// **'Skills & Requirements'**
  String get jobCardSkillsRequirements;

  /// No description provided for @jobCardTechnicalSkills.
  ///
  /// In en, this message translates to:
  /// **'Technical Skills'**
  String get jobCardTechnicalSkills;

  /// No description provided for @jobCardSoftSkills.
  ///
  /// In en, this message translates to:
  /// **'Soft Skills'**
  String get jobCardSoftSkills;

  /// No description provided for @jobCardNiceToHave.
  ///
  /// In en, this message translates to:
  /// **'Nice-to-Have'**
  String get jobCardNiceToHave;

  /// No description provided for @jobCardTapToSeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to see details'**
  String get jobCardTapToSeeDetails;

  /// No description provided for @jobCardNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get jobCardNotSpecified;

  /// No description provided for @jobCardInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get jobCardInvalidDate;

  /// No description provided for @jobCardNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get jobCardNotAvailable;

  /// No description provided for @jobCardNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get jobCardNotFound;

  /// No description provided for @workModeRemote.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get workModeRemote;

  /// No description provided for @workModeHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get workModeHybrid;

  /// No description provided for @workModeOnSite.
  ///
  /// In en, this message translates to:
  /// **'On-site'**
  String get workModeOnSite;

  /// No description provided for @jobSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Search'**
  String get jobSearchTitle;

  /// No description provided for @jobSearchScrollToDiscover.
  ///
  /// In en, this message translates to:
  /// **'Scroll to discover more jobs'**
  String get jobSearchScrollToDiscover;

  /// No description provided for @jobSearchNoInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get jobSearchNoInternetConnection;

  /// No description provided for @jobSearchNoJobsFound.
  ///
  /// In en, this message translates to:
  /// **'No jobs found'**
  String get jobSearchNoJobsFound;

  /// No description provided for @jobSearchCheckConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again'**
  String get jobSearchCheckConnection;

  /// No description provided for @jobSearchTryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search query'**
  String get jobSearchTryAdjustingFilters;

  /// No description provided for @jobSearchRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get jobSearchRetry;

  /// No description provided for @jobSearchResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get jobSearchResetFilters;

  /// No description provided for @jobSearchOfflineNotice.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Search functionality is limited.'**
  String get jobSearchOfflineNotice;

  /// No description provided for @jobSearchNoInternetSnackbar.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get jobSearchNoInternetSnackbar;

  /// No description provided for @jobSearchErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading jobs: {error}'**
  String jobSearchErrorLoading(String error);

  /// No description provided for @jobSearchAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'{jobName} added to favorites'**
  String jobSearchAddedToFavorites(String jobName);

  /// No description provided for @jobFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Jobs'**
  String get jobFiltersTitle;

  /// No description provided for @jobFiltersResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get jobFiltersResetAll;

  /// No description provided for @jobFiltersSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get jobFiltersSearch;

  /// No description provided for @jobFiltersSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search jobs, titles...'**
  String get jobFiltersSearchPlaceholder;

  /// No description provided for @jobFiltersCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get jobFiltersCompany;

  /// No description provided for @jobFiltersCompanyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get jobFiltersCompanyPlaceholder;

  /// No description provided for @jobFiltersLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get jobFiltersLocation;

  /// No description provided for @jobFiltersLocationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter location/country'**
  String get jobFiltersLocationPlaceholder;

  /// No description provided for @jobFiltersDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get jobFiltersDuration;

  /// No description provided for @jobFiltersField.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get jobFiltersField;

  /// No description provided for @jobFiltersWorkMode.
  ///
  /// In en, this message translates to:
  /// **'Work Mode'**
  String get jobFiltersWorkMode;

  /// No description provided for @jobFiltersSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get jobFiltersSkills;

  /// No description provided for @jobFiltersApplyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get jobFiltersApplyFilters;

  /// No description provided for @jobFiltersSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get jobFiltersSelected;

  /// No description provided for @jobListItemKeySkills.
  ///
  /// In en, this message translates to:
  /// **'Key Skills:'**
  String get jobListItemKeySkills;

  /// No description provided for @jobListItemRelatedFields.
  ///
  /// In en, this message translates to:
  /// **'Related Fields:'**
  String get jobListItemRelatedFields;

  /// No description provided for @jobListItemViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get jobListItemViewDetails;

  /// No description provided for @jobListItemSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get jobListItemSave;

  /// No description provided for @jobListItemNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get jobListItemNotSpecified;

  /// No description provided for @jobListItemInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get jobListItemInvalid;

  /// No description provided for @jobListItemExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get jobListItemExpired;

  /// No description provided for @jobListItemToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get jobListItemToday;

  /// No description provided for @jobListItemTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get jobListItemTomorrow;

  /// No description provided for @jobListItemDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days}d left'**
  String jobListItemDaysLeft(String days);

  /// Title for the job details page
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetails;

  /// Tooltip for opening job in browser
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openInBrowser;

  /// Label for job location
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Label for application deadline
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// Label for work mode (remote, hybrid, onsite)
  ///
  /// In en, this message translates to:
  /// **'Work Mode'**
  String get workMode;

  /// Label for salary information
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// Label for job duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Duration in months
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month} other{{count} months}}'**
  String monthsCount(int count);

  /// Label for time commitment
  ///
  /// In en, this message translates to:
  /// **'Time Commitment'**
  String get timeCommitment;

  /// Label for internship season
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// Label for visa assistance
  ///
  /// In en, this message translates to:
  /// **'Visa Help'**
  String get visaHelp;

  /// Title for the job details section
  ///
  /// In en, this message translates to:
  /// **'Job Details'**
  String get jobDetailsTitle;

  /// Title for education requirements section
  ///
  /// In en, this message translates to:
  /// **'Education Requirements'**
  String get educationRequirements;

  /// Label for required degree
  ///
  /// In en, this message translates to:
  /// **'Required Degree'**
  String get requiredDegree;

  /// Label for allowed graduation years
  ///
  /// In en, this message translates to:
  /// **'Graduation Years'**
  String get graduationYears;

  /// Title for skills section
  ///
  /// In en, this message translates to:
  /// **'Skills & Qualifications'**
  String get skillsAndQualifications;

  /// Label for technical/hard skills
  ///
  /// In en, this message translates to:
  /// **'Technical Skills'**
  String get technicalSkills;

  /// Label for soft skills
  ///
  /// In en, this message translates to:
  /// **'Soft Skills'**
  String get softSkills;

  /// Label for required languages
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Label for nice-to-have skills
  ///
  /// In en, this message translates to:
  /// **'Nice-to-Have'**
  String get niceToHave;

  /// Title for job description section
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get jobDescription;

  /// Title for requirements section
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// Button text for applying to job
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// Text when deadline is not specified
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// Text when deadline has passed
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Text when deadline is today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Text when deadline is tomorrow
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Text for deadline in X days
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String inDays(int count);

  /// Format for month and day
  ///
  /// In en, this message translates to:
  /// **'{month, select, 1{Jan} 2{Feb} 3{Mar} 4{Apr} 5{May} 6{Jun} 7{Jul} 8{Aug} 9{Sep} 10{Oct} 11{Nov} 12{Dec} other{}} {day}'**
  String monthDay(String month, String day);

  /// Text when date format is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get invalidDate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'nl', 'ro'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'nl': return AppLocalizationsNl();
    case 'ro': return AppLocalizationsRo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
