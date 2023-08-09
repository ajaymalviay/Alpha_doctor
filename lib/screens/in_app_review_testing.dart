// import 'dart:developer';
// import 'dart:io';
// import 'package:app_review/app_review.dart';
// import 'package:flutter/material.dart';
// import 'package:in_app_review/in_app_review.dart';
// import 'package:rate_my_app/rate_my_app.dart';
// import 'package:complete_women_care/screens/ContactUsScreen.dart';
//
// class InAppReviewTesting extends StatefulWidget {
//
//
//   InAppReviewTesting({Key key}) : super(key: key);
//
//   @override
//   State<InAppReviewTesting> createState() => _InAppReviewTestingState();
// }
//
// class _InAppReviewTestingState extends State<InAppReviewTesting> {
//   final InAppReview inAppReview = InAppReview.instance;
//
//   RateMyApp rateMyApp = RateMyApp(
//     preferencesPrefix: 'rateMyApp_',
//     minDays: 7,
//     minLaunches: 10,
//     remindDays: 7,
//     remindLaunches: 10,
//     googlePlayIdentifier: 'com.alphadoctor',
//     appStoreIdentifier: '1491556149',
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//           onPressed: () async{
//             // print(await inAppReview.isAvailable());
//             // if (await inAppReview.isAvailable()) {
//             // inAppReview.requestReview();
//             // }
//             showMyDialog();
//           },
//       ),
//     );
//   }
//
//   showMyDialog(){
//     rateMyApp.init().then((_) {
//       print('INIT DONE');
//       // if (rateMyApp.shouldOpenDialog) {
//         // rateMyApp.showRateDialog(
//         //   context,
//         //   title: 'Rate this app', // The dialog title.
//         //   message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
//         //   rateButton: 'RATE', // The dialog "rate" button text.
//         //   noButton: 'NO THANKS', // The dialog "no" button text.
//         //   laterButton: 'MAYBE LATER', // The dialog "later" button text.
//         //   listener: (button) { // The button click listener (useful if you want to cancel the click event).
//         //     switch(button) {
//         //       case RateMyAppDialogButton.rate:
//         //         print('Clicked on "Rate".');
//         //         break;
//         //       case RateMyAppDialogButton.later:
//         //         print('Clicked on "Later".');
//         //         break;
//         //       case RateMyAppDialogButton.no:
//         //         print('Clicked on "No".');
//         //         break;
//         //     }
//         //
//         //     return true; // Return false if you want to cancel the click event.
//         //   },
//         //   ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
//         //   dialogStyle: const DialogStyle(), // Custom dialog styles.
//         //   onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
//         //   // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
//         //   // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
//         // );
//
//         // Or if you prefer to show a star rating bar (powered by `flutter_rating_bar`) :
//
//         rateMyApp.showStarRateDialog(
//           context,
//           title: 'Rate this app', // The dialog title.
//           message: 'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
//           // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
//           actionsBuilder: (context, stars) { // Triggered when the user updates the star rating.
//             return [ // Return a list of actions (that will be shown at the bottom of the dialog).
//               FlatButton(
//                 child: Text('OK'),
//                 onPressed: () async {
//                   final launchStore = stars.round() >= 4;
//
//                   if(launchStore){
//                     Navigator.pop(context);
//                     await rateMyApp.launchStore();
//                   }else{
//                     Navigator.pop(context);
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
//                   }
//
//                   // print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
//                   // // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
//                   // // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
//                   // await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
//                   // Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
//                 },
//               ),
//             ];
//           },
//           ignoreNativeDialog: Platform.isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
//           dialogStyle: const DialogStyle( // Custom dialog styles.
//             titleAlign: TextAlign.center,
//             messageAlign: TextAlign.center,
//             messagePadding: EdgeInsets.only(bottom: 20),
//           ),
//           starRatingOptions: const StarRatingOptions(), // Custom star bar rating options.
//           onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
//         );
//       // }
//     });
//
//   }
// }
