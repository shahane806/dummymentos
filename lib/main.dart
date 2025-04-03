// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/screens/splash_screen.dart';
import 'bloc/dropdown_category/dropdown_bloc.dart';
import 'bloc/fetch_docs/fetch_docs_bloc.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/password_protector_bloc/password_protector_bloc.dart';
import 'bloc/upload_docs/upload_docs_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DropdownBloc(),
        ),
        BlocProvider(
          create: (context) => UploadDocsBloc(),
        ),
        BlocProvider(
          create: (context) => FetchDocsBloc(),
        ),
        BlocProvider(
          create: (context) => PasswordProtectorBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Document Management',
        home: SplashScreen(),
      ),
    );
  }
}
