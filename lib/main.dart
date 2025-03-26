import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/core/locator.dart';
import 'package:photo_gallery/features/ui/bloc/photo_bloc.dart';
import 'package:photo_gallery/features/ui/screens/photo_screen.dart';

void main() async {
  serviceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => locator<PhotoBloc>(),
        child: PhotoScreen(),
      ),
    );
  }
}

