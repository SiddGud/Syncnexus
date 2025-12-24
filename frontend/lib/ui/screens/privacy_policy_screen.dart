import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style:
              GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ParagraphWidget(
              title: "1. Information We Collect:",
              points: [
                "We collect user-provided information for account creation and bill management",
                "Automatically collected data includes device information, usage patterns, and location (with user consent)."
              ],
            ),
            ParagraphWidget(
              title: "2. How We Use Your Information:",
              points: [
                "Personal information is used for account management, bill calculations, and communication.",
                "Non-personal data helps us improve our services, analyze trends, and enhance user experience."
              ],
            ),
            ParagraphWidget(
              title: "3. Data Security:",
              points: [
                "We employ industry-standard measures to safeguard user data.",
                "We do not sell or share personal information with third parties for marketing purposes."
              ],
            ),
            ParagraphWidget(
              title: "4. Third-Party Services:",
              points: [
                "Syncify may integrate with third-party services for specific functionalities.",
                "We do not sell or share personal information with third parties for marketing purposes."
              ],
            ),
            ParagraphWidget(
              title: "5. User Choices:",
              points: [
                "Users can manage notification preferences and choose to delete their account at any time.",
                "Opting out of certain data collection may impact the functionality of the app."
              ],
            ),
            ParagraphWidget(
              title: "6. Updates to Privacy Policy:",
              points: [
                "We reserve the right to update our privacy policy as needed.",
                "Users will be notified of significant changes."
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ParagraphWidget extends StatelessWidget {
  const ParagraphWidget({super.key, required this.title, required this.points});

  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...points
              .map(
                (point) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("• ",
                          style: GoogleFonts.urbanist(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Text(
                          point,
                          style: GoogleFonts.urbanist(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList()
        ],
      ),
    );
  }
}
