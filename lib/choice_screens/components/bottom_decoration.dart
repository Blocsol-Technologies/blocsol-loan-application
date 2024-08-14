import 'package:blocsol_loan_application/utils/ui/misc.dart';
import 'package:flutter/material.dart';

class ChoiceScreenBottomDecoration extends StatelessWidget {
  const ChoiceScreenBottomDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final boxDimension = RelativeSize.width(100, width);
    return SizedBox(
      height: boxDimension * 3,
      width: width,
      child: Stack(
        children: [
          Positioned(
            child: Row(
              children: [
                Container(
                  height: boxDimension,
                  width: 15,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: 15,
                    color: const Color.fromRGBO(0, 115, 164, 1),
                  ),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          top: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: boxDimension,
                    color: const Color.fromRGBO(233, 233, 250, 1),
                  ),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                ),
                Expanded(
                  child: Container(
                    height: boxDimension,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        border: Border(
                            left: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            top: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            bottom: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ))),
                    child: Container(
                      height: boxDimension,
                      width: boxDimension,
                      color: const Color.fromRGBO(0, 115, 164, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (boxDimension * 2) - 5,
            child: Row(
              children: [
                Container(
                  height: boxDimension,
                  width: 15,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: 15,
                    color: const Color.fromRGBO(102, 51, 153, 1),
                  ),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          top: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: boxDimension,
                    color: const Color.fromRGBO(0, 115, 164, 1),
                  ),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          left: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: 15,
                    color: const Color.fromRGBO(102, 51, 153, 1),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: boxDimension - 5,
            child: Row(
              children: [
                Container(
                  height: boxDimension,
                  width: 10,
                  padding: const EdgeInsets.all(2),
                ),
                Container(
                  height: boxDimension + 5,
                  width: boxDimension + 10,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          top: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: boxDimension,
                    color: const Color.fromRGBO(144, 141, 241, 1),
                  ),
                ),
                Container(
                  height: boxDimension,
                  width: boxDimension - 10,
                  padding: const EdgeInsets.all(2),
                ),
                Container(
                  height: boxDimension + 5,
                  width: boxDimension + 10,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      border: Border(
                          left: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          top: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          right: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ))),
                  child: Container(
                    height: boxDimension,
                    width: boxDimension,
                    color: const Color.fromRGBO(233, 233, 250, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
