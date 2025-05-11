import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Privacy Policy'),
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
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSectionTitle('Introduction'),
              _buildParagraph(
                'At you\'ll get it, we respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application and website (collectively, the "Platform").'
              ),
              _buildParagraph(
                'We encourage you to read this Privacy Policy carefully to understand our practices regarding your personal data.'
              ),
              
              _buildSectionTitle('Information We Collect'),
              _buildParagraph(
                'We may collect the following types of information:'
              ),
              _buildSubtitle('Personal Data'),
              _buildParagraph(
                'Information that identifies you or can be used to identify you directly or indirectly, such as:'
              ),
              _buildBulletPoints([
                'Contact information (name, email address, phone number)',
                'Account credentials (username, password)',
                'Profile information (profile picture, preferences)',
                'Device information (device ID, IP address, operating system)',
                'Location data (with your consent)',
                'Usage data (how you interact with our Platform)',
              ]),
              
              _buildSubtitle('Non-Personal Data'),
              _buildParagraph(
                'Information that does not directly identify you, such as:'
              ),
              _buildBulletPoints([
                'Anonymous usage statistics and analytics',
                'Demographic information',
                'Aggregated user behavior',
              ]),
              
              _buildSectionTitle('How We Collect Information'),
              _buildParagraph(
                'We collect information through:'
              ),
              _buildBulletPoints([
                'Direct interactions (when you register, contact us, or use our services)',
                'Automated technologies (cookies, server logs, analytics tools)',
                'Third-party sources (when permitted by law)',
              ]),
              
              _buildSectionTitle('How We Use Your Information'),
              _buildParagraph(
                'We use your information for the following purposes:'
              ),
              _buildBulletPoints([
                'To provide and maintain our services',
                'To personalize your experience',
                'To communicate with you about our services',
                'To process payments and transactions',
                'To improve our Platform and develop new features',
                'To analyze usage patterns and run analytics',
                'To detect, prevent, and address technical or security issues',
                'To comply with legal obligations',
              ]),
              
              _buildSectionTitle('Legal Basis for Processing'),
              _buildParagraph(
                'We process your personal data on the following legal grounds:'
              ),
              _buildBulletPoints([
                'Your consent',
                'Performance of a contract with you',
                'Compliance with legal obligations',
                'Our legitimate interests (which do not override your fundamental rights and freedoms)',
              ]),
              
              _buildSectionTitle('Information Sharing and Disclosure'),
              _buildParagraph(
                'We may share your information with:'
              ),
              _buildBulletPoints([
                'Service providers who help us deliver our services',
                'Business partners with your consent',
                'Legal authorities when required by law',
                'Affiliated companies within our corporate group',
                'A successor entity in the event of a merger, acquisition, or similar transaction',
              ]),
              _buildParagraph(
                'We do not sell your personal data to third parties.'
              ),
              
              _buildSectionTitle('Data Security'),
              _buildParagraph(
                'We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the Internet or electronic storage is 100% secure, so we cannot guarantee absolute security.'
              ),
              
              _buildSectionTitle('Data Retention'),
              _buildParagraph(
                'We retain your personal data only for as long as necessary to fulfill the purposes for which it was collected, including for legal, accounting, or reporting requirements. When determining the appropriate retention period, we consider the amount, nature, and sensitivity of the data, the potential risk of harm from unauthorized use or disclosure, and the purposes for which we process the data.'
              ),
              
              _buildSectionTitle('Your Data Protection Rights'),
              _buildParagraph(
                'Under applicable data protection laws, you may have the following rights:'
              ),
              _buildBulletPoints([
                'Right to access your personal data',
                'Right to rectify inaccurate or incomplete data',
                'Right to erasure (the "right to be forgotten")',
                'Right to restrict processing',
                'Right to data portability',
                'Right to object to processing',
                'Right to withdraw consent',
                'Right to lodge a complaint with a supervisory authority',
              ]),
              _buildParagraph(
                'To exercise these rights, please contact us using the information provided at the end of this Privacy Policy.'
              ),
              
              _buildSectionTitle('Children\'s Privacy'),
              _buildParagraph(
                'Our Platform is not intended for children under 16 years of age. We do not knowingly collect personal data from children under 16. If we learn that we have collected personal data from a child under 16, we will take steps to delete that information as quickly as possible. If you believe we might have any information from or about a child under 16, please contact us.'
              ),
              
              _buildSectionTitle('Cookies and Tracking Technologies'),
              _buildParagraph(
                'We use cookies and similar tracking technologies to collect information about your browsing activities and to remember your preferences. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent. However, if you do not accept cookies, you may not be able to use some portions of our Platform.'
              ),
              
              _buildSectionTitle('International Data Transfers'),
              _buildParagraph(
                'Your personal data may be transferred to and processed in countries other than the country in which you reside. These countries may have different data protection laws than your country. When we transfer your data internationally, we take measures to ensure that appropriate safeguards are in place to protect your data and to ensure that you can exercise your rights effectively.'
              ),
              
              _buildSectionTitle('Changes to This Privacy Policy'),
              _buildParagraph(
                'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. You are advised to review this Privacy Policy periodically for any changes.'
              ),
              
              _buildSectionTitle('Contact Us'),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(text: 'If you have any questions about this Privacy Policy, please contact us at '),
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
              
              _buildSectionTitle('Company Information'),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YOU\'LL GET IT S.R.L.', style: TextStyle(fontSize: 16)),
                    const Text('Reg. No: J2025027781008', style: TextStyle(fontSize: 16)),
                    const Text('CUI: 51649682', style: TextStyle(fontSize: 16)),
                    const Text('EUID: ROONRC.J2025027781008', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        const Text('Email: ', style: TextStyle(fontSize: 16)),
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
                'Last Updated: April 9, 2025',
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