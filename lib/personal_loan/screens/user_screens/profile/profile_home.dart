import 'package:blocsol_loan_application/personal_loan/screens/user_screens/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PCProfileHome extends ConsumerStatefulWidget {
  const PCProfileHome({super.key});

  @override
  ConsumerState<PCProfileHome> createState() => _PCProfileHomeState();
}

class _PCProfileHomeState extends ConsumerState<PCProfileHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const BorrowerBottomNavigationBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Text(
                "Profile Screen",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
