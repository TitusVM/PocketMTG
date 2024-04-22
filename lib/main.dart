import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pocket_mtg/dice/dice_screen.dart';
import 'package:pocket_mtg/themes/my_svg_icon.dart';
import 'package:pocket_mtg/themes/theme_notifier.dart';
import 'package:pocket_mtg/themes/theme_page.dart';
import 'package:pocket_mtg/themes/themes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';
import 'package:pocket_mtg/multiplayer/room_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<FirebaseFirestore>.value(
          value: FirebaseFirestore.instance,
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider(create: (context) => ThemeNotifier(mtgPurple)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'PocketMTG',
      theme: themeNotifier.getTheme().buildTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const BottomNavigationBarExample(), 
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  _BottomNavigationBarExampleState createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const RoomHomePage(), 
    DicePage(),
    ThemePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-adventure.svg', isSelected: _selectedIndex == 0),
            label: 'Room',
          ),
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-d20.svg', isSelected: _selectedIndex == 1),
            label: 'Dice',
          ),
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-prototype.svg', isSelected: _selectedIndex == 2),
            label: 'Theme',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, 
      ),
    );
  }
}