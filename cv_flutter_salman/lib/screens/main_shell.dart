import 'package:flutter/material.dart';
import '../constants.dart';
import 'cv_page.dart';
import 'family_page.dart';
import 'contact_page.dart';
import 'login_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [CvPage(), FamilyPage(), ContactPage()];

  final List<String> _titles = const ['Mon CV', 'Ma Famille', 'Contact'];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.light,
        destinations: const [
          // Icônes en outline (non remplies) par défaut, remplies quand sélectionnées
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // En-tête du drawer avec photo de profil
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            accountName: Text(
              CvData.name,
              style: const TextStyle(
                fontFamily: 'sans-serif',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: Text(
              CvData.email,
              style: const TextStyle(fontFamily: 'sans-serif'),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(CvData.avatarPath),
              onBackgroundImageError: (_, _) {},
              child: const Icon(Icons.person, color: AppColors.primary),
            ),
          ),
          // Éléments du menu
          ListTile(
            leading: Icon(
              Icons.person,
              color: _currentIndex == 0 ? AppColors.primary : null,
            ),
            title: Text(
              'Mon CV',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: _currentIndex == 0 ? AppColors.primary : AppColors.text,
                fontWeight: _currentIndex == 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.family_restroom,
              color: _currentIndex == 1 ? AppColors.primary : null,
            ),
            title: Text(
              'Ma Famille',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: _currentIndex == 1 ? AppColors.primary : AppColors.text,
                fontWeight: _currentIndex == 1
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.contact_phone,
              color: _currentIndex == 2 ? AppColors.primary : null,
            ),
            title: Text(
              'Contact',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: _currentIndex == 2 ? AppColors.primary : AppColors.text,
                fontWeight: _currentIndex == 2
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(2);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Déconnexion',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: Colors.redAccent,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _logout();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
