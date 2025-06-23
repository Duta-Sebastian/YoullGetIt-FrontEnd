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
