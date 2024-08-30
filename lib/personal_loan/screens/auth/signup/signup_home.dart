import 'package:blocsol_loan_application/global_state/router/router.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/personal_loan/contants/routes/signup_router.dart';
import 'package:blocsol_loan_application/personal_loan/state/auth/signup/signup.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:url_launcher/url_launcher.dart';

class PCSignupHome extends ConsumerStatefulWidget {
  const PCSignupHome({super.key});

  @override
  ConsumerState<PCSignupHome> createState() => _PCSignupHomeState();
}

class _PCSignupHomeState extends ConsumerState<PCSignupHome> {
  Future<void> _googleSignIn() async {
    final googleAccount = await GoogleSignIn().signIn();

    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(code: "operation-not-allowed");
      }

      var email = userCredential.user!.email ?? "";
      var imageURL = userCredential.user!.photoURL ?? "";

      if (email == "") {
        throw FirebaseAuthException(code: "operation-not-allowed");
      }

      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      if (!mounted) return;

      ref
          .read(personalLoanSignupProvider.notifier)
          .updateEmailDetails(email, imageURL);

      ref.read(routerProvider).push(PersonalLoanSignupRouter.mobile_auth);
    } catch (e) {
      var errorMessage = "An error occurred. Please try again later.";

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-credential' || 'wrong-password':
            errorMessage = "Incorrect Password: Please try again.";
            break;
          case 'account-exists-with-different-credential':
            errorMessage =
                "Account Exists with different Credentials: Please try again";
            break;
          case 'operation-not-allowed':
            errorMessage =
                "Could not get account details from Google: Please try again later.";
            break;
          case 'invalid-verification-code' || 'invalid-verification-id':
            errorMessage =
                "Invalid Account Verification Code: Please try again";
            break;
          default:
            errorMessage =
                e.message ?? "An error occurred. Please try again later.";
            break;
        }
      }

      if (mounted) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message: errorMessage,
            contentType: ContentType.failure,
          ),
          duration: const Duration(seconds: 5),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SizedBox(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: width,
                height: RelativeSize.height(140, height),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    Positioned(
                      top: -1 * height * 0.4,
                      left: -1 * width * 0.25,
                      child: Container(
                        height: height * 0.7,
                        width: width * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -1 * height * 0.38,
                      left: -1 * width * 0.38,
                      child: Container(
                        height: height * 0.7,
                        width: width * 0.7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                        RelativeSize.width(25, width),
                        RelativeSize.height(30, height),
                        RelativeSize.width(35, width),
                        RelativeSize.height(30, height),
                      ),
                      height: RelativeSize.height(140, height),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_rounded,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 30,
                            ),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              ref.read(routerProvider).pop();
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.support_agent_outlined,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 30,
                            ),
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              const whatsappUrl = "https://wa.me/918360458365";

                              await launchUrl(Uri.parse(whatsappUrl));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SpacerWidget(
                height: 15,
              ),
              SizedBox(
                width: width,
                child: Center(
                  child: Text(
                    "Personal Loan",
                    style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.title,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: AppFontWeights.bold),
                  ),
                ),
              ),
              const SpacerWidget(
                height: 45,
              ),
              SizedBox(
                width: width,
                height: 80.0,
              ),
              Expanded(
                child: Container(
                  width: width,
                  padding: EdgeInsets.fromLTRB(
                      RelativeSize.width(60, width),
                      RelativeSize.height(40, height),
                      RelativeSize.width(60, width),
                      RelativeSize.height(50, height)),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.h1,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                      const SpacerWidget(
                        height: 5,
                      ),
                      Text(
                        "Get Instant Loan offers from Top Banks",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: AppFontWeights.normal,
                        ),
                      ),
                      const SpacerWidget(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          HapticFeedback.mediumImpact();
                          await _googleSignIn();
                        },
                        child: Container(
                          height: 40,
                          width: width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SpacerWidget(
                                width: 50,
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: Image.asset(
                                  "assets/images/3rd_party/google_logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SpacerWidget(
                                width: 30,
                              ),
                              Text(
                                "Continue with Google",
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: AppFontSizes.b2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: AppFontWeights.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SpacerWidget(
                        height: 40,
                      ),
                      Text(
                        "By continuing, you agree to our Provide your personal information with us which will be shared with the lenders on our platform",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: AppFontWeights.normal,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const SpacerWidget(
                        height: 3,
                      ),
                      Text(
                        "Terms and Conditions*",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b2,
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: AppFontWeights.medium,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
