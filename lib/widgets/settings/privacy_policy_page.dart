import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@youllgetit.eu',
      query: encodeQueryParameters({
        'subject': 'Privacy Policy Inquiry',
      }),
    );
    
    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }
  
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(localizations.settingsPrivacyPolicyPageTitle),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageIntroduction),
              _buildParagraph(localizations.settingsPrivacyPolicyPageIntroductionText),
              _buildParagraph(localizations.settingsPrivacyPolicyPageIntroductionText2),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageInformationWeCollect),
              _buildParagraph(localizations.settingsPrivacyPolicyPageInformationWeCollectText),
              _buildSubtitle(localizations.settingsPrivacyPolicyPagePersonalData),
              _buildParagraph(localizations.settingsPrivacyPolicyPagePersonalDataText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageContactInfo,
                localizations.settingsPrivacyPolicyPageAccountCredentials,
                localizations.settingsPrivacyPolicyPageProfileInfo,
                localizations.settingsPrivacyPolicyPageDeviceInfo,
                localizations.settingsPrivacyPolicyPageLocationData,
                localizations.settingsPrivacyPolicyPageUsageData,
              ]),
              
              _buildSubtitle(localizations.settingsPrivacyPolicyPageNonPersonalData),
              _buildParagraph(localizations.settingsPrivacyPolicyPageNonPersonalDataText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageAnonymousStats,
                localizations.settingsPrivacyPolicyPageDemographicInfo,
                localizations.settingsPrivacyPolicyPageAggregatedBehavior,
              ]),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageHowWeCollect),
              _buildParagraph(localizations.settingsPrivacyPolicyPageHowWeCollectText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageDirectInteractions,
                localizations.settingsPrivacyPolicyPageAutomatedTech,
                localizations.settingsPrivacyPolicyPageThirdPartySources,
              ]),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageHowWeUse),
              _buildParagraph(localizations.settingsPrivacyPolicyPageHowWeUseText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageProvideServices,
                localizations.settingsPrivacyPolicyPagePersonalize,
                localizations.settingsPrivacyPolicyPageCommunicate,
                localizations.settingsPrivacyPolicyPageProcessPayments,
                localizations.settingsPrivacyPolicyPageImprove,
                localizations.settingsPrivacyPolicyPageAnalyze,
                localizations.settingsPrivacyPolicyPageDetectIssues,
                localizations.settingsPrivacyPolicyPageComplyLegal,
              ]),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageLegalBasis),
              _buildParagraph(localizations.settingsPrivacyPolicyPageLegalBasisText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageYourConsent,
                localizations.settingsPrivacyPolicyPageContractPerformance,
                localizations.settingsPrivacyPolicyPageLegalCompliance,
                localizations.settingsPrivacyPolicyPageLegitimateInterests,
              ]),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageInfoSharing),
              _buildParagraph(localizations.settingsPrivacyPolicyPageInfoSharingText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageServiceProviders,
                localizations.settingsPrivacyPolicyPageBusinessPartners,
                localizations.settingsPrivacyPolicyPageLegalAuthorities,
                localizations.settingsPrivacyPolicyPageAffiliatedCompanies,
                localizations.settingsPrivacyPolicyPageSuccessorEntity,
              ]),
              _buildParagraph(localizations.settingsPrivacyPolicyPageNoSelling),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageDataSecurity),
              _buildParagraph(localizations.settingsPrivacyPolicyPageDataSecurityText),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageDataRetention),
              _buildParagraph(localizations.settingsPrivacyPolicyPageDataRetentionText),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageDataProtectionRights),
              _buildParagraph(localizations.settingsPrivacyPolicyPageDataProtectionRightsText),
              _buildBulletPoints([
                localizations.settingsPrivacyPolicyPageRightAccess,
                localizations.settingsPrivacyPolicyPageRightRectify,
                localizations.settingsPrivacyPolicyPageRightErasure,
                localizations.settingsPrivacyPolicyPageRightRestrict,
                localizations.settingsPrivacyPolicyPageRightPortability,
                localizations.settingsPrivacyPolicyPageRightObject,
                localizations.settingsPrivacyPolicyPageRightWithdraw,
                localizations.settingsPrivacyPolicyPageRightComplaint,
              ]),
              _buildParagraph(localizations.settingsPrivacyPolicyPageExerciseRights),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageChildrensPrivacy),
              _buildParagraph(localizations.settingsPrivacyPolicyPageChildrensPrivacyText),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageCookies),
              _buildParagraph(localizations.settingsPrivacyPolicyPageCookiesText),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageInternationalTransfers),
              _buildParagraph(localizations.settingsPrivacyPolicyPageInternationalTransfersText),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageChanges),
              _buildParagraph(localizations.settingsPrivacyPolicyPageChangesText),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageContactUs),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(text: localizations.settingsPrivacyPolicyPageContactUsText),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: _launchEmail,
                          child: Text(
                            'contact@youllgetit.eu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              
              _buildSectionTitle(localizations.settingsPrivacyPolicyPageCompanyInformation),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.settingsPrivacyPolicyPageCompanyName, style: const TextStyle(fontSize: 16)),
                    Text(localizations.settingsPrivacyPolicyPageRegNo, style: const TextStyle(fontSize: 16)),
                    Text(localizations.settingsPrivacyPolicyPageCUI, style: const TextStyle(fontSize: 16)),
                    Text(localizations.settingsPrivacyPolicyPageEUID, style: const TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Text(localizations.settingsPrivacyPolicyPageEmail, style: const TextStyle(fontSize: 16)),
                        GestureDetector(
                          onTap: _launchEmail,
                          child: Text(
                            'contact@youllgetit.eu',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              _buildParagraph(
                localizations.settingsPrivacyPolicyPageLastUpdated,
                isItalic: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, {bool isItalic = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }

  Widget _buildBulletPoints(List<String> points) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: points.map((point) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}