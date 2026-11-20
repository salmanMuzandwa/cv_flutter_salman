import 'package:flutter/material.dart';

/// Identifiants de connexion
const String kLoginEmail = 'chumasalman0@gmail.com';
const String kLoginPassword = 'GOMA2026';

/// Palette de couleurs (bleu primaire #1B0BF4)
class AppColors {
  static const Color primary = Color(0xFF1B0BF4);
  static const Color primaryDark = Color(0xFF0F07A0);
  static const Color accent = Color(0xFF4A3DFF);
  static const Color secondary = Color(0xFF6C5CE7);
  static const Color light = Color(0xFFE8E6FF);
  static const Color background = Color(0xFFF7F8FA);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1A1A2E);
  static const Color textMuted = Color(0xFF7A7A8C);
  static const Color divider = Color(0xFFE5E5ED);
}

/// Informations personnelles du CV (modifiables à la volée)
class CvData {
  static String name = 'CHUMA MUZANDWA SALMAN';
  static String title = 'Informaticien';
  static String about =
      "Étudiant en systèmes informatiques et polyvalent, je possède de solides compétences en développement web (HTML, CSS, Bootstrap) et mobile (Flutter). Mon expertise s'étend également en administration réseaux et systèmes.";

  static String phone = '+243 973958240';
  static String phoneUri = '+243973958240';
  static String email = 'chumasalman0@gmail.com';
  static String location = 'RDC, Nord-Kivu / Goma';

  static String linkedinUrl = 'https://www.linkedin.com/in/chuma-salman';
  static String githubUrl = 'https://github.com/chumasalman';

  /// Chemin de l'avatar (asset local). Remplacer le fichier par sa propre photo.
  static const String avatarPath = 'assets/images/profile.jpg';

  static List<String> competences = [
    'Programmation web & mobile',
    'Administration réseau',
    'Gestion de projets',
    'Résolution des pannes',
    'HTML, CSS, Bootstrap',
    'Flutter / Dart',
  ];

  static List<String> languages = ['Français', 'Anglais'];

  static List<Map<String, String>> education = [
    {
      'period': '2023 - 2027',
      'school': 'ISIG - GOMA',
      'degree': 'Étudiant en Systèmes Informatiques',
      'detail': 'Certifié des plusieurs formations',
    },
  ];

  static List<Map<String, String>> experiences = [
    {
      'role': 'ADMINISTRATEUR RÉSEAU ET SYSTÈME',
      'tasks':
          '• Gestion des infrastructures réseaux et des serveurs\n• Participation à la planification et à la mise en œuvre de projets d\'infrastructure\n• Contribution active à la conception et au développement de nombreux projets d\'équipe.',
    },
  ];

  static List<Map<String, String>> formations = [
    {
      'date': 'Juillet 2023',
      'title': 'Certification en leadership',
      'org': 'Programme WHYLD à Congo Tree',
    },
    {
      'date': 'Septembre 2024',
      'title': 'Formation certifiée en installation de caméras et contrôle d\'accès',
      'org': 'Hikvision',
    },
    {
      'date': '2024',
      'title': 'Certification en administration réseau',
      'org': 'Centre professionnel de l\'ISIG',
    },
  ];

  static List<Map<String, String>> family = [
    {'name': 'Muzandwa', 'relation': 'Père', 'job': 'Ingénieur'},
    {'name': 'Maman', 'relation': 'Mère', 'job': 'Enseignante'},
    {'name': 'Junior', 'relation': 'Frère', 'job': 'Étudiant'},
    {'name': 'Sarha', 'relation': 'Sœur', 'job': 'Élève'},
  ];
}
