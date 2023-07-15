import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'config.dart';
import 'firebase_options.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/theme/theme.dart';
import 'infrastructure/translate/translate.dart';
import 'initializer.dart';

Future<void> main() async {
  await Initializer.init();
  final initialRoute = await Routes.initialRoute;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(Main(initialRoute));
}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: EnvironmentsBadge(
            child: GetMaterialApp(
              initialRoute: initialRoute,
              getPages: Nav.routes,
              theme: themeData,
              debugShowCheckedModeBanner: false,
              supportedLocales: const [Locale('pt', 'BR'), Locale('en')],
              locale: const Locale('pt', 'BR'),
              translations: Translate(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          ),
        );
      },
    );
  }
}

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;

  const EnvironmentsBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    final env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.production
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.homolog ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}
