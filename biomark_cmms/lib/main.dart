import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'state/app_state.dart';
import 'state/inspection_progress.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // The intl DateFormat calls in core/utils/formatters.dart need each locale's
  // data loaded before use, for both languages the app supports.
  await initializeDateFormatting('en');
  await initializeDateFormatting('ar');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(BiomarkApp(prefs: prefs));
}

class BiomarkApp extends StatelessWidget {
  const BiomarkApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState(prefs)),
        ChangeNotifierProvider<InspectionProgress>(create: (_) => InspectionProgress()),
      ],
      child: Consumer<AppState>(
        builder: (BuildContext context, AppState app, Widget? _) {
          return MaterialApp.router(
            title: 'BIOMARK CMMS',
            debugShowCheckedModeBanner: false,
            themeMode: app.themeMode,
            theme: AppTheme.light(app.language),
            darkTheme: AppTheme.dark(app.language),
            locale: app.locale,
            supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            builder: (BuildContext context, Widget? child) {
              return Directionality(
                textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: child!,
              );
            },
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
