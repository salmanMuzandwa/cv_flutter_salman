import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d\'ouvrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre "Profil"
          const Text(
            'Profil',
            style: TextStyle(
              fontFamily: 'sans-serif',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 24),

          // En-tête : avatar + nom + "Voir le profil"
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    CvData.avatarPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.light,
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CvData.name.split(' ')[0],
                      style: const TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Show profile',
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 24),

          // Carte promotionnelle (style Airbnb)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mettez en valeur votre CV',
                        style: TextStyle(
                          fontFamily: 'sans-serif',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'It\'s simple to get set up\nand start earning.',
                        style: TextStyle(
                          fontFamily: 'sans-serif',
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Section "Paramètres"
          const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'sans-serif',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 16),

          // Liste des paramètres (style Airbnb)
          _SettingTile(
            icon: Icons.person_outline,
            title: 'Personal information',
            onTap: () {},
          ),
          _SettingTile(
            icon: Icons.phone_outlined,
            title: 'Téléphone',
            subtitle: CvData.phone,
            onTap: () => _launch('tel:${CvData.phoneUri}'),
          ),
          _SettingTile(
            icon: Icons.email_outlined,
            title: 'E-mail',
            subtitle: CvData.email,
            onTap: () => _launch('mailto:${CvData.email}'),
          ),
          _SettingTile(
            icon: Icons.location_on_outlined,
            title: 'Adresse',
            subtitle: CvData.location,
            onTap: () => _launch(
                'https://www.google.com/maps/search/?api=1&query=Goma+Nord-Kivu+RDC'),
          ),
          _SettingTile(
            icon: Icons.work_outline,
            title: 'LinkedIn',
            subtitle: 'Voir le profil LinkedIn',
            onTap: () => _launch(CvData.linkedinUrl),
          ),
          _SettingTile(
            icon: Icons.code_outlined,
            title: 'GitHub',
            subtitle: 'Voir le profil GitHub',
            onTap: () => _launch(CvData.githubUrl),
          ),

          const SizedBox(height: 24),
          const Center(
            child: Text(
              '© 2026 Chuma Muzandwa Salman',
              style: TextStyle(
                  fontFamily: 'sans-serif',
                  color: AppColors.textMuted,
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.text, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 16,
                      color: AppColors.text,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
