import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.mediumPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppTheme.white, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      'settings'.tr(),
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppInfoSection(context),
              const SizedBox(height: AppConstants.mediumPadding),
              _buildFeaturesSection(context),
              const SizedBox(height: AppConstants.mediumPadding),
              _buildSupportSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return _buildSectionCard(
      title: 'app_info'.tr(),
      children: [
        _buildListTile(
          icon: Icons.info_outline,
          title: 'REphoto',
          subtitle: 'version'.tr(namedArgs: {'version': AppConstants.appVersion}),
          onTap: () => _showAboutDialog(context),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.privacy_tip_outlined,
          title: 'privacy_policy'.tr(),
          subtitle: 'privacy_policy_description'.tr(),
          onTap: () => _navigateToPrivacyPolicy(context),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return _buildSectionCard(
      title: 'features'.tr(),
      children: [
        _buildListTile(
          icon: Icons.language,
          title: 'language_settings'.tr(),
          subtitle: 'korean'.tr(),
          onTap: () => _showLanguageDialog(context),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.photo_size_select_actual,
          title: 'default_quality'.tr(),
          subtitle: 'high_quality'.tr(),
          onTap: () => _showQualityDialog(context),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSectionCard(
      title: 'support'.tr(),
      children: [
        _buildListTile(
          icon: Icons.help_outline,
          title: 'help_center'.tr(),
          subtitle: 'get_help_and_support'.tr(),
          onTap: () => _openHelpCenter(),
        ),
        _buildDivider(),
        _buildListTile(
          icon: Icons.feedback_outlined,
          title: 'send_feedback'.tr(),
          subtitle: 'help_us_improve'.tr(),
          onTap: () => _sendFeedback(),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.grey800,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryBlue, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.grey800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.grey600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.grey400,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppTheme.grey200,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'REphoto',
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const Icon(
        Icons.photo_library,
        size: 48,
        color: AppTheme.primaryBlue,
      ),
      children: [
        Text('about_app_description'.tr()),
      ],
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('한국어'),
              onTap: () {
                context.setLocale(const Locale('ko'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_quality'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('high_quality'.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('medium_quality'.tr()),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('low_quality'.tr()),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openHelpCenter() {
    // TODO: Implement help center navigation
  }

  void _sendFeedback() {
    // TODO: Implement feedback functionality
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_policy'.tr()),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppConstants.mediumPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy content would go here...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}