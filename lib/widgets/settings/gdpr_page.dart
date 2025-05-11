import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('GDPR Policy'),
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
              const Text(
                'GDPR Compliance Statement',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSectionTitle('Our Commitment to GDPR Compliance'),
              _buildParagraph(
                'At you\'ll get it, we are committed to ensuring the privacy and protection of your personal data in compliance with the General Data Protection Regulation (GDPR) and relevant Romanian data protection laws.'
              ),
              
              // Rest of the content remains the same...
              
              _buildSectionTitle('Data Subject Rights'),
              _buildParagraph(
                'Under the GDPR, you have the following rights:'
              ),
              _buildBulletPoints([
                'Right to Information: Receive clear information about how we use your data.',
                'Right of Access: Obtain confirmation that we are processing your data and access your personal data.',
                'Right to Rectification: Have inaccurate personal data corrected or completed if incomplete.',
                'Right to Erasure: Request deletion of your personal data in certain circumstances.',
                'Right to Restriction of Processing: Request restriction of processing in certain circumstances.',
                'Right to Data Portability: Receive your personal data in a structured, commonly used, machine-readable format.',
                'Right to Object: Object to processing based on legitimate interests or direct marketing.',
                'Rights Related to Automated Decision Making and Profiling: Not be subject to decisions based solely on automated processing that produce legal effects.',
              ]),
              
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(text: 'To exercise these rights, please contact us at '),
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
              
              _buildSectionTitle('Data Protection Officer'),
              _buildParagraph('Contact us at:'),
              _buildCompanyInfo(context),
              
              // Continue with the rest of your content...
              
              _buildSectionTitle('Contact Information'),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(text: 'If you have any questions about our GDPR compliance, please contact: Email: '),
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
                'Last Updated: April 9, 2025',
                isItalic: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• YOU\'LL GET IT S.R.L.', style: TextStyle(fontSize: 16)),
          const Text('• Reg. No: J2025027781008', style: TextStyle(fontSize: 16)),
          const Text('• CUI: 51649682', style: TextStyle(fontSize: 16)),
          const Text('• EUID: ROONRC.J2025027781008', style: TextStyle(fontSize: 16)),
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