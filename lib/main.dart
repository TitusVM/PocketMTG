import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:pocket_mtg/multiplayer/services/firestore_service.dart';
import 'package:pocket_mtg/multiplayer/pages/create_room_page.dart';
import 'package:pocket_mtg/multiplayer/room_home_page.dart';
import 'package:pocket_mtg/multiplayer/pages/join_room_page.dart';

Future<void> main() async {
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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketMTG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: '/', 
      routes: {
        '/': (context) => const RoomHomePage(),
        '/create-room': (context) => CreateRoomPage(),
        '/join-room': (context) => JoinRoomPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
