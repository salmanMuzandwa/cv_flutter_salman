import 'package:flutter/material.dart';
import '../constants.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = CvData.family;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final m = members[index];
        return _FamilyMemberCard(
          name: m['name']!,
          relation: m['relation']!,
          job: m['job']!,
        );
      },
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relation;
  final String job;

  const _FamilyMemberCard({
    required this.name,
    required this.relation,
    required this.job,
  });

  String _initiales(String nom) {
    final parts = nom.split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return nom.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ),
              ),
              child: Center(
                child: Text(
                  _initiales(name),
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Nom
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'sans-serif',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            // Lien de parenté (badge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                relation,
                style: const TextStyle(
                  fontFamily: 'sans-serif',
                  color: AppColors.primary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            // Profession
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.work_outline,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'sans-serif',
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
