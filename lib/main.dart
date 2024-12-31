import 'package:blocsol_loan_application/firebase_options.dart';
import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Intl.defaultLocale = 'en_IN';
  await initializeDateFormatting('en_IN', null);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://34543ae5849eb04f60ad919ed0512d76@o4506512927424512.ingest.us.sentry.io/4508408057364480';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 0.8;
    },
    appRunner: () => runApp(
      const ProviderScope(
        child: LoanApplication(),
      ),
    ),
  );

  // runApp(
  //   const ProviderScope(
  //     child: LoanApplication(),
  //   ),
  // );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoanApplication extends ConsumerStatefulWidget {
  const LoanApplication({super.key});

  @override
  ConsumerState<LoanApplication> createState() => _LoanApplicationState();
}

class _LoanApplicationState extends ConsumerState<LoanApplication> {
  @override
  Widget build(BuildContext context) {
    FlutterUxcam
        .optIntoSchematicRecordings(); // Confirm that you have user permission for screen recording
    FlutterUxConfig config = FlutterUxConfig(
        userAppKey: "a9foi7aihqro4x5", enableAutomaticScreenNameTagging: false);
    FlutterUxcam.startWithConfiguration(config);
    final theme = ref.watch(appThemeProvider);
    final _ = ref.watch(authProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Invoicepar',
      theme: theme.valueOrNull ?? AppThemeData.defaultTheme,
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('pa'), // Punjabi
      ],
      routerConfig: router,
    );
  }
}
