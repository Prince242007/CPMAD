
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../utils/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  final LocalStorageService storage;
  final bool darkMode;
  final String localeCode;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onLocaleChanged;

  const SettingsScreen({
    super.key,
    required this.storage,
    required this.darkMode,
    required this.localeCode,
    required this.onThemeChanged,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.text('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.text('theme'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.palette_outlined),
              value: darkMode,
              onChanged: onThemeChanged,
              title: Text(
                darkMode
                    ? l10n.text('dark')
                    : l10n.text('light'),
              ),
              subtitle: const Text(
                'Choose the appearance of DailyBite',
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            l10n.text('language'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'en',
                  groupValue: localeCode,
                  onChanged: (value) {
                    if (value != null) {
                      onLocaleChanged(value);
                    }
                  },
                  title: Text(l10n.text('english')),
                  secondary: const Icon(Icons.language),
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'hi',
                  groupValue: localeCode,
                  onChanged: (value) {
                    if (value != null) {
                      onLocaleChanged(value);
                    }
                  },
                  title: Text(l10n.text('hindi')),
                  secondary: const Icon(Icons.translate),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('DailyBite'),
            subtitle: Text(
              'Personal Recipe & Meal Planner · Task 5',
            ),
          ),
        ],
      ),
    );
  }
}
