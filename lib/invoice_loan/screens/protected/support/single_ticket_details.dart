// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:blocsol_invoice_based_credit/state/router/router_state.dart';
// import 'package:blocsol_invoice_based_credit/state/theme/theme.dart';
// import 'package:blocsol_invoice_based_credit/state/user/support/support_state.dart';
// import 'package:blocsol_invoice_based_credit/state/user/support/support_ticket.dart';
// import 'package:blocsol_invoice_based_credit/utils/ui_utils/spacer.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';

// class SingleTicketDetails extends ConsumerStatefulWidget {
//   const SingleTicketDetails({super.key});

//   @override
//   ConsumerState<SingleTicketDetails> createState() =>
//       _SingleTicketDetailsState();
// }

// class _SingleTicketDetailsState extends ConsumerState<SingleTicketDetails> {
//   final CancelToken _cancelToken = CancelToken();
//   bool _closingTicket = false;

//   Future<void> _handleStatusRequest() async {
//     if (ref.read(supportStateProvider).sendingStatusRequest) return;

//     var response = await ref
//         .read(supportStateProvider.notifier)
//         .askForStatusUpdate(_cancelToken);

//     if (!mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: response.message,
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     } else {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: "Success",
//           message: "Update Request Sent to Lender",
//           contentType: ContentType.success,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     }

//     return;
//   }

//   Timer? _supportTicktesMessagesPollTimer;
//   final _interval = 10;

//   Future<void> pollForSupportTicketsBackground() async {
//     if (!mounted) return;

//     if (ref.read(supportStateProvider).fetchingAllSupportTickets) {
//       return;
//     }

//     var _ = await ref
//         .read(supportStateProvider.notifier)
//         .fetchSingleSupportTicket(_cancelToken);

//     if (!mounted) return;
//   }

//   void startPollingForSupportTickets() {
//     _supportTicktesMessagesPollTimer =
//         Timer.periodic(Duration(seconds: _interval), (timer) async {
//       await pollForSupportTicketsBackground();
//     });
//   }

//   Future<void> _closeTicket() async {
//     if (_closingTicket) return;

//     setState(() {
//       _closingTicket = true;
//     });
//     List<String> imageBase64 = [];

//     DateTime now = DateTime.now();

//     // Define the format
//     DateFormat formatter = DateFormat('yyyyMMddTHHmmss');

//     // Format the date
//     String formattedDate = formatter.format(now);

//     ref.read(supportStateProvider.notifier).addMessageToSelectedSupportTicket(
//         Message(
//             message: "Ticket closed by Customer",
//             agent: "CONSUMER",
//             actionTaken: "CLOSED",
//             name: "",
//             phone: "",
//             email: "",
//             updatedAt: formattedDate,
//             images: imageBase64));

//     var response = await ref
//         .read(supportStateProvider.notifier)
//         .raiseSupportIssue(
//             ref.read(supportStateProvider).selectedSupportTicket.category,
//             ref.read(supportStateProvider).selectedSupportTicket.subCategory,
//             "CLOSED",
//             "Ticket closed by Customer",
//             imageBase64,
//             _cancelToken);

//     if (!context.mounted) return;

//     setState(() {
//       _closingTicket = false;
//     });

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: response.message,
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       Future.delayed(const Duration(seconds: 10), () {
//         startPollingForSupportTickets();
//       });
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     _supportTicktesMessagesPollTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final supportRef = ref.watch(supportStateProvider);
//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 IconButton(
//                   onPressed: () {
//                     HapticFeedback.mediumImpact();
//                     context.go(AppRoutes.msme_all_tickets);
//                   },
//                   icon: Icon(
//                     Icons.arrow_back,
//                     size: 25,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                 ),
//                 const Expanded(
//                   child: SizedBox(),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     _closeTicket();
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 80,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: _closingTicket
//                           ? Lottie.asset(
//                               "assets/animations/loading_spinner.json",
//                               height: 50,
//                               width: 50,
//                             )
//                           : Text(
//                               'Close',
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//                 const SpacerWidget(
//                   width: 15,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     HapticFeedback.heavyImpact();
//                     _handleStatusRequest();
//                   },
//                   child: Container(
//                     height: 30,
//                     width: 135,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.primary,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Center(
//                       child: supportRef.sendingStatusRequest
//                           ? Lottie.asset(
//                               "assets/animations/loading_spinner.json",
//                               height: 50,
//                               width: 50,
//                             )
//                           : Text(
//                               'Request Update',
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.h3,
//                                 fontWeight: AppFontWeights.medium,
//                                 color: Theme.of(context).colorScheme.onPrimary,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Text(
//               'Ticket ID: ${supportRef.selectedSupportTicket.id}',
//               softWrap: true,
//               style: TextStyle(
//                 fontFamily: fontFamily,
//                 fontSize: AppFontSizes.h3,
//                 fontWeight: AppFontWeights.medium,
//                 color: Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: supportRef.selectedSupportTicket.conversations.length,
//               itemBuilder: (context, index) {
//                 final bool isCustomerMessage = supportRef
//                     .selectedSupportTicket.conversations[index]
//                     .isCustomerMessage();
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           border: Border.all(
//                             color: isCustomerMessage ? Colors.red : Colors.blue,
//                             width: 0.5,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: isCustomerMessage
//                               ? CrossAxisAlignment.start
//                               : CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               isCustomerMessage ? "You" : "Support",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.medium,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               supportRef.selectedSupportTicket
//                                   .conversations[index].message,
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.normal,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               "Updated At: ${supportRef.selectedSupportTicket.conversations[index].getReadableTime()}",
//                               style: TextStyle(
//                                 fontFamily: fontFamily,
//                                 fontSize: AppFontSizes.body2,
//                                 fontWeight: AppFontWeights.medium,
//                                 color:
//                                     Theme.of(context).colorScheme.onSurface,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SpacerWidget(
//                         height: 10,
//                       ),
//                       supportRef.selectedSupportTicket.conversations[index]
//                               .images.isEmpty
//                           ? const SizedBox()
//                           : SizedBox(
//                               height: 100,
//                               child: ListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 key: UniqueKey(),
//                                 itemBuilder:
//                                     (BuildContext context, int imageIndex) {
//                                   return Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     child: Base64ImageWidget(supportRef
//                                         .selectedSupportTicket
//                                         .conversations[index]
//                                         .images[imageIndex]),
//                                   );
//                                 },
//                                 itemCount: supportRef.selectedSupportTicket
//                                     .conversations[index].images.length,
//                               ),
//                             )
//                     ],
//                   ),
//                 );
//               },
//             ),
//             NewMessageBar(
//                 category: supportRef.selectedSupportTicket.category,
//                 subCategory: supportRef.selectedSupportTicket.subCategory),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// class Base64ImageWidget extends StatelessWidget {
//   final String base64String;

//   const Base64ImageWidget(this.base64String, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Decode the base64 string into bytes
//     if (isBase64(base64String)) {
//       Uint8List bytes = base64Decode(base64String);
//       // Create an Image.memory widget with the decoded bytes
//       return Image.memory(
//         bytes,
//         fit: BoxFit.cover, // Adjust the fit as needed
//       );
//     }

//     if (isImageUrl(base64String)) {
//       return Image.network(
//         base64String,
//         fit: BoxFit.cover,
//       );
//     }

//     return const SizedBox();
//   }
// }

// class NewMessageBar extends ConsumerStatefulWidget {
//   final String category;
//   final String subCategory;
//   const NewMessageBar(
//       {super.key, required this.category, required this.subCategory});

//   @override
//   ConsumerState<NewMessageBar> createState() => _NewMessageBarState();
// }

// class _NewMessageBarState extends ConsumerState<NewMessageBar> {
//   final ImagePicker _picker = ImagePicker();
//   final _messageController = TextEditingController();
//   final _cancelToken = CancelToken();
//   List<XFile> _mediaFileList = <XFile>[];

//   Future<void> _onImageButtonPressed(
//     ImageSource source, {
//     required BuildContext context,
//   }) async {
//     if (context.mounted) {
//       try {
//         _mediaFileList.clear();
//         final List<XFile> pickedFileList = await _picker.pickMultiImage();
//         setState(() {
//           _mediaFileList = pickedFileList;
//         });
//       } catch (e) {
//         final snackBar = SnackBar(
//           elevation: 0,
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Colors.transparent,
//           content: AwesomeSnackbarContent(
//             title: 'Error!',
//             message: "Unable to select images",
//             contentType: ContentType.failure,
//           ),
//         );

//         if (context.mounted) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(snackBar);
//         }
//       }
//     }
//   }

//   Future<void> _sendMessage() async {
//     if (ref.read(supportStateProvider).generatingSupportTicket) return;

//     List<String> imageBase64 = [];

//     for (int i = 0; i < _mediaFileList.length; i++) {
//       final File file = File(_mediaFileList[i].path);
//       final List<int> imageBytes = file.readAsBytesSync();
//       final String base64Image = base64Encode(imageBytes);
//       imageBase64.add(base64Image);
//     }

//     DateTime now = DateTime.now();

//     // Define the format
//     DateFormat formatter = DateFormat('yyyyMMddTHHmmss');

//     // Format the date
//     String formattedDate = formatter.format(now);

//     ref.read(supportStateProvider.notifier).addMessageToSelectedSupportTicket(
//         Message(
//             message: _messageController.text,
//             agent: "CONSUMER",
//             actionTaken: "OPEN",
//             name: "",
//             phone: "",
//             email: "",
//             updatedAt: formattedDate,
//             images: imageBase64));

//     var response = await ref
//         .read(supportStateProvider.notifier)
//         .raiseSupportIssue(widget.category, widget.subCategory, "OPEN",
//             _messageController.text, imageBase64, _cancelToken);

//     if (!context.mounted) return;

//     if (!response.success) {
//       final snackBar = SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.transparent,
//         content: AwesomeSnackbarContent(
//           title: 'Error!',
//           message: response.message,
//           contentType: ContentType.failure,
//         ),
//       );

//       ScaffoldMessenger.of(context)
//         ..hideCurrentSnackBar()
//         ..showSnackBar(snackBar);
//     } else {
//       _messageController.clear();
//       setState(() {
//         _mediaFileList.clear();
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _cancelToken.cancel();
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: _mediaFileList.isEmpty ? 145 : 190,
//       padding: const EdgeInsets.all(10),
//       width: MediaQuery.of(context).size.width,
//       color: Theme.of(context).colorScheme.surface,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _mediaFileList.isEmpty
//               ? const SizedBox()
//               : SizedBox(
//                   height: 50,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     key: UniqueKey(),
//                     itemBuilder: (BuildContext context, int index) {
//                       return Semantics(
//                           label: 'image_picker_example_picked_image',
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 5),
//                             child: Image.file(
//                               File(_mediaFileList[index].path),
//                               errorBuilder: (BuildContext context, Object error,
//                                   StackTrace? stackTrace) {
//                                 return const Center(
//                                     child: Text(
//                                         'This image type is not supported'));
//                               },
//                             ),
//                           ));
//                     },
//                     itemCount: _mediaFileList.length,
//                   ),
//                 ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: TextField(
//                   style: TextStyle(
//                     fontFamily: fontFamily,
//                     fontSize: AppFontSizes.body,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                   ),
//                   controller: _messageController,
//                   maxLines: 1,
//                 ),
//               ),
//               const SizedBox(
//                 width: 20,
//               ),
//               GestureDetector(
//                 onTap: () {
//                   HapticFeedback.mediumImpact();
//                   _onImageButtonPressed(ImageSource.gallery, context: context);
//                 },
//                 child: Container(
//                   height: 40,
//                   width: 40,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondary,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.image,
//                       color: Theme.of(context).colorScheme.onSecondary,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: () {
//               HapticFeedback.heavyImpact();
//               _sendMessage();
//             },
//             child: Container(
//               height: 40,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Center(
//                 child: ref.read(supportStateProvider).generatingSupportTicket
//                     ? Lottie.asset(
//                         "assets/animations/loading_spinner.json",
//                         height: 50,
//                         width: 50,
//                       )
//                     : Text(
//                         'Send Message',
//                         style: TextStyle(
//                           fontFamily: fontFamily,
//                           fontSize: AppFontSizes.h3,
//                           fontWeight: AppFontWeights.medium,
//                           color: Theme.of(context).colorScheme.onPrimary,
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// bool isBase64(String str) {
//   // Regular expression to check if a string is valid Base64
//   final base64RegExp = RegExp(
//     r'^[A-Za-z0-9+/]*={0,2}$',
//     caseSensitive: false,
//     multiLine: false,
//   );

//   // Check if the string matches the Base64 pattern and is valid when decoded
//   if (base64RegExp.hasMatch(str)) {
//     try {
//       base64.decode(str);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
//   return false;
// }

// bool isImageUrl(String str) {
//   final urlRegExp = RegExp(
//     r'^(https?|ftp)://[^\s/$.?#].[^\s]*$',
//     caseSensitive: false,
//     multiLine: false,
//   );

//   return urlRegExp.hasMatch(str);
// }
