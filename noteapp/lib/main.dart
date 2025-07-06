import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/note_cubit.dart';
import 'services/note_repository.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Make sure firebase is initialized

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NoteRepository(),
      child: BlocProvider(
        create: (context) => NoteCubit(context.read<NoteRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase Notes App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const AuthScreen(), // 👈 start here
        ),
      ),
    );
  }
}
