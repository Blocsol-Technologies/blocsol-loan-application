import 'package:blocsol_loan_application/firebase_options.dart';
import 'package:blocsol_loan_application/global_state/auth/auth.dart';
import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/global_state/theme/theme.dart';
import 'package:blocsol_loan_application/global_state/theme/theme_state.dart';
import 'package:firebase_core/firebase_core.dart';

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

  Intl.defaultLocale = 'en_IN';
  await initializeDateFormatting('en_IN', null);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://469ec94505f5cf8894e03407d282769b@o4506512927424512.ingest.sentry.io/4506755843686400';
      options.tracesSampleRate = 1.0;
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
    final theme = ref.watch(appThemeProvider);
    final _ = ref.watch(authProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Invoicepe',
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
