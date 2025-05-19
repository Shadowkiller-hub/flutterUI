import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'providers/bmtc_provider.dart';
import 'providers/user_provider.dart';
import 'routes.dart';
import 'screens/map_screen.dart';

void main() {
  // Add error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runZonedGuarded(
    () async {
      // Ensure Flutter is initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Set Google Maps API key programmatically if needed
      // Note: This is generally not needed as we set it in platform-specific files

      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BmtcProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            // Add more providers here as needed
          ],
          child: const MyBmtcApp(),
        ),
      );
    },
    (error, stackTrace) {
      debugPrint('Error caught by runZonedGuarded: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}

class MyBmtcApp extends StatelessWidget {
  const MyBmtcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: const MapScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
      builder: (context, child) {
        // Error handling for UI errors
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              backgroundColor: Colors.amber,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorDetails.exception.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      },
                      child: const Text('Return to Home'),
                    ),
                  ],
                ),
              ),
            ),
          );
        };

        return child!;
      },
    );
  }
}
