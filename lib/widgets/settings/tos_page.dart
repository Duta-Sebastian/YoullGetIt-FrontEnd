import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Terms of Service'),
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
              _buildSectionTitle('Introduction'),
              _buildParagraph(
                'These Terms of Service ("Terms") govern your access to and use of you\'ll get it\'s website and mobile application (collectively, the "Platform"). Please read these Terms carefully before using our Platform.'
              ),
              
              _buildSectionTitle('Acceptance of Terms'),
              _buildParagraph(
                'By accessing or using our Platform, you agree to be bound by these Terms. If you do not agree to these Terms, you must not access or use our Platform.'
              ),
              
              _buildSectionTitle('Eligibility'),
              _buildParagraph(
                'You must be at least 16 years old to use our Platform. By using our Platform, you represent and warrant that you meet this requirement.'
              ),
              
              _buildSectionTitle('Account Registration'),
              _buildParagraph(
                'To access certain features of our Platform, you must register for an account. When you register, you agree to:'
              ),
              _buildBulletPoints([
                'Provide accurate, current, and complete information',
                'Maintain and promptly update your account information',
                'Keep your password secure and confidential',
                'Be responsible for all activities that occur under your account',
              ]),
              _buildParagraph(
                'We reserve the right to disable any account if we believe you have violated these Terms.'
              ),
              
              _buildSectionTitle('Platform Use and Restrictions'),
              _buildParagraph(
                'You may use our Platform only for lawful purposes and in accordance with these Terms. You agree not to:'
              ),
              _buildBulletPoints([
                'Use the Platform in any way that violates applicable laws or regulations',
                'Impersonate any person or entity or misrepresent your affiliation',
                'Engage in any conduct that restricts or inhibits anyone\'s use of the Platform',
                'Attempt to gain unauthorized access to any part of the Platform',
                'Use any robot, spider, or other automated device to access the Platform except for search engines and public archives',
                'Use the Platform to send unsolicited communications',
                'Harvest or collect email addresses or other contact information',
                'Use the Platform for any commercial purpose not expressly approved by us',
              ]),
              
              _buildSectionTitle('Intellectual Property Rights'),
              _buildParagraph(
                'The Platform and its content, features, and functionality are owned by you\'ll get it and are protected by copyright, trademark, and other intellectual property laws.'
              ),
              
              _buildSectionTitle('User Content'),
              _buildParagraph(
                'You retain any rights you may have in content you submit to the Platform ("User Content"). By submitting User Content, you grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, adapt, publish, translate, distribute, and display such User Content.'
              ),
              _buildParagraph(
                'You represent and warrant that:'
              ),
              _buildBulletPoints([
                'You own or have the necessary rights to your User Content',
                'Your User Content does not violate the rights of any third party',
                'Your User Content complies with these Terms and applicable laws',
              ]),
              _buildParagraph(
                'We reserve the right to remove any User Content that violates these Terms or that we find objectionable.'
              ),
              
              _buildSectionTitle('Third-Party Links and Content'),
              _buildParagraph(
                'The Platform may contain links to third-party websites or services. We do not control or endorse these websites or services and are not responsible for their content, privacy policies, or practices.'
              ),
              
              _buildSectionTitle('Disclaimer of Warranties'),
              _buildParagraph(
                'THE PLATFORM IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. TO THE FULLEST EXTENT PERMITTED BY LAW, WE DISCLAIM ALL WARRANTIES, INCLUDING IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.'
              ),
              
              _buildSectionTitle('Limitation of Liability'),
              _buildParagraph(
                'TO THE FULLEST EXTENT PERMITTED BY LAW, you\'ll get it SHALL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES ARISING OUT OF OR RELATING TO YOUR USE OF THE PLATFORM.'
              ),
              
              _buildSectionTitle('Indemnification'),
              _buildParagraph(
                'You agree to indemnify and hold harmless you\'ll get it and its officers, directors, employees, and agents from and against any claims, liabilities, damages, losses, and expenses arising out of or relating to your use of the Platform or violation of these Terms.'
              ),
              
              _buildSectionTitle('Governing Law'),
              _buildParagraph(
                'These Terms shall be governed by and construed in accordance with the laws of Romania, without regard to its conflict of law provisions.'
              ),
              
              _buildSectionTitle('Dispute Resolution'),
              _buildParagraph(
                'Any dispute arising out of or relating to these Terms or the Platform shall be resolved by the courts of Romania.'
              ),
              
              _buildSectionTitle('Changes to These Terms'),
              _buildParagraph(
                'We may update these Terms from time to time. The updated version will be indicated by an updated "Last Updated" date.'
              ),
              
              _buildSectionTitle('Termination'),
              _buildParagraph(
                'We may terminate or suspend your access to the Platform immediately, without prior notice or liability, for any reason, including if you breach these Terms.'
              ),
              
              _buildSectionTitle('Severability'),
              _buildParagraph(
                'If any provision of these Terms is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall be enforced.'
              ),
              
              _buildSectionTitle('Entire Agreement'),
              _buildParagraph(
                'These Terms constitute the entire agreement between you and you\'ll get it regarding the Platform.'
              ),
              
              _buildSectionTitle('Contact Us'),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(text: 'If you have any questions about these Terms, please contact us at '),
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