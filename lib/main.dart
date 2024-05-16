import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pocket_mtg/dice/dice_screen.dart';
import 'package:pocket_mtg/proxy/proxy_page.dart';
import 'package:pocket_mtg/themes/localization_notifier.dart';
import 'package:pocket_mtg/themes/my_svg_icon.dart';
import 'package:pocket_mtg/themes/theme_notifier.dart';
import 'package:pocket_mtg/themes/theme_page.dart';
import 'package:pocket_mtg/themes/themes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:pocket_mtg/room_overview/services/firestore_service.dart';
import 'room_overview/views/room_page.dart';

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
        ChangeNotifierProvider(create: (context) => LocaleNotifier(const Locale('en'))),
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
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    return MaterialApp(
      title: 'PocketMTG',
      theme: themeNotifier.getTheme().buildTheme(),
      locale: localeNotifier.locale,
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
  State<BottomNavigationBarExample> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const RoomPage(), 
    const ProxyPage(),
    const DicePage(),
    const ThemePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-adventure.svg', isSelected: _selectedIndex == 0),
            label: i10n.room,
          ),
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-transform.svg', isSelected: _selectedIndex == 1),
            label: i10n.proxy,
          ),
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-d20.svg', isSelected: _selectedIndex == 2),
            label: i10n.dice,
          ),
          BottomNavigationBarItem(
            icon: MySVGIcon(iconPath: 'assets/ability-prototype.svg', isSelected: _selectedIndex == 3),
            label: i10n.theme,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
    );
  }
}