import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_note/providers/theme_provider.dart';
import 'package:smart_note/providers/note_provider.dart';
import 'package:smart_note/providers/reminder_provider.dart';
import 'package:smart_note/screens/home_screen.dart';
import 'package:smart_note/screens/categories_screen.dart';
import 'package:smart_note/screens/search_screen.dart';
import 'package:smart_note/screens/settings_screen.dart';
import 'package:smart_note/utils/auth_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthUtils.initializeAuth();
  runApp(const SmartNoteApp());
}

class SmartNoteApp extends StatelessWidget {
  const SmartNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Smart Note - Offline Notebook & Reminder',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF87CEEB), // Teal blue
              scaffoldBackgroundColor: const Color(0xFFFFFDD0), // Cream
              cardColor: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.1),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black87),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: const Color(0xFF4682B4), // Darker teal
              scaffoldBackgroundColor: const Color(0xFF2F2F2F), // Dark gray
              cardColor: const Color(0xFF3A3A3A),
              shadowColor: Colors.black.withOpacity(0.2),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white70),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            themeMode: themeProvider.themeMode,
            home: AuthUtils.isAuthenticated ? const MainScreen() : const AuthScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    CategoriesScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool authenticated = await AuthUtils.authenticate();
            if (authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            }
          },
          child: const Text('Unlock App'),
        ),
      ),
    );
  }
}
