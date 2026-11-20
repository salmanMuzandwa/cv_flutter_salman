import 'package:flutter/material.dart';

/// Identifiants de connexion
const String kLoginEmail = 'chumasalman0@gmail.com';
const String kLoginPassword = 'GOMA2026';

/// Palette de couleurs (teal professionnel, inspirée du CV)
class AppColors {
  static const Color primary = Color(0xFF1B5E6B);
  static const Color primaryDark = Color(0xFF0E3D47);
  static const Color accent = Color(0xFF2D8B8F);
  static const Color secondary = Color(0xFF3A9BA0);
  static const Color light = Color(0xFFE0F2F1);
  static const Color background = Color(0xFFF5F7F8);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1C2B2E);
  static const Color textMuted = Color(0xFF5A6B6E);
  static const Color divider = Color(0xFFD5E3E4);
}

/// Informations personnelles du CV
class CvData {
  static const String name = 'CHUMA MUZANDWA SALMAN';
  static const String title = 'Informaticien';
  static const String about =
      "Étudiant en systèmes informatiques et polyvalent, je possède de solides compétences en développement web (HTML, CSS, Bootstrap) et mobile (Flutter). Mon expertise s'étend également en administration réseaux et systèmes.";

  static const String phone = '+243 973958240';
  static const String phoneUri = '+243973958240';
  static const String email = 'chumasalman0@gmail.com';
  static const String location = 'RDC, Nord-Kivu / Goma';

  static const String linkedinUrl = 'https://www.linkedin.com/in/chuma-salman';
  static const String githubUrl = 'https://github.com/chumasalman';

  static const List<String> competences = [
    'Programmation web & mobile',
    'Administration réseau',
    'Gestion de projets',
    'Résolution des pannes',
    'HTML, CSS, Bootstrap',
    'Flutter / Dart',
  ];

  static const List<String> languages = ['Français', 'Anglais'];

  static const List<Map<String, String>> education = [
    {
      'period': '2023 - 2027',
      'school': 'ISIG - GOMA',
      'degree': 'Étudiant en Systèmes Informatiques',
      'detail': 'Certifié des plusieurs formations',
    },
  ];

  static const List<Map<String, String>> experiences = [
    {
      'role': 'ADMINISTRATEUR RÉSEAU ET SYSTÈME',
      'tasks':
          '• Gestion des infrastructures réseaux et des serveurs\n• Participation à la planification et à la mise en œuvre de projets d\'infrastructure\n• Contribution active à la conception et au développement de nombreux projets d\'équipe.',
    },
  ];

  static const List<Map<String, String>> formations = [
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

  static const List<Map<String, String>> family = [
    {'name': 'Muzandwa', 'relation': 'Père', 'job': 'Ingénieur'},
    {'name': 'Maman', 'relation': 'Mère', 'job': 'Enseignante'},
    {'name': 'Junior', 'relation': 'Frère', 'job': 'Étudiant'},
    {'name': 'Sarha', 'relation': 'Sœur', 'job': 'Élève'},
  ];
}
