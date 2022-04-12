import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthwatch/dialogs/policy_dialog.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: "Terms and Conditions\n",
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Open dialog of Informed Consent
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(
                              mdFileName: 'terms_and_conditions.md');
                        });
                  }),
            TextSpan(text: "&\n"),
            TextSpan(
                text: "Privacy Policy!",
                style: TextStyle(fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Open dialog of Privacy Policy
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PolicyDialog(mdFileName: 'privacy_policy.md');
                        });
                  })
          ])),
    );
  }
}
