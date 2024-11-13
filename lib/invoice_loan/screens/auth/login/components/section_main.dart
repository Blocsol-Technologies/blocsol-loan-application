import 'package:blocsol_loan_application/invoice_loan/screens/auth/login/components/section_main_background.dart';
import 'package:blocsol_loan_application/invoice_loan/constants/theme.dart';
import 'package:blocsol_loan_application/utils/ui/fonts.dart';
import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:blocsol_loan_application/utils/ui/spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SectionMain extends StatefulWidget {
  final TextInputType keyboardType;
  final TextEditingController textController;
  final List<TextInputFormatter> inputFormatters;
  final Widget textInputChild;
  final Function onTextChanged;
  final Function performAction;
  final RegExp? regex;

  final int maxInputLength;
  final String hintText;
  final bool isObscure;
  final bool hasErrored;
  final bool showBackButton;

  final double gap;

  const SectionMain(
      {super.key,
      required this.textInputChild,
      required this.maxInputLength,
      required this.keyboardType,
      required this.hintText,
      required this.onTextChanged,
      required this.isObscure,
      required this.hasErrored,
      required this.performAction,
      required this.textController,
      required this.inputFormatters,
      this.regex,
      this.showBackButton = false,
      this.gap = 35});

  @override
  State<SectionMain> createState() => _SectionMainState();
}

class _SectionMainState extends State<SectionMain>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _textFocusNode = FocusNode();

  late AnimationController _animationController;
  late Animation _animation;

  bool _performingAction = false;
  bool _animationCompleted = false;

  Future<void> _performAction() async {
    if (_performingAction) return;

    setState(() {
      _performingAction = true;
    });

    await widget.performAction();

    if (!mounted) return;

    setState(() {
      _performingAction = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutExpo);

    _animation.addListener(() {
      if (_animation.isCompleted) {}
    });

    _textFocusNode.addListener(() {
      if (widget.regex != null) {
        if (widget.regex!.hasMatch(widget.textController.text)) {
          _textFocusNode.unfocus();
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // ignore: deprecated_member_use
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: SectionMainBackground(
        onAnimationComplete: () {
          setState(() {
            _animationCompleted = true;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: RelativeSize.height(60, height),
              width: width,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: TextField(
                      keyboardType: widget.keyboardType,
                      textAlign: TextAlign.start,
                      maxLength: widget.maxInputLength,
                      controller: widget.textController,
                      onChanged: (val) {
                        widget.onTextChanged(val);
                      },
                      obscureText: widget.isObscure,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: AppFontSizes.b1,
                        fontWeight: AppFontWeights.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textDirection: TextDirection.ltr,
                      focusNode: _textFocusNode,
                      inputFormatters: widget.inputFormatters,
                      decoration: InputDecoration(
                        counterText: "",
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.hasErrored
                                ? Theme.of(context).colorScheme.error
                                : const Color.fromRGBO(76, 76, 76, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      color: Theme.of(context).colorScheme.surface,
                      child: Text(
                        widget.hintText,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: AppFontSizes.b1,
                          fontWeight: AppFontWeights.normal,
                          color: const Color.fromRGBO(164, 164, 164, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SpacerWidget(
              height: 4,
            ),
            SizedBox(
              width: width,
              child: widget.textInputChild,
            ),
            SpacerWidget(
              height: widget.gap,
            ),
            _animationCompleted
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: RelativeSize.height(230, height) *
                                      (1 - _animationController.value)),
                            );
                          },
                        ),
                        Row(
                          children: [
                            widget.showBackButton
                                ? GestureDetector(
                                    onTap: () async {
                                      HapticFeedback.mediumImpact();
                                      context.pop();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              128, 128, 128, 1),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.arrow_back,
                                            size: 21,
                                            color: Color.fromRGBO(
                                                104, 104, 104, 1),
                                          ),
                                          const SpacerWidget(width: 3),
                                          Text(
                                            "Back",
                                            style: TextStyle(
                                              fontFamily: fontFamily,
                                              fontSize: AppFontSizes.h3,
                                              fontWeight: AppFontWeights.medium,
                                              color: const Color.fromRGBO(
                                                  104, 104, 104, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            SpacerWidget(width: widget.showBackButton ? 20 : 0),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                _performAction();
                              },
                              child: Container(
                                height: 40,
                                width: 105,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(128, 128, 128, 1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_performingAction)
                                      Lottie.asset(
                                          'assets/animations/loading_spinner.json',
                                          height: 40,
                                          width: 40)
                                    else ...[
                                      Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: AppFontSizes.h3,
                                          fontWeight: AppFontWeights.medium,
                                          color: const Color.fromRGBO(
                                              104, 104, 104, 1),
                                        ),
                                      ),
                                      const SpacerWidget(width: 3),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 21,
                                        color: Color.fromRGBO(104, 104, 104, 1),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
