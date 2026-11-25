import 'package:flutter/material.dart';
import '../constants.dart';

class CvPage extends StatefulWidget {
  const CvPage({super.key});

  @override
  State<CvPage> createState() => _CvPageState();
}

class _CvPageState extends State<CvPage> {
  // Contrôleurs pour l'édition
  final _nameController = TextEditingController(text: CvData.name);
  final _titleController = TextEditingController(text: CvData.title);
  final _aboutController = TextEditingController(text: CvData.about);
  final _locationController = TextEditingController(text: CvData.location);
  final _phoneController = TextEditingController(text: CvData.phone);
  final _emailController = TextEditingController(text: CvData.email);

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Ouvre la boîte de dialogue d'édition des informations du CV
  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text(
              'Modifier mes informations',
              style: TextStyle(
                fontFamily: 'sans-serif',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre / Profession',
                      prefixIcon: Icon(Icons.work_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Localisation',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _aboutController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'À propos de moi',
                      prefixIcon: Icon(Icons.article_outlined),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    CvData.name = _nameController.text.trim();
                    CvData.title = _titleController.text.trim();
                    CvData.location = _locationController.text.trim();
                    CvData.phone = _phoneController.text.trim();
                    CvData.phoneUri = _phoneController.text
                        .trim()
                        .replaceAll(' ', '')
                        .replaceAll('-', '');
                    CvData.email = _emailController.text.trim();
                    CvData.about = _aboutController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informations mises à jour avec succès.'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: const Text('Enregistrer'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildAboutSection(),
          const SizedBox(height: 16),
          _buildSection(
            icon: Icons.school_outlined,
            title: 'Formation',
            child: Column(
              children: CvData.education
                  .map((e) => _EducationCard(edu: e))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            icon: Icons.work_outline,
            title: 'Expérience professionnelle',
            child: Column(
              children: CvData.experiences
                  .map((e) => _ExperienceCard(exp: e))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            icon: Icons.emoji_events_outlined,
            title: 'Formations & Certifications',
            child: Column(
              children: CvData.formations
                  .map((f) => _FormationCard(f: f))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _buildSkillsSection(),
          const SizedBox(height: 16),
          _buildLanguagesSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          // Icône crayon au-dessus de l'avatar
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _openEditDialog,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          // Avatar avec photo
          GestureDetector(
            onTap: _openEditDialog,
            child: Stack(
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      CvData.avatarPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withValues(alpha: 0.2),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Badge crayon sur l'avatar
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            CvData.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'sans-serif',
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              CvData.title,
              style: const TextStyle(
                fontFamily: 'sans-serif',
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                CvData.location,
                style: const TextStyle(
                  fontFamily: 'sans-serif',
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      icon: Icons.person_outline,
      title: 'À propos de moi',
      child: Text(
        CvData.about,
        style: const TextStyle(
          fontFamily: 'sans-serif',
          color: AppColors.textMuted,
          height: 1.5,
          fontSize: 14,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildSkillsSection() {
    return _buildSection(
      icon: Icons.star_border,
      title: 'Compétences',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: CvData.competences
            .map(
              (s) => Chip(
                label: Text(
                  s,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    fontSize: 13,
                  ),
                ),
                backgroundColor: AppColors.light,
                labelStyle: const TextStyle(color: AppColors.primaryDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide.none,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLanguagesSection() {
    return _buildSection(
      icon: Icons.translate,
      title: 'Langues',
      child: Row(
        children: CvData.languages
            .map(
              (l) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l,
                      style: const TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final Map<String, String> edu;
  const _EducationCard({required this.edu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu['period']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  edu['school']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  edu['degree']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  edu['detail']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Map<String, String> exp;
  const _ExperienceCard({required this.exp});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exp['role']!,
          style: const TextStyle(
            fontFamily: 'sans-serif',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          exp['tasks']!,
          style: const TextStyle(
            fontFamily: 'sans-serif',
            color: AppColors.textMuted,
            height: 1.6,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }
}

class _FormationCard extends StatelessWidget {
  final Map<String, String> f;
  const _FormationCard({required this.f});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.fiber_manual_record,
            size: 12,
            color: AppColors.accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f['date']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  f['title']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  f['org']!,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.textMuted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
