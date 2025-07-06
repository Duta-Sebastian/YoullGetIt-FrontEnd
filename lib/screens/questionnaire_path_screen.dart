import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/l10n/generated/app_localizations.dart';
import 'package:youllgetit_flutter/screens/questionnaire_screen.dart';

class QuestionnairePathScreen extends StatelessWidget {
  const QuestionnairePathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Title text
              Text(
                l10n.choiceScreenTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D2D2D),
                  height: 1.3,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Fast Access option
              _buildChoiceButton(
                context,
                title: l10n.choiceScreenFastAccess,
                subtitle: l10n.choiceScreenFastAccessDesc,
                onTap: () {
                  // Handle fast access selection
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => QuestionnaireScreen(isShortQuestionnaire: true),
                  ));
                },
              ),
              
              const SizedBox(height: 24),
              
              // Higher Accuracy option
              _buildChoiceButton(
                context,
                title: l10n.choiceScreenHigherAccuracy,
                subtitle: l10n.choiceScreenHigherAccuracyDesc,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => QuestionnaireScreen(isShortQuestionnaire: false),
                  ));
                },
              ),
              
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFDE15),
          width: 2,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Subtitle (smaller text on top)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDE15).withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Main title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}