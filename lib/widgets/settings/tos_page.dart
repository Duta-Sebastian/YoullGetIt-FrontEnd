import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@youllgetit.eu',
      query: encodeQueryParameters({
        'subject': 'Terms of Service Inquiry',
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
        title: Text(localizations.settingsTermsOfServicePageTitle),
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
              _buildSectionTitle(localizations.settingsTermsOfServicePageIntroduction),
              _buildParagraph(localizations.settingsTermsOfServicePageIntroductionText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageAcceptanceOfTerms),
              _buildParagraph(localizations.settingsTermsOfServicePageAcceptanceOfTermsText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageEligibility),
              _buildParagraph(localizations.settingsTermsOfServicePageEligibilityText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageAccountRegistration),
              _buildParagraph(localizations.settingsTermsOfServicePageAccountRegistrationText),
              _buildBulletPoints([
                localizations.settingsTermsOfServicePageProvideAccurateInfo,
                localizations.settingsTermsOfServicePageMaintainAccountInfo,
                localizations.settingsTermsOfServicePageKeepPasswordSecure,
                localizations.settingsTermsOfServicePageBeResponsible,
              ]),
              _buildParagraph(localizations.settingsTermsOfServicePageDisableAccount),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePagePlatformUse),
              _buildParagraph(localizations.settingsTermsOfServicePagePlatformUseText),
              _buildBulletPoints([
                localizations.settingsTermsOfServicePageNoViolateLaws,
                localizations.settingsTermsOfServicePageNoImpersonate,
                localizations.settingsTermsOfServicePageNoRestrictUse,
                localizations.settingsTermsOfServicePageNoUnauthorizedAccess,
                localizations.settingsTermsOfServicePageNoAutomatedDevices,
                localizations.settingsTermsOfServicePageNoUnsolicitedComms,
                localizations.settingsTermsOfServicePageNoHarvestInfo,
                localizations.settingsTermsOfServicePageNoCommercialUse,
              ]),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageIntellectualProperty),
              _buildParagraph(localizations.settingsTermsOfServicePageIntellectualPropertyText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageUserContent),
              _buildParagraph(localizations.settingsTermsOfServicePageUserContentText),
              _buildParagraph(localizations.settingsTermsOfServicePageRepresentWarrant),
              _buildBulletPoints([
                localizations.settingsTermsOfServicePageOwnRights,
                localizations.settingsTermsOfServicePageNoViolateRights,
                localizations.settingsTermsOfServicePageCompliesTerms,
              ]),
              _buildParagraph(localizations.settingsTermsOfServicePageRemoveContent),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageThirdPartyLinks),
              _buildParagraph(localizations.settingsTermsOfServicePageThirdPartyLinksText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageDisclaimer),
              _buildParagraph(localizations.settingsTermsOfServicePageDisclaimerText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageLimitationLiability),
              _buildParagraph(localizations.settingsTermsOfServicePageLimitationLiabilityText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageIndemnification),
              _buildParagraph(localizations.settingsTermsOfServicePageIndemnificationText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageGoverningLaw),
              _buildParagraph(localizations.settingsTermsOfServicePageGoverningLawText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageDisputeResolution),
              _buildParagraph(localizations.settingsTermsOfServicePageDisputeResolutionText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageChangesToTerms),
              _buildParagraph(localizations.settingsTermsOfServicePageChangesToTermsText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageTermination),
              _buildParagraph(localizations.settingsTermsOfServicePageTerminationText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageSeverability),
              _buildParagraph(localizations.settingsTermsOfServicePageSeverabilityText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageEntireAgreement),
              _buildParagraph(localizations.settingsTermsOfServicePageEntireAgreementText),
              
              _buildSectionTitle(localizations.settingsTermsOfServicePageContactUs),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(text: localizations.settingsTermsOfServicePageContactUsText),
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
              
              const SizedBox(height: 16),
              _buildParagraph(
                localizations.settingsTermsOfServicePageLastUpdated,
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