import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youllgetit_flutter/models/user_model.dart';
import 'package:youllgetit_flutter/screens/internship_selector_screen.dart';
import 'package:youllgetit_flutter/utils/database_manager.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _gdprChecked = false;
  bool _nameEntered = false;

  Future<void> _launchGdprUrl() async {
    final Uri url = Uri.parse('https://youllgetit.eu/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  // Extracted function for button onPressed handler
  void _handleContinuePressed() {
    final username = _nameController.text.trim();
    
    DatabaseManager.updateUser(UserModel(
      username: username,
      lastChanged: DateTime.now().toUtc()
    ));
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionnaireScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Listen for changes in the text field
    _nameController.addListener(_updateNameStatus);
  }

  void _updateNameStatus() {
    final hasName = _nameController.text.trim().isNotEmpty;
    if (hasName != _nameEntered) {
      setState(() {
        _nameEntered = hasName;
      });
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateNameStatus);
    _nameController.dispose();
    super.dispose();
  }

  bool get _isFormValid => _nameEntered && _gdprChecked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              const Text(
                "Welcome",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Name Input
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 24),
              
              // GDPR Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _gdprChecked,
                    activeColor: Colors.yellow,
                    onChanged: (bool? value) {
                      setState(() {
                        _gdprChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _gdprChecked = !_gdprChecked;
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: const TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(
                              text: 'GDPR Privacy Policy',
                              style: TextStyle(
                                color: Colors.yellow.shade800,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _launchGdprUrl,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Continue Button
              ElevatedButton(
                onPressed: _isFormValid ? _handleContinuePressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}