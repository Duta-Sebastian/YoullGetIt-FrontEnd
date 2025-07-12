import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';

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
        return originalOptions.map<String>((option) {
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
        return originalOptions.map<String>((option) {
          switch (option) {
            case 'Yes': return l10n.optionYes;
            case 'No': return l10n.optionNo;
            case 'Maybe': return l10n.optionMaybe;
            default: return option;
          }
        }).toList();

      case 'q2_yes_1': // What year
        return originalOptions.map<String>((option) {
          switch (option) {
            case '1st Year': return l10n.optionFirstYear;
            case '2nd Year': return l10n.optionSecondYear;
            case '3rd Year': return l10n.optionThirdYear;
            case '4th Year': return l10n.optionFourthYear;
            default: return option;
          }
        }).toList();

      case 'q3': // University type
        return originalOptions.map<String>((option) {
          switch (option) {
            case 'Research': return l10n.optionResearch;
            case 'Applied': return l10n.optionApplied;
            default: return option;
          }
        }).toList();

      case 'q4': // Study field
      case 'q5': // Other specializations
      case 'q7': // Other fields
        return originalOptions.map<String>((option) {
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
        return originalOptions.map<String>((option) {
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
        return originalOptions.map<String>((option) {
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
        return originalOptions.map<String>((option) {
          switch (option) {
            case 'Yes, internship': return l10n.optionYesInternship;
            case 'Yes, part-time job': return l10n.optionYesPartTime;
            case 'Yes, personal projects': return l10n.optionYesPersonalProjects;
            case 'No': return l10n.optionNo;
            default: return option;
          }
        }).toList();

      case 'q8': // Soft skills - NOW TRANSLATED
        return originalOptions.map<String>((option) => translateSoftSkill(option, l10n)).toList();

      case 'q9': // Hard skills - NOW TRANSLATED  
        return originalOptions.map<String>((option) => translateHardSkill(option, l10n)).toList();

      case 'q10': // Languages
        return originalOptions.map<String>((option) => _translateLanguage(option, l10n)).toList();

      case 'q11': // Countries
        return originalOptions.map<String>((option) => _translateCountry(option, l10n)).toList();

      case 'q12': // Availability
        return originalOptions.map<String>((option) {
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
        return originalOptions.map<String>((option) {
          switch (option) {
            case '1-3 months': return l10n.optionOneToThreeMonths;
            case '3-6 months': return l10n.optionThreeToSixMonths;
            case '6-12 months': return l10n.optionSixToTwelveMonths;
            case 'More than 12 months': return l10n.optionMoreThanTwelveMonths;
            default: return option;
          }
        }).toList();

      case 'q14': // Visa requirement
        return originalOptions.map<String>((option) {
          switch (option) {
            case 'Yes, for EU/EEA and UK': return l10n.optionYesEuUk;
            case 'Yes, for EU/EEA': return l10n.optionYesEu;
            case 'Yes, for UK': return l10n.optionYesUk;
            case 'No': return l10n.optionNo;
            default: return option;
          }
        }).toList();

      default:
        return originalOptions; // Return original for unhandled cases
    }
  }

  // NEW: Soft Skills Translation
  static String translateSoftSkill(String skill, AppLocalizations l10n) {
    switch (skill) {
      // Leadership & Management
      case 'Leadership': return l10n.softSkillLeadership;
      case 'Decision-Making': return l10n.softSkillDecisionMaking;
      case 'Mentoring': return l10n.softSkillMentoring;
      case 'Accountability': return l10n.softSkillAccountability;
      
      // Communication & Interpersonal
      case 'Communication Skills': return l10n.softSkillCommunicationSkills;
      case 'Public Speaking': return l10n.softSkillPublicSpeaking;
      case 'Interpersonal Skills': return l10n.softSkillInterpersonalSkills;
      case 'Networking': return l10n.softSkillNetworking;
      
      // Teamwork & Collaboration
      case 'Collaboration': return l10n.softSkillCollaboration;
      case 'Teamwork': return l10n.softSkillTeamwork;
      case 'Relationship Management': return l10n.softSkillRelationshipManagement;
      case 'Customer Service': return l10n.softSkillCustomerService;
      
      // Cognitive & Analytical
      case 'Critical Thinking': return l10n.softSkillCriticalThinking;
      case 'Problem-Solving Skills': return l10n.softSkillProblemSolvingSkills;
      case 'Innovation': return l10n.softSkillInnovation;
      case 'Commercial Understanding': return l10n.softSkillCommercialUnderstanding;
      
      // Personal Effectiveness
      case 'Time Management': return l10n.softSkillTimeManagement;
      case 'Organizational Skills': return l10n.softSkillOrganizationalSkills;
      case 'Attention to Detail': return l10n.softSkillAttentionToDetail;
      case 'Detail Oriented': return l10n.softSkillDetailOriented;
      
      // Adaptability & Growth
      case 'Flexibility': return l10n.softSkillFlexibility;
      case 'Adaptability': return l10n.softSkillAdaptability;
      case 'Learning': return l10n.softSkillLearning;
      case 'Continuous Learning': return l10n.softSkillContinuousLearning;
      case 'Enthusiasm for Learning': return l10n.softSkillEnthusiasmForLearning;
      
      // Independence & Specialized
      case 'Independence': return l10n.softSkillIndependence;
      case 'Self-Reliance': return l10n.softSkillSelfReliance;
      case 'Enthusiasm for Politics': return l10n.softSkillEnthusiasmForPolitics;
      case 'Enthusiasm for Public Service': return l10n.softSkillEnthusiasmForPublicService;

      case 'Creativity': return l10n.creativity;
      
      default: return skill;
    }
  }

  // NEW: Hard Skills Translation
  static String translateHardSkill(String skill, AppLocalizations l10n) {
    switch (skill) {
      // Analysis & Research
      case 'General Analysis': return l10n.hardSkillGeneralAnalysis;
      case 'Financial Analysis': return l10n.hardSkillFinancialAnalysis;
      case 'Market Analysis': return l10n.hardSkillMarketAnalysis;
      case 'Legal Analysis': return l10n.hardSkillLegalAnalysis;
      case 'Data Analysis': return l10n.hardSkillDataAnalysis;
      case 'Financial Modeling': return l10n.hardSkillFinancialModeling;
      case 'Social Science Research': return l10n.hardSkillSocialScienceResearch;
      case 'Market Research': return l10n.hardSkillMarketResearch;
      case 'Statistical Skills': return l10n.hardSkillStatisticalSkills;
      case 'Mathematical Skills': return l10n.hardSkillMathematicalSkills;
      case 'Statistics': return l10n.hardSkillStatistics;
      case 'Calculus': return l10n.hardSkillCalculus;
      case 'Linear Algebra': return l10n.hardSkillLinearAlgebra;
      case 'Supply Chain Management': return l10n.hardSkillSupplyChainManagement;
      case 'Research Methods': return l10n.hardSkillResearchMethods;
      case 'Legal Research': return l10n.hardSkillLegalResearch;
      case 'Policy Research': return l10n.hardSkillPolicyResearch;
      case 'Arts Research': return l10n.hardSkillArtsResearch;
      case 'Polling Data Analysis': return l10n.hardSkillPollingDataAnalysis;
      
      // Programming & Development
      case 'Programming': return l10n.hardSkillProgramming;
      case 'Software Development': return l10n.hardSkillSoftwareDevelopment;
      case 'Web Development': return l10n.hardSkillWebDevelopment;
      case 'Mobile Development': return l10n.hardSkillMobileDevelopment;
      case 'Full-stack Development': return l10n.hardSkillFullStackDevelopment;
      case 'Frontend Development': return l10n.hardSkillFrontendDevelopment;
      case 'Backend Development': return l10n.hardSkillBackendDevelopment;
      case 'API Development': return l10n.hardSkillApiDevelopment;
      
      // Data Science & Machine Learning
      case 'Machine Learning': return l10n.hardSkillMachineLearning;
      case 'Deep Learning': return l10n.hardSkillDeepLearning;
      case 'Data Science': return l10n.hardSkillDataScience;
      case 'Big Data': return l10n.hardSkillBigData;
      case 'Machine Learning Basics': return l10n.hardSkillMachineLearningBasics;
      
      // Cloud & Infrastructure
      case 'Cloud Computing': return l10n.hardSkillCloudComputing;
      case 'Infrastructure Management': return l10n.hardSkillInfrastructureManagement;
      case 'System Administration': return l10n.hardSkillSystemAdministration;
      case 'Network Administration': return l10n.hardSkillNetworkAdministration;
      case 'Database Administration': return l10n.hardSkillDatabaseAdministration;
      
      // Database & Data Management
      case 'Database Management': return l10n.hardSkillDatabaseManagement;
      case 'Database Knowledge': return l10n.hardSkillDatabaseKnowledge;
      case 'Data Warehousing': return l10n.hardSkillDataWarehousing;
      case 'Data Mining': return l10n.hardSkillDataMining;
      case 'ETL Processes': return l10n.hardSkillEtlProcesses;
      
      // Design & Engineering Tools
      case 'Engineering Design': return l10n.hardSkillEngineeringDesign;
      case 'Technical Drawing': return l10n.hardSkillTechnicalDrawing;
      case '3D Modeling': return l10n.hardSkill3dModeling;
      case 'Product Design': return l10n.hardSkillProductDesign;
      
      // Business Intelligence & Visualization
      case 'Business Intelligence': return l10n.hardSkillBusinessIntelligence;
      case 'Data Visualization': return l10n.hardSkillDataVisualization;
      case 'Dashboard Creation': return l10n.hardSkillDashboardCreation;
      case 'Reporting': return l10n.hardSkillReporting;
      case 'Analytics': return l10n.hardSkillAnalytics;
      
      // Productivity & Project Management
      case 'Project Management': return l10n.hardSkillProjectManagement;
      case 'Microsoft Office': return l10n.hardSkillMicrosoftOffice;
      case 'Spreadsheet Analysis': return l10n.hardSkillSpreadsheetAnalysis;
      case 'Pivot Tables': return l10n.hardSkillPivotTables;
      case 'Financial Functions': return l10n.hardSkillFinancialFunctions;
      case 'Task Management': return l10n.hardSkillTaskManagement;
      case 'Workflow Management': return l10n.hardSkillWorkflowManagement;
      
      // Marketing & Digital Tools
      case 'Digital Marketing': return l10n.hardSkillDigitalMarketing;
      case 'Social Media Management': return l10n.hardSkillSocialMediaManagement;
      case 'Content Creation': return l10n.hardSkillContentCreation;
      case 'Content Marketing': return l10n.hardSkillContentMarketing;
      case 'CRM Systems': return l10n.hardSkillCrmSystems;
      case 'Email Marketing': return l10n.hardSkillEmailMarketing;
      case 'Marketing Automation': return l10n.hardSkillMarketingAutomation;
      case 'Campaign Management': return l10n.hardSkillCampaignManagement;
      
      // Design & Creative Tools
      case 'Graphic Design': return l10n.hardSkillGraphicDesign;
      case 'Visual Design': return l10n.hardSkillVisualDesign;
      case 'Visual Communication': return l10n.hardSkillVisualCommunication;
      case 'Brand Design': return l10n.hardSkillBrandDesign;
      case 'UI/UX Design': return l10n.hardSkillUiUxDesign;
      case 'Web Design': return l10n.hardSkillWebDesign;
      case 'Logo Design': return l10n.hardSkillLogoDesign;
      case 'Print Design': return l10n.hardSkillPrintDesign;
      
      // AI & Automation Tools
      case 'Artificial Intelligence': return l10n.hardSkillArtificialIntelligence;
      case 'Prompt Engineering': return l10n.hardSkillPromptEngineering;
      case 'AI Tools': return l10n.hardSkillAiTools;
      case 'Automation': return l10n.hardSkillAutomation;
      case 'Process Automation': return l10n.hardSkillProcessAutomation;

      case 'M&A (mergers and acquisitions)': return l10n.mergers_acquisitions;
      
      // Keep proper names unchanged (no translation needed)
      case 'Python':
      case 'R Programming':
      case 'SQL':
      case 'JavaScript':
      case 'Java':
      case 'C++':
      case 'C#':
      case 'TypeScript':
      case 'PHP':
      case 'Ruby':
      case 'Go':
      case 'Rust':
      case 'Swift':
      case 'Kotlin':
      case 'Dart':
      case 'MATLAB':
      case 'pandas':
      case 'NumPy':
      case 'scikit-learn':
      case 'matplotlib':
      case 'Seaborn':
      case 'ggplot2':
      case 'Hadoop':
      case 'Spark':
      case 'PySpark':
      case 'AWS':
      case 'AWS SageMaker':
      case 'Azure':
      case 'Azure ML':
      case 'Google Cloud Platform':
      case 'Google Vertex AI':
      case 'Docker':
      case 'Kubernetes':
      case 'MongoDB':
      case 'PostgreSQL':
      case 'MySQL':
      case 'Redis':
      case 'Firebase':
      case 'CAD':
      case 'SolidWorks':
      case 'AutoCAD':
      case 'SketchUp':
      case 'Blender':
      case 'Tableau':
      case 'Power BI':
      case 'Looker':
      case 'Excel':
      case 'Word':
      case 'PowerPoint':
      case 'Google Sheets':
      case 'VLOOKUP':
      case 'Trello':
      case 'Asana':
      case 'Notion':
      case 'ClickUp':
      case 'SEO':
      case 'SEM':
      case 'Google Analytics':
      case 'Adobe Analytics':
      case 'HubSpot':
      case 'Mailchimp':
      case 'Ubersuggest':
      case 'Ahrefs':
      case 'SEMrush':
      case 'Adobe Photoshop':
      case 'Adobe Illustrator':
      case 'Adobe InDesign':
      case 'Adobe Premiere Pro':
      case 'Adobe Creative Suite':
      case 'Figma':
      case 'Canva':
      case 'ChatGPT':
      case 'Claude':
      case 'Gemini':
      case 'DALL-E':
      case 'Notion AI':
      case 'Jasper':
      case 'Westlaw':
      case 'LexisNexis':
      case 'Kubeflow':
      case 'MLflow':
      case 'Weights & Biases':
      case 'Prefect':
      case 'Dagster':
        return skill; // Keep proper names as-is
      
      default: return skill;
    }
  }

  // NEW: Soft Skills Group Translation
  static String translateSoftSkillGroup(String groupName, AppLocalizations l10n) {
    switch (groupName) {
      case 'Leadership & Management': return l10n.softSkillsGroupLeadershipManagement;
      case 'Communication & Interpersonal': return l10n.softSkillsGroupCommunicationInterpersonal;
      case 'Teamwork & Collaboration': return l10n.softSkillsGroupTeamworkCollaboration;
      case 'Cognitive & Analytical': return l10n.softSkillsGroupCognitiveAnalytical;
      case 'Personal Effectiveness': return l10n.softSkillsGroupPersonalEffectiveness;
      case 'Adaptability & Growth': return l10n.softSkillsGroupAdaptabilityGrowth;
      case 'Independence & Specialized': return l10n.softSkillsGroupIndependenceSpecialized;
      default: return groupName;
    }
  }

  // NEW: Hard Skills Group Translation
  static String translateHardSkillGroup(String groupName, AppLocalizations l10n) {
    switch (groupName) {
      case 'Analysis & Research': return l10n.hardSkillsGroupAnalysisResearch;
      case 'Programming & Development': return l10n.hardSkillsGroupProgrammingDevelopment;
      case 'Data Science & Machine Learning': return l10n.hardSkillsGroupDataScienceMl;
      case 'Cloud & Infrastructure': return l10n.hardSkillsGroupCloudInfrastructure;
      case 'Database & Data Management': return l10n.hardSkillsGroupDatabaseDataManagement;
      case 'Design & Engineering Tools': return l10n.hardSkillsGroupDesignEngineeringTools;
      case 'Business Intelligence & Visualization': return l10n.hardSkillsGroupBusinessIntelligence;
      case 'Productivity & Project Management': return l10n.hardSkillsGroupProductivityProjectManagement;
      case 'Marketing & Digital Tools': return l10n.hardSkillsGroupMarketingDigitalTools;
      case 'Design & Creative Tools': return l10n.hardSkillsGroupDesignCreativeTools;
      case 'AI & Automation Tools': return l10n.hardSkillsGroupAiAutomationTools;
      case 'Specialized Professional Skills': return l10n.hardSkillsGroupSpecializedProfessional;
      case 'Legal & Compliance': return l10n.hardSkillsGroupLegalCompliance;
      case 'Engineering Specializations': return l10n.hardSkillsGroupEngineeringSpecializations;
      case 'Communication & Documentation': return l10n.hardSkillsGroupCommunicationDocumentation;
      case 'Specialized Management': return l10n.hardSkillsGroupSpecializedManagement;
      default: return groupName;
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