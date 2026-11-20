import 'package:flutter/material.dart';
import '../constants.dart';

class CvPage extends StatelessWidget {
  const CvPage({super.key});

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
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Center(
              child: Text(
                'CS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            CvData.name,
            textAlign: TextAlign.center,
            style: TextStyle(
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
            child: const Text(
              CvData.title,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined,
                  color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Text(CvData.location,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
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
            color: AppColors.textMuted, height: 1.5, fontSize: 14),
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
            .map((s) => Chip(
                  label: Text(s, style: const TextStyle(fontSize: 13)),
                  backgroundColor: AppColors.light,
                  labelStyle: const TextStyle(color: AppColors.primaryDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide.none,
                  ),
                ))
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
            .map((l) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.accent, size: 18),
                      const SizedBox(width: 6),
                      Text(l, style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ))
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
                Text(edu['period']!,
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 2),
                Text(edu['school']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(edu['degree']!,
                    style: const TextStyle(color: AppColors.textMuted)),
                Text(edu['detail']!,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12)),
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
        Text(exp['role']!,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.primaryDark)),
        const SizedBox(height: 8),
        Text(exp['tasks']!,
            style: const TextStyle(
                color: AppColors.textMuted, height: 1.6, fontSize: 13.5)),
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
          const Icon(Icons.fiber_manual_record,
              size: 12, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f['date']!,
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text(f['title']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(f['org']!,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
