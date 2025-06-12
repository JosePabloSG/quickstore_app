import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Terms',
          style: TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A237E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last updated: June 11, 2025',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  RichText(
                    text: TextSpan(
                      text: 'Terms',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A237E),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(
                          text: ' & conditions',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSection(
                icon: Icons.info_outline,
                title: 'Introduction',
                content:
                    'Welcome to QuickStore! These terms and conditions outline the rules and regulations for the use of our services.',
              ),
              _buildSection(
                icon: Icons.gavel_outlined,
                title: 'License',
                content: 'You must not:',
                bulletPoints: [
                  'Republish material from this website',
                  'Sell, rent or sub-license material from this website',
                  'Reproduce, duplicate or copy material from this website',
                ],
              ),
              _buildSection(
                icon: Icons.security_outlined,
                title: 'Acceptable use',
                content:
                    'You must not use this website in any way that causes, or may cause, damage to the website or impairment of the availability or accessibility of the website.',
              ),
              _buildSection(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                content:
                    'For details about how we collect and use your personal information, please check our Privacy Policy.',
              ),
              _buildSection(
                icon: Icons.report_outlined,
                title: 'Limitations',
                content:
                    'We will not be liable to you in relation to the contents of, or use of, or otherwise in connection with, this website.',
                isLast: true,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    List<String>? bulletPoints,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, isLast ? 24 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A237E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF1A237E), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                if (bulletPoints != null) ...[
                  const SizedBox(height: 12),
                  ...bulletPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 24),
              child: Divider(color: Colors.grey.shade200),
            ),
        ],
      ),
    );
  }
}
