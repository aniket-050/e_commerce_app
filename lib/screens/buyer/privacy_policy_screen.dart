import 'package:flutter/material.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Last Updated: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Introduction'),
            _buildParagraph(
              'Welcome to our Privacy Policy. This document explains how we collect, use, and protect your personal information when you use our e-commerce application.',
            ),
            _buildParagraph(
              'By using our application, you agree to the collection and use of information in accordance with this policy.',
            ),

            _buildSectionTitle('Information We Collect'),
            _buildBulletPoint(
              'Personal Information: Name, email address, phone number, billing address, and shipping address.',
            ),
            _buildBulletPoint(
              'Account Information: Username, password, and profile details.',
            ),
            _buildBulletPoint(
              'Transaction Information: Products purchased, payment methods, and order history.',
            ),
            _buildBulletPoint(
              'Device Information: IP address, browser type, device type, and operating system.',
            ),
            _buildBulletPoint(
              'Usage Information: How you interact with our application, including pages visited and features used.',
            ),

            _buildSectionTitle('How We Use Your Information'),
            _buildBulletPoint('To process and fulfill your orders.'),
            _buildBulletPoint(
              'To provide customer support and respond to your inquiries.',
            ),
            _buildBulletPoint('To improve our application and services.'),
            _buildBulletPoint(
              'To send you promotional emails and notifications (which you can opt out of).',
            ),
            _buildBulletPoint(
              'To prevent fraud and ensure secure transactions.',
            ),

            _buildSectionTitle('Data Sharing and Disclosure'),
            _buildParagraph(
              'We may share your information with third parties in the following circumstances:',
            ),
            _buildBulletPoint(
              'With service providers who help us operate our business (payment processors, shipping companies, etc.).',
            ),
            _buildBulletPoint('If required by law or to protect our rights.'),
            _buildBulletPoint(
              'In the event of a merger, acquisition, or sale of all or part of our assets.',
            ),
            _buildBulletPoint('With your consent or at your direction.'),

            _buildSectionTitle('Data Security'),
            _buildParagraph(
              'We implement appropriate technical and organizational measures to protect your personal information from unauthorized access, loss, or alteration.',
            ),
            _buildParagraph(
              'However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
            ),

            _buildSectionTitle('Your Rights'),
            _buildParagraph(
              'Depending on your location, you may have certain rights regarding your personal information, including:',
            ),
            _buildBulletPoint(
              'Access: You can request access to the personal information we hold about you.',
            ),
            _buildBulletPoint(
              'Correction: You can request that we correct inaccurate or incomplete information.',
            ),
            _buildBulletPoint(
              'Deletion: You can request that we delete your personal information.',
            ),
            _buildBulletPoint(
              'Restriction: You can request that we restrict the processing of your information.',
            ),
            _buildBulletPoint(
              'Data Portability: You can request a copy of your data in a structured, commonly used format.',
            ),

            _buildSectionTitle('Cookies and Tracking Technologies'),
            _buildParagraph(
              'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and deliver personalized content.',
            ),
            _buildParagraph(
              'You can control cookies through your browser settings, but disabling certain cookies may limit your ability to use some features of our application.',
            ),

            _buildSectionTitle('Children\'s Privacy'),
            _buildParagraph(
              'Our services are not intended for children under 13, and we do not knowingly collect personal information from children under 13.',
            ),

            _buildSectionTitle('Changes to This Privacy Policy'),
            _buildParagraph(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
            ),
            _buildParagraph(
              'We recommend that you review this Privacy Policy periodically for any changes.',
            ),

            _buildSectionTitle('Contact Us'),
            _buildParagraph(
              'If you have any questions about this Privacy Policy, please contact us at:',
            ),
            _buildParagraph('Email: privacy@example.com'),
            _buildParagraph('Address: 123 E-Commerce Street, Tech City, 12345'),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
