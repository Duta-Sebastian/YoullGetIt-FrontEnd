import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionTranslationService {
  static String getTranslatedQuestionText(String questionId, AppLocalizations l10n) {
    switch (questionId) {
      case 'q1': return l10n.questionStudyLevel;
      case 'q2': return l10n.questionStillStudent;
      case 'q2_yes_1': return l10n.questionWhatYear;
      case 'q2_yes_2': return l10n.questionWhenFinish;
      case 'q3': return l10n.questionUniversityType;
      case 'q4': return l10n.questionStudyField;
      case 'q4_eng': return l10n.questionEngineeringType;
      case 'q4_it': return l10n.questionItArea;
      case 'q5': return l10n.questionOtherSpecializations;
      case 'q6': return l10n.questionPriorExperience;
      case 'q7': return l10n.questionOtherFields;
      case 'q8': return l10n.questionSoftSkills;
      case 'q9': return l10n.questionHardSkills;
      case 'q10': return l10n.questionLanguagesComfortable;
      case 'q11': return l10n.questionCountriesSearch;
      case 'q12': return l10n.questionAvailability;
      case 'q13': return l10n.questionInternshipLength;
      case 'q14': return l10n.questionRequireVisa;
      case 'q15': return l10n.questionConsiderTraineeships;
      default: return questionId; // Fallback to original
    }
  }

  static List<String> getTranslatedOptions(String questionId, List<String> originalOptions, AppLocalizations l10n) {
    switch (questionId) {
      case 'q1': // Study level
        return originalOptions.map((option) {
          switch (option) {
            case 'Highschool': return l10n.optionHighschool;
            case 'Bachelor': return l10n.optionBachelor;
            case 'Master': return l10n.optionMaster;
            case 'PhD': return l10n.optionPhd;
            default: return option;
          }
        }).toList();

      case 'q2': // Still student
      case 'q15': // Consider traineeships
        return originalOptions.map((option) {
          switch (option) {
            case 'Yes': return l10n.optionYes;
            case 'No': return l10n.optionNo;
            case 'Maybe': return l10n.optionMaybe;
            default: return option;
          }
        }).toList();

      case 'q2_yes_1': // What year
        return originalOptions.map((option) {
          switch (option) {
            case '1st Year': return l10n.optionFirstYear;
            case '2nd Year': return l10n.optionSecondYear;
            case '3rd Year': return l10n.optionThirdYear;
            case '4th Year': return l10n.optionFourthYear;
            default: return option;
          }
        }).toList();

      case 'q3': // University type
        return originalOptions.map((option) {
          switch (option) {
            case 'Research': return l10n.optionResearch;
            case 'Applied': return l10n.optionApplied;
            default: return option;
          }
        }).toList();

      case 'q4': // Study field
      case 'q5': // Other specializations
      case 'q7': // Other fields
        return originalOptions.map((option) {
          switch (option) {
            case 'Engineering': return l10n.optionEngineering;
            case 'IT & Data Science': return l10n.optionItDataScience;
            case 'Marketing & Communication': return l10n.optionMarketingCommunication;
            case 'Finance & Economics': return l10n.optionFinanceEconomics;
            case 'Political Science & Public Administration': return l10n.optionPoliticalScience;
            case 'Sales & Business Administration': return l10n.optionSalesBusiness;
            case 'Arts & Culture': return l10n.optionArtsCulture;
            case 'Biology, Chemistry, & Life Sciences': return l10n.optionBiologyChemistry;
            case 'None': return l10n.optionNone;
            default: return option;
          }
        }).toList();

      case 'q4_eng': // Engineering type
        return originalOptions.map((option) {
          switch (option) {
            case 'Mechanical': return l10n.optionMechanical;
            case 'Electrical': return l10n.optionElectrical;
            case 'Aerospace': return l10n.optionAerospace;
            case 'Civil': return l10n.optionCivil;
            case 'Chemical': return l10n.optionChemical;
            default: return option;
          }
        }).toList();

      case 'q4_it': // IT area
        return originalOptions.map((option) {
          switch (option) {
            case 'Software Development & Debugging': return l10n.optionSoftwareDevelopment;
            case 'Full-stack Development': return l10n.optionFullStackDevelopment;
            case 'Cloud Computing (AWS, Azure, GCP)': return l10n.optionCloudComputing;
            case 'DevOps & CI/CD': return l10n.optionDevOps;
            case 'IT Support & System Administration': return l10n.optionItSupport;
            case 'Product Management': return l10n.optionProductManagement;
            case 'Machine Learning & AI': return l10n.optionMachineLearning;
            case 'Data Analysis': return l10n.optionDataAnalysis;
            default: return option;
          }
        }).toList();

      case 'q6': // Prior experience
        return originalOptions.map((option) {
          switch (option) {
            case 'Yes, internship': return l10n.optionYesInternship;
            case 'Yes, part-time job': return l10n.optionYesPartTime;
            case 'Yes, personal projects': return l10n.optionYesPersonalProjects;
            case 'No': return l10n.optionNo;
            default: return option;
          }
        }).toList();

      case 'q10': // Languages
        return originalOptions.map((option) => _translateLanguage(option, l10n)).toList();

      case 'q11': // Countries
        return originalOptions.map((option) => _translateCountry(option, l10n)).toList();

      case 'q12': // Availability
        return originalOptions.map((option) {
          switch (option) {
            case 'Anytime': return l10n.optionAnytime;
            case 'Summer': return l10n.optionSummer;
            case 'Autumn': return l10n.optionAutumn;
            case 'Winter': return l10n.optionWinter;
            case 'Spring': return l10n.optionSpring;
            default: return option;
          }
        }).toList();

      case 'q13': // Internship length
        return originalOptions.map((option) {
          switch (option) {
            case '1-3 months': return l10n.optionOneToThreeMonths;
            case '3-6 months': return l10n.optionThreeToSixMonths;
            case '6-12 months': return l10n.optionSixToTwelveMonths;
            case 'More than 12 months': return l10n.optionMoreThanTwelveMonths;
            default: return option;
          }
        }).toList();

      case 'q14': // Visa requirement
        return originalOptions.map((option) {
          switch (option) {
            case 'Yes, for EU/EEA and UK': return l10n.optionYesEuUk;
            case 'Yes, for EU/EEA': return l10n.optionYesEu;
            case 'Yes, for UK': return l10n.optionYesUk;
            case 'No': return l10n.optionNo;
            default: return option;
          }
        }).toList();

      // For dynamic content that comes from repositories
      case 'q8': // Soft skills - keep original (already localized in SkillsRepository)
      case 'q9': // Hard skills - keep original (already localized in SkillsRepository)
      default:
        return originalOptions; // Return original for unhandled cases
    }
  }

  static String _translateLanguage(String language, AppLocalizations l10n) {
    switch (language) {
      case 'Albanian': return l10n.languageAlbanian;
      case 'Bosnian': return l10n.languageBosnian;
      case 'Bulgarian': return l10n.languageBulgarian;
      case 'Catalan': return l10n.languageCatalan;
      case 'Croatian': return l10n.languageCroatian;
      case 'Czech': return l10n.languageCzech;
      case 'Danish': return l10n.languageDanish;
      case 'Dutch': return l10n.languageDutch;
      case 'English': return l10n.languageEnglish;
      case 'Estonian': return l10n.languageEstonian;
      case 'Finnish': return l10n.languageFinnish;
      case 'French': return l10n.languageFrench;
      case 'German': return l10n.languageGerman;
      case 'Greek': return l10n.languageGreek;
      case 'Hungarian': return l10n.languageHungarian;
      case 'Icelandic': return l10n.languageIcelandic;
      case 'Irish': return l10n.languageIrish;
      case 'Italian': return l10n.languageItalian;
      case 'Latvian': return l10n.languageLatvian;
      case 'Lithuanian': return l10n.languageLithuanian;
      case 'Luxembourgish': return l10n.languageLuxembourgish;
      case 'Macedonian': return l10n.languageMacedonian;
      case 'Maltese': return l10n.languageMaltese;
      case 'Montenegrin': return l10n.languageMontenegrin;
      case 'Norwegian': return l10n.languageNorwegian;
      case 'Polish': return l10n.languagePolish;
      case 'Portuguese': return l10n.languagePortuguese;
      case 'Romanian': return l10n.languageRomanian;
      case 'Russian': return l10n.languageRussian;
      case 'Serbian': return l10n.languageSerbian;
      case 'Slovak': return l10n.languageSlovak;
      case 'Slovenian': return l10n.languageSlovenian;
      case 'Spanish': return l10n.languageSpanish;
      case 'Swedish': return l10n.languageSwedish;
      case 'Turkish': return l10n.languageTurkish;
      case 'Ukrainian': return l10n.languageUkrainian;
      default: return language;
    }
  }

  static String _translateCountry(String country, AppLocalizations l10n) {
    switch (country) {
      case 'Any': return l10n.countryAny;
      case 'Albania': return l10n.countryAlbania;
      case 'Andorra': return l10n.countryAndorra;
      case 'Austria': return l10n.countryAustria;
      case 'Belgium': return l10n.countryBelgium;
      case 'Bosnia and Herzegovina': return l10n.countryBosniaHerzegovina;
      case 'Bulgaria': return l10n.countryBulgaria;
      case 'Croatia': return l10n.countryCroatia;
      case 'Cyprus': return l10n.countryCyprus;
      case 'Czech Republic': return l10n.countryCzechRepublic;
      case 'Denmark': return l10n.countryDenmark;
      case 'Estonia': return l10n.countryEstonia;
      case 'Finland': return l10n.countryFinland;
      case 'France': return l10n.countryFrance;
      case 'Germany': return l10n.countryGermany;
      case 'Greece': return l10n.countryGreece;
      case 'Hungary': return l10n.countryHungary;
      case 'Iceland': return l10n.countryIceland;
      case 'Ireland': return l10n.countryIreland;
      case 'Italy': return l10n.countryItaly;
      case 'Kosovo': return l10n.countryKosovo;
      case 'Latvia': return l10n.countryLatvia;
      case 'Lithuania': return l10n.countryLithuania;
      case 'Luxembourg': return l10n.countryLuxembourg;
      case 'Malta': return l10n.countryMalta;
      case 'Moldova': return l10n.countryMoldova;
      case 'Monaco': return l10n.countryMonaco;
      case 'Montenegro': return l10n.countryMontenegro;
      case 'Netherlands': return l10n.countryNetherlands;
      case 'North Macedonia': return l10n.countryNorthMacedonia;
      case 'Norway': return l10n.countryNorway;
      case 'Poland': return l10n.countryPoland;
      case 'Portugal': return l10n.countryPortugal;
      case 'Romania': return l10n.countryRomania;
      case 'San Marino': return l10n.countrySanMarino;
      case 'Serbia': return l10n.countrySerbia;
      case 'Slovakia': return l10n.countrySlovakia;
      case 'Slovenia': return l10n.countrySlovenia;
      case 'Spain': return l10n.countrySpain;
      case 'Sweden': return l10n.countrySweden;
      case 'Switzerland': return l10n.countrySwitzerland;
      case 'Ukraine': return l10n.countryUkraine;
      case 'United Kingdom': return l10n.countryUnitedKingdom;
      case 'Vatican City': return l10n.countryVaticanCity;
      default: return country;
    }
  }

  static String getTranslatedHintText(String questionId, AppLocalizations l10n) {
    switch (questionId) {
      case 'q1':
      case 'q2':
      case 'q2_yes_1':
      case 'q3':
      case 'q14':
      case 'q15':
        return l10n.hintSelectOne;
      case 'q4':
      case 'q5':
      case 'q6':
      case 'q12':
      case 'q13':
        return l10n.hintSelectMultiple;
      case 'q7':
      case 'q4_it':
      case 'q4_eng':
      case 'q8':
      case 'q9':
      case 'q10':
      case 'q11':
        return l10n.hintSearchAndSelect;
      default:
        return l10n.hintTypeAnswer;
    }
  }

  static String getOtherFieldHint(String questionId, AppLocalizations l10n) {
    switch (questionId) {
      case 'q4':
      case 'q4_eng':
      case 'q4_it':
      case 'q5':
        return l10n.hintOtherSpecify;
      default:
        return l10n.hintOtherSpecify;
    }
  }
}