import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
class GDPRPage extends StatelessWidget {
  const GDPRPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact@youllgetit.eu',
      query: encodeQueryParameters({
        'subject': 'GDPR Inquiry',
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
        title: Text(localizations.settingsGDPRPageTitle),
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
              _buildSectionTitle(localizations.settingsGDPRPageCommitment),
              _buildParagraph(localizations.settingsGDPRPageCommitmentText),
              
              _buildSectionTitle(localizations.settingsGDPRPageDataSubjectRights),
              _buildParagraph(localizations.settingsGDPRPageDataSubjectRightsText),
              _buildBulletPoints([
                localizations.settingsGDPRPageRightToInformation,
                localizations.settingsGDPRPageRightOfAccess,
                localizations.settingsGDPRPageRightToRectification,
                localizations.settingsGDPRPageRightToErasure,
                localizations.settingsGDPRPageRightToRestriction,
                localizations.settingsGDPRPageRightToDataPortability,
                localizations.settingsGDPRPageRightToObject,
                localizations.settingsGDPRPageRightAutomatedDecision,
              ]),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: localizations.settingsGDPRPageExerciseRights),
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
              
              _buildSectionTitle(localizations.settingsGDPRPageDataProtectionOfficer),
              _buildParagraph(localizations.settingsGDPRPageContactUsAt),
              _buildCompanyInfo(context, localizations),
              
              _buildSectionTitle(localizations.settingsGDPRPageContactInformation),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(text: localizations.settingsGDPRPageContactUsText),
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
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              _buildParagraph(
                localizations.settingsGDPRPageLastUpdated,
                isItalic: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ${localizations.settingsGDPRPageCompanyName}', style: const TextStyle(fontSize: 16)),
          Text('• ${localizations.settingsGDPRPageRegNo}', style: const TextStyle(fontSize: 16)),
          Text('• ${localizations.settingsGDPRPageCUI}', style: const TextStyle(fontSize: 16)),
          Text('• ${localizations.settingsGDPRPageEUID}', style: const TextStyle(fontSize: 16)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'contact@youllgetit.eu',
                  );
                  if (!await launchUrl(emailLaunchUri)) {
                    throw Exception('Could not launch $emailLaunchUri');
                  }
                },
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