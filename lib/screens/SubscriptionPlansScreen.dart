import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/screens/HomeScreen.dart';
import 'package:complete_women_care/screens/LoginScreen.dart';
// import 'package:toast/toast.dart';
import 'package:http/http.dart'as http;
import '../AllText.dart';
import '../main.dart';
import '../modals/GetSubsrcptionModel.dart';
import 'SubcriptionList.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  @override
  _SubscriptionPlansScreenState createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  int selectedTile;
  Razorpay _razorpay;
  int pricerazorpayy;
  StateSetter checkoutState;
  getSubsrctionNewModel healthPackage;
  bool isLoggedIn = false;
  String name,
      userId,
      packageId,
      transactionId,
      date,
      time,
      paymentType,
      amount = "";
  bool isActive;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    Future.delayed(Duration(seconds: 1),(){
      return fetchPlans();}) ;
      SharedPreferences.getInstance().then((value) {
      isLoggedIn = value.getBool("isLoggedIn") ?? false;
      userId = value.getInt("id").toString();
      print(userId);
      name = value.getString("name").toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY,
        appBar: AppBar(
          backgroundColor: WHITE,
          flexibleSpace: header(),
        ),
        body: healthPackage == null
            ? Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        )
            : body(),
      ),
    );
  }

  header() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: BLACK,
                  ),
                  constraints: BoxConstraints(maxWidth: 30, minWidth: 10),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  SUBSCRIPTION,
                  style: TextStyle(
                      color: BLACK, fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void openCheckout(String amount) async {
    // if(amount == null || amount == ""){
    //   pricerazorpayy = int.parse(healthPackage.data[0].amount.toString()) * 100;
    // }
    // else{
    pricerazorpayy= int.parse(amount.toString()) * 100;
    // }
    print("checking razorpay price ${pricerazorpayy.toString()}");
    // if(amount == null || amount == ""){
    //   pricerazorpayy= healthPackage.data[0].amount.toString() * 100;
    // }
    // else{
    //   pricerazorpayy= amount.toString() * 100;
    // }
    print("checking razorpay price ${pricerazorpayy.toString()}");
    Navigator.of(context).pop();
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': "${pricerazorpayy}",
      'name': 'Complete Women Care',
      'description': 'Complete Women Care',
      'image': 'assets/splashScreen/icon.png',
      // 'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      // 'external': {
      //   'wallets': ['paytm']
      // }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }


  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    callApiForAddingSubscription();
    // RazorpayDetailApi();
    // Order_cash_ondelivery();
    // setSnackbar("all ready Subscription Add", context);
    // messageDialog(SUCCESSFUL, SUBSCRIPTION_ADDED_SUCCESSFULLY);
    // setSnackbar("Successful", context);
    setSnackbar("Subscription added successfully", context);
    // Fluttertoast.showToast(
    //     msg: "Successful",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.green,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setSnackbar("ERROR", context);
    setSnackbar("Payment cancelled by user", context);
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);
    // Fluttertoast.showToast(
    //     msg: "Payment cancelled by user",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }

  // setSnackbar(
  //     String msg, BuildContext context,) {
  //   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
  //     duration: Duration(seconds: 1),
  //     content: new Text(
  //       msg,
  //       textAlign: TextAlign.center,
  //       style: TextStyle(color: BLACK),
  //     ),
  //     backgroundColor: Colors.grey,
  //     elevation: 1.0,
  //   ));
  // }
  var showButton = true;
  body() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: Image.asset(
                //     "assets/subscriptionScreen/suscribe.png",
                //     height: 220,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                // Text(
                //   PRICING,
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                // ),
                healthPackage.data==""? Center(child: Text("Not Data Found ",style: TextStyle(color: Colors.red),)):Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: healthPackage.data.length,
                    itemBuilder: (context, index) {
                      return
                        // healthPackage.data[index].isactive == false ? SizedBox.shrink() :
                        InkWell(
                          onTap: (){
                            print(" Active  Subscription==========>${healthPackage.data[index].isactive}");
                            if(healthPackage.data[index].isactive == true){
                              // const snackBar = SnackBar(
                              //   content: Text('All ready subscription added'),
                              // );
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              setSnackbar("All ready subscription added", context);
                              print("this is a Active Value===========>11111111${isActive}");
                            }else{
                              setState(() {
                                selectedTile = index;
                                // isActive = healthPackage.data[index].isactive;
                                amount = healthPackage.data[index].amount;
                                PackageId = healthPackage.data[index].id.toString();
                                Time = healthPackage.data[index].time.toString();
                                Date = healthPackage.data[index].createdAt;
                                Name = healthPackage.data[index].title.toString();
                                print("this is a Active Value===========>${isActive}");
                              });
                              //setSnackbar(msg, context)
                            };
                            if(healthPackage.data[index].isactive == true) {
                              showButton = false;
                              print("show status===========>${showButton}");
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: selectedTile == index
                                  ? Border.all(
                                color: LIME,
                                width: 2,
                              )
                                  : Border.all(
                                color: WHITE,
                                width: 0,
                              ),
                              color: WHITE,
                            ),
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      healthPackage.data[index].title,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: LIME),
                                    ),
                                    healthPackage.data[index].isactive == true ? Text(
                                      "SUBSCRIBED",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color:GREEN),
                                    ):SizedBox.shrink()
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "$CURRENCY ${healthPackage.data[index].amount.toString()}",
                                  style: TextStyle(
                                      fontSize: 16, color: BLACK, fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Duration: "+ " " +"${healthPackage.data[index].time}"  + " " + "${healthPackage.data[index].type}",
                                          style: TextStyle(
                                            // color: NAVY_BLUE,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        healthPackage.data[index].time > 1 ? Text("s", style: TextStyle(
                                          // color: NAVY_BLUE,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal)
                                        ): SizedBox.shrink(),
                                      ],
                                    ),
                                    healthPackage.data[index].isactive == true ? Text("${healthPackage.data[index].Enddate}",style: TextStyle(color: LIME),):SizedBox.shrink(),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  healthPackage.data[index].description,
                                  style: TextStyle(
                                    //color: NAVY_BLUE,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child:
                            //     ),
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     Column(
                            //       crossAxisAlignment: CrossAxisAlignment.end,
                            //       children: [
                            //
                            //       ],
                            //     )
                            //   ],
                            // ),
                          ),
                        );
                      // priceCard(index, healthPackage.data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        healthPackage.data==""|| healthPackage.data==null? SizedBox() : button()
      ],
    );
  }

  // priceCard(index, List<Data> list) {
  //   return InkWell(
  //     borderRadius: BorderRadius.circular(20),
  //     onTap: () {
  //       setState(() {
  //         selectedTile = index;
  //         amount = list[index].price;
  //         packageId = list[index].id.toString();
  //       });
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(5),
  //         border: selectedTile == index
  //             ? Border.all(
  //                 color: LIME,
  //                 width: 2,
  //               )
  //             : Border.all(
  //                 color: WHITE,
  //                 width: 0,
  //               ),
  //         color: WHITE,
  //       ),
  //       margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   healthPackage.data[index].image,
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  //                 ),
  //                 SizedBox(
  //                   height: 6,
  //                 ),
  //                 Text(
  //                   healthPackage.data[index].description,
  //                   style: TextStyle(
  //                       color: NAVY_BLUE,
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w300),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             width: 20,
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: [
  //               Text(
  //                 "$CURRENCY${healthPackage.data[index].price}",
  //                 style: TextStyle(
  //                     fontSize: 22, color: BLACK, fontWeight: FontWeight.w700),
  //               ),
  //               SizedBox(
  //                 height: 6,
  //               ),
  //               Text(
  //                 "monthly",
  //                 style: TextStyle(
  //                     color: NAVY_BLUE,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w300),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  fetchPlans() async {
    final response = await get(Uri.parse("$SERVER_ADDRESS/api/get-subscriptions?user_id=${userId}"));
    print("this is UserId==========>{$SERVER_ADDRESS/api/get-subscriptions?user_id=${userId}}");
    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {

      setState(() {
        healthPackage = getSubsrctionNewModel.fromJson(jsonResponse);
      });
    }
  }

  button() {
    return Row(
      children: [
         Expanded(
          child: InkWell(
            onTap: () {
              if (selectedTile == null) {
                errorDialog(PLEASE_SELECT_A_SUBSCRIPTION_PLAN);
                return;
              }
              if (isLoggedIn) {
                setState(() {
                  date = (DateTime.now().day < 10
                      ? "0" + DateTime.now().day.toString()
                      : DateTime.now().day.toString()) +
                      "-" +
                      (DateTime.now().month < 10
                          ? "0" + DateTime.now().month.toString()
                          : DateTime.now().month.toString()) +
                      "-" +
                      DateTime.now().year.toString();
                  time = (DateTime.now().hour < 12
                      ? (DateTime.now().hour < 10
                      ? "0" + DateTime.now().hour.toString()
                      : DateTime.now().hour.toString())
                      : (DateTime.now().hour - 12 < 10
                      ? "0" + (DateTime.now().hour - 12).toString()
                      : (DateTime.now().hour - 12).toString())) +
                      ":" +
                      (DateTime.now().minute < 10
                          ? "0" + DateTime.now().minute.toString()
                          : DateTime.now().minute.toString()) +
                      " " +
                      (DateTime.now().hour < 12 ? "Am" : "Pm");
                  paymentType = "2";
                });
                //openCheckout();

                addSubscription(healthPackage.data[0].amount);


              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: LIME,
              ),
              child: Center(
                child: Text(
                  isLoggedIn ? ADD_SUBSCRIPTION : LOGIN_TO_ADD_SUBSCRIPTION,
                  style: TextStyle(color: WHITE,fontWeight: FontWeight.w700, fontSize: 17),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  // AddSubscription() async {
  //   final response = await post(Uri.parse("$SERVER_ADDRESS/api/addsubscription"));
  //   final jsonResponse = jsonDecode(response.body);
  //   if (response.statusCode == 200 && jsonResponse['status'] == 1) {
  //     // setState(() {
  //     //   healthPackage = getSubsrctionNewModel.fromJson(jsonResponse);
  //     // });
  //   }
  // }

  String Name;
  String Date;
  String Time;
  String PaymentType;
  String PackageId;
  String Amount;


  // addSubscriptionApi() async {
  //   var request = http.MultipartRequest('POST', Uri.parse('${SERVER_ADDRESS}/api/addsubscription'));
  //   request.fields.addAll({
  //     'user_id': '${userId}',
  //     'name': '',
  //     'package_id': '3',
  //     'transaction_id': 'TESGGDOFIGJDFGOJDFOGDOMG',
  //     'date': '2023-02-12',
  //     'time': '18:00',
  //     'payment_type': '1',
  //     'amount': '50000'
  //   });
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var finalResult = await response.stream.bytesToString();
  //     final  jsonResponse = json.decode(finalResult);
  //     print("final respnse here ${jsonResponse}");
  //     //Fluttertoast.showToast(msg: "${jsonResponse['message']}");
  //   }
  //   else {
  //   print(response.reasonPhrase);
  //   }
  //
  // }

  addSubscription(String price) async {
    String datetime = DateTime.now().toString();
    print(datetime);
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  InkWell(
                    onTap: (){
                      openCheckout(amount);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset("assets/razorpay.jpg",height: 40,),
                          Text("RazorPay",style: TextStyle(color: BLACK,fontSize: 15),) ,

                        ],
                      ),
                    ),
                  )


                ],
              ),
            ),
          );


          // var request = BraintreeDropInRequest(
          //   tokenizationKey: TOKENIZATION_KEY,
          //   collectDeviceData: true,
          //   googlePaymentRequest: BraintreeGooglePaymentRequest(
          //     totalPrice: price,
          //     currencyCode: CURRENCY_CODE,
          //     billingAddressRequired: false,
          //   ),
          //   amount: price,
          //
          //
          //
          //   paypalRequest: BraintreePayPalRequest(
          //       amount: "${price}",
          //       currencyCode: "USD",
          //       displayName: "name",
          //       billingAgreementDescription: "xyz"),
          //   cardEnabled: true,
          // );
          //
          // await BraintreeDropIn.start(request).then((value) {
          //   setState(() {
          //     transactionId = value.paymentMethodNonce.nonce;
          //   });
          //   processingDialog(PLEASE_WAIT_WHILE_PROCESSING_PAYMENT);
          //   callApiForAddingSubscription();
          //   print("\n\n" + value.paymentMethodNonce.nonce + "\n\n");
          // }).catchError((e) {
          //   print("ERROR : $e");
          //
          //   if (!e.toString().contains("NoSuchMethodError")) {
          //     errorDialog(e.toString());
        }
    );
  }


  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              s1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s2,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubcriptionList()));
                },
                style: TextButton.styleFrom(backgroundColor: LIME),
                child: Text(
                  YES,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: WHITE,
                  ),
                ),
              ),
            ],
          );
        });
  }

  // var request = http.MultipartRequest('POST', Uri.parse('https://completewomencares.com/api/addsubscription'));
  // request.fields.addAll({
  // 'user_id': '1',
  // 'name': 'Sawan',
  // 'package_id': '3',
  // 'transaction_id': 'TESGGDOFIGJDFGOJDFOGDOMG',
  // 'date': '2023-02-12',
  // 'time': '18:00',
  // 'payment_type': '1',
  // 'amount': '50000'
  // });
  //
  //
  // http.StreamedResponse response = await request.send();
  //
  // if (response.statusCode == 200) {
  // print(await response.stream.bytesToString());
  // }
  // else {
  // print(response.reasonPhrase);
  // }

  todayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    print(formattedTime);
    print(formattedDate);
  }

  callApiForAddingSubscription() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    print(formattedTime);
    print(formattedDate);
    todayDate();
    var request = http.MultipartRequest('POST', Uri.parse('${SERVER_ADDRESS}/api/addsubscription'));
    request.fields.addAll({
      'user_id': userId,
      'name': Name,
      'package_id': PackageId,
      'transaction_id': "1",
      'date': "${formattedDate}",
      'time': "${formattedTime}",
      'payment_type': "1",
      'amount': amount
    });
    print(" this is a APi${request}");
    print(" this is a Add=>>>>>>>>>>>${request.fields}");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200){
      var finalResult = await response.stream.bytesToString();
      final  jsonResponse = json.decode(finalResult);
      print("Data============>${jsonResponse}");
      messageDialog(SUCCESSFUL, SUBSCRIPTION_ADDED_SUCCESSFULLY);
      //
    } else {
      errorDialog(ERROR_WHILE_ADDING_SUBSCRIPTION);
    }
  }

  errorDialog(message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.error,
                  size: 80,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }

  processingDialog(message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(LOADING),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                  ),
                )
              ],
            ),
          );
        });
  }
}
