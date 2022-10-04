import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/providers.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        fontFamily: GoogleFonts.getFont('Roboto').fontFamily,
        appBarTheme: AppBarTheme(
          shadowColor: Colors.black.withOpacity(0),
        ),
      ),
      title: 'Test',
    );
  }
}
