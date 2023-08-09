import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/AllText.dart';
import 'package:complete_women_care/modals/DepartmentsList.dart';
import 'package:complete_women_care/modals/DoctorsAndServices.dart';
import '../main.dart';
import '../modals/BookAppoinmentModel.dart';
import '../modals/GetTimeSloteModel.dart';
import 'package:http/http.dart'as http;


class BookAppointment extends StatefulWidget {
  @override
  _BookAppointmentState createState() => _BookAppointmentState();

}

class _BookAppointmentState extends State<BookAppointment> {
  String departmentValue;
  var filesPath;
  String fileName;
  String resumeData;
  final ImagePicker _picker = ImagePicker();
  File imageFile;
  String doctorValue;
  String serviceValue;
  int doctorId;
  int serviceId;
  int departmentId;
  int userId;
  String selectedFormattedDate;
  TextEditingController nameController = TextEditingController();
  TextEditingController firstNmaeCtr = TextEditingController();
  TextEditingController lastNameCtr = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController msgCtr = TextEditingController();
  String date;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String _hour, _minute, _time = "";

  int selectedTile;
  int pricerazorpayy;
  StateSetter checkoutState;
  bool isLoggedIn = false;
  bool isTapped = false;
  String name,

      packageId,
      transactionId,

      time,
      paymentType,
      amount = "";
  bool isActive;

  DoctorsAndServices doctorsAndServices;
  bool isLoadingDoctorAndServices = false;
  bool isAppointmentMadeSuccessfully = false;


  DateTime dateTime = DateTime.now();


  bool isLoading = true;
  bool istimingSlotLoading = true;
  bool isNoSlot = false;
  bool isNoTimingSlot = false;
  String description = "";

  String slotId = "";
  String slotName = "";
  bool isPhoneError = false;
  ScrollController scrollController = ScrollController();

  String AppointmentId = "";
  TextEditingController textEditingController = TextEditingController();
  String razorKey;
  List<String> days = [
    SUNDAY,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY,
  ];
  List<String> monthsList = [
    "",
    JAN,
    FEB,
    MARCH,
    APRIL,
    MAY,
    JUNE,
    JULY,
    AUGUST,
    SEPTEMBER,
    OCTOBER,
    NOVEMBER,
    DECEMBER
  ];

  DepartmentsList departmentsList;

  String message = "";

  List<bool> isSelected = [];
  List<bool> selectedSlot = [];
  List<bool> selectedTimingSlot = [];
  int previousSelectedIndex = 0;
  int previousSelectedSlot = 0;
  int previousSelectedTimingSlot = 0;
  int currentSlotsIndex = 0;
  bool isDescriptionEmpty = false;
  Future<bool> checkHolidayFuture;
  String current_index  ;
  String currentDay;
  String status_Index;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  Razorpay _razorpay;
  var myDay;
  var current_Index1;
  String selectedDay ;


  @override
  void initState() {
    super.initState();
    getTimeSlote();
    selectedFormattedDate = selectedDate.day.toString() +
        " " +
        monthsList[selectedDate.month] +
        ", " +
        selectedDate.year.toString();
    current_index = "Select Time";
    getDepartmentsList();
    SharedPreferences.getInstance().then((value) {
      userId = value.getInt("id");
      // nameController = TextEditingController(text: value.getString("name"));
      // phoneController =
      //     TextEditingController(text: value.getString("phone_no"));

    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getPrice();
  }

  String price;
  getPrice() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    price  =  preferences.getString('totalAmount');
    print('_______cscsc___${price}_________');
  }
  bool isLoad =true;
  GetTimeSlotModel getTimeSlotModel;
  getTimeSlote() async {
    setState(() {
      isLoad=true;
    });
    var request = http.Request('GET', Uri.parse('${SERVER_ADDRESS}/api/get-time-slot'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
       final result = await response.stream.bytesToString();
      var  finalResult = GetTimeSlotModel.fromJson(json.decode(result));
      print(" this a time slote Api=======>${finalResult}");
      setState(() {
        getTimeSlotModel = finalResult;
      });
      setState(() {
        isLoad=false;
      });
       myDay = current_Index1;
      print("this is time data ${getTimeSlotModel.data.length}");
    }
    else {
    print(response.reasonPhrase);
    }

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BG,
        appBar: AppBar(
          leading: Container(),
          flexibleSpace: header(),
          elevation: 0,
          backgroundColor: WHITE,
        ),
        body: body(),
      ),
    );
  }
  void openCheckout(String price) async {
    print('____scsfsdvc______${amount}_________');
    double res = double.parse(price.toString());
    pricerazorpayy = int.parse(res.toStringAsFixed(0)) * 100;

    print("checking razorpay price ${pricerazorpayy.toString()}");
    print("checking razorpay price ${pricerazorpayy.toString()}");
    // Navigator.of(context).pop();
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': "${pricerazorpayy}",
      'name': 'Complete Womens Care',
      'image':'assets/splash/splashimages.png',
      'description': 'Complete Womens Care',
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  // void openCheckout(String price) async {
  //    pricerazorpayy= double.parse(price.toString()) * 100;
  //   print("checking razorpay price ${pricerazorpayy.toString()}");
  //   Navigator.of(context).pop();
  //   var options = {
  //     'key': 'rzp_test_1DP5mmOlF5G5ag',
  //     'amount': pricerazorpayy,
  //     'name': 'Complete Womens Care',
  //     'description': 'Complete Womens Care',
  //   };
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // bookAppointment();
    // Fluttertoast.showToast(msg: "Booking Done");
    print("ddsfskfskdfsf");
    Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarScreen()));

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
                  APPOINTMENT_NOW,
                  style: TextStyle(
                      color: NAVY_BLUE,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  body() {
    return departmentsList == null
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        :
    Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FIRST_NAME,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // TextFormField(
                        //   onChanged: (value){
                        //     print("first nameeemee ${firstNmaeCtr.text}");
                        //   },
                        //   controller: firstNmaeCtr,
                        //   decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                        // ),
                        TextField(
                          controller: firstNmaeCtr,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              isCollapsed: true),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LIGHT_GREY_TEXT),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          LAST_NAME,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: lastNameCtr,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              isCollapsed: true),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LIGHT_GREY_TEXT),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            SELECT_DEPARTMENT,
                          ),
                          value: departmentValue,
                          items: List.generate(departmentsList.data.length,
                              (index) {
                            return DropdownMenuItem(
                              value: departmentsList.data[index].name,
                              child: Text(
                                departmentsList.data[index].name.toString(),
                                style: TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                setState(() {departmentId = departmentsList.data[index].id;
                                });
                                fetchDoctorsAndServices(departmentsList.data[index].id);
                              },
                              key: UniqueKey(),
                            );
                          }),
                          icon: Image.asset(
                            "assets/bookappointment/down-arrow.png",
                            height: 15,
                            width: 15,
                          ),
                          onChanged: (val) {
                            print(val);
                            setState(() {
                              departmentValue = val.toString();
                            });
                          },
                        ),
                        // SizedBox(
                        //   height: 8,
                        // ),
                        // DropdownButton(
                        //   isExpanded: true,
                        //   hint: Text(
                        //     isLoadingDoctorAndServices
                        //         ? LOADING
                        //         : SELECT_DOCTOR,
                        //   ),
                        //   value: doctorValue,
                        //   icon: Image.asset(
                        //     "assets/bookappointment/down-arrow.png",
                        //     height: 15,
                        //     width: 15,
                        //   ),
                        //   items: doctorsAndServices == null
                        //       ? []
                        //       : List.generate(
                        //           doctorsAndServices.data.doctor.length,
                        //           (index) {
                        //           return DropdownMenuItem(
                        //             value: doctorsAndServices
                        //                 .data.doctor[index].name,
                        //             child: Text(doctorsAndServices
                        //                 .data.doctor[index].name),
                        //             key: UniqueKey(),
                        //             onTap: () {
                        //               setState(() {
                        //                 doctorId = doctorsAndServices.data.doctor[index].userId;
                        //                 // doctorId = doctorsAndServices
                        //                 //     .data.doctor[index].userId;
                        //               });
                        //             },
                        //           );
                        //         }),
                        //   onChanged: (val) {
                        //     print(val);
                        //     setState(() {
                        //       doctorValue = val.toString();
                        //     });
                        //   },
                        // ),
                        SizedBox(
                          height: 8,
                        ),
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            isLoadingDoctorAndServices
                                ? LOADING
                                : SELECT_SERVICES,
                          ),
                          icon: Image.asset(
                            "assets/bookappointment/down-arrow.png",
                            height: 15,
                            width: 15,
                          ),
                          value: serviceValue,
                          items: doctorsAndServices == null
                              ? []
                              : List.generate(
                                  doctorsAndServices.data.services.length,
                                  (index) {
                                  return DropdownMenuItem(
                                    value: doctorsAndServices
                                        .data.services[index].name + index.toString(),
                                    child: Text(doctorsAndServices
                                        .data.services[index].name),
                                    key: UniqueKey(),
                                    onTap: () {
                                      print("doctorsAndServices ${doctorsAndServices.data.services[index].id}");
                                      setState(() {
                                        serviceId = doctorsAndServices
                                            .data.services[index].id;
                                      });
                                    },
                                  );
                                }),
                          onChanged: (val) {
                            print(val);
                            setState(() {
                              serviceValue = val.toString();
                            });
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          PHONE_NUMBER,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              counterText: '',
                              isCollapsed: true),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LIGHT_GREY_TEXT),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text('Age',style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                        SizedBox(height: 10,),
                        TextField(
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          maxLength:3,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              counterText: '',
                              isCollapsed: true),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: LIGHT_GREY_TEXT),
                        ),
                        SizedBox(height: 15,),
                        Text(
                          DATE,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        InkWell(
                          onTap: () {
                             _selectDate(context,currentDay);

                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                selectedFormattedDate.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: LIGHT_GREY_TEXT),
                              ),
                              Divider(
                                color: LIGHT_GREY_TEXT,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Time Of Appointment :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        isLoad ==true?
                        Center(child: CircularProgressIndicator()):Container(
                          height: 60,
                          child:  getTimeSlotModel.data!=null||getTimeSlotModel.data!=""? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(),
                              itemCount:getTimeSlotModel.availableDays.length,
                              // scrollDirection: Axis.vertical,
                              itemBuilder: (context, index){
                                status_Index = getTimeSlotModel.availableDays[index].status.toString();

                                currentDay = getTimeSlotModel.availableDays[index].day;




                                return getTimeSlotModel.availableDays[index].status=='0'?Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){
                                      // print('my choosing Index is here${getTimeSlotModel.availableDays[index].day}');


                                      setState(() {

                                        selectedDay =  getTimeSlotModel.availableDays[index].day.toString() ;

                                        //
                                        // for(int i=0; i<getTimeSlotModel.availableDays.length; i++){
                                        //
                                        // }

                                      });
                                    },
                                    child:  Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.red),
                                          borderRadius: BorderRadius.circular(10),
                                           color: selectedDay.toString().toUpperCase() == currentDay.toString().toUpperCase()? LIME : Colors.white
                                         // color: isTapped == true ? LIME : Colors.white
                                      ),
                                      height: 50,
                                      width: 120,
                                      child: Center(child: Text("${getTimeSlotModel.availableDays[index].day} - ${getTimeSlotModel.availableDays[index].from}-${getTimeSlotModel.availableDays[index].to}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,fontSize:11,
                                            color:selectedDay.toString().toUpperCase() == getTimeSlotModel.availableDays[index].day?Colors.white : LIME
                                        ),)),
                                    ),
                                  ),
                                ):SizedBox.shrink();
                              }
                          ):Center(child: Text('Data Not Found')),
                        ),
                        Text(
                         TIME,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Container(
                    height: 60,
                    child: isLoad==false?ListView.builder(
                           shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: ScrollPhysics(),
                           itemCount:getTimeSlotModel.data.length,
                          // scrollDirection: Axis.vertical,
                           itemBuilder: (context, index){
                             return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: InkWell(
                                 onTap: (){
                                   setState(() {
                                     current_index = getTimeSlotModel.data[index].startTime.toString();

                                   });
                                 },
                                    child:  Container(
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(10),
                                     color: getTimeSlotModel.data[index].isEnabled == true ?current_index == getTimeSlotModel.data[index].startTime.toString() ? LIME :Colors.white:Colors.grey
                                   ),
                                   height: 50,
                                   width:60,
                                   child: Center(child: Text("${getTimeSlotModel.data[index].startTime}",
                                   style: TextStyle(
                                     fontWeight: FontWeight.w600,fontSize:11,
                                     color: getTimeSlotModel.data[index].isEnabled == true ? current_index == getTimeSlotModel.data[index].startTime.toString() ?Colors.white : LIME:Colors.white
                                   ),)),
                                 ),
                               ),
                             );
                            }
                    ):Center(child: CircularProgressIndicator())
                  ),
    // InkWell(
                        //   onTap: () {
                        //     timeSlot(context);
                        //   // _selectTime( context);
                        //   },
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       SizedBox(
                        //         height: 5,
                        //       ),
                        //       Text(
                        //         _time,
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w500,
                        //             color: LIGHT_GREY_TEXT),
                        //       ),
                        //       Divider(
                        //         color: LIGHT_GREY_TEXT,
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        // Text(data[index].date.toString().substring(8)+"-"+data[index].date.toString().substring(5,7)+"-"+data[index].date.toString().substring(0,4),
                        //   style: GoogleFonts.poppins(
                        //       color: LIGHT_GREY_TEXT,
                        //       fontSize: 11,
                        //       fontWeight: FontWeight.w400
                        //   ),
                        // ),
                        // Text(widget.slot,
                        //   style: GoogleFonts.poppins(
                        //       color: BLACK,
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.w500
                        //
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          COMPLAINS,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        TextField(
                          controller: msgCtr,
                          maxLines: 3,
                          minLines: 1,
                          style:
                              TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: LIGHT_GREY_TEXT, width: 0.5),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: LIGHT_GREY_TEXT, width: 0.5),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: LIGHT_GREY_TEXT, width: 0.5),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              message = val;
                            });
                          },
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            showExitPopup();
                          },
                          child: Container(
                            height: 45,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width/2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: LIME,
                            ),
                            child: Text(
                              "Upload Report",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700,color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        imageFile == null ? SizedBox.shrink() :  InkWell(
                          onTap: (){
                            showExitPopup();
                          },
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: Image.file(imageFile,fit: BoxFit.fill,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomButtons(status_Index),
            ],
          );
  }

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
          title: Text('Select Image'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _getFromCamera();
                },
                //return false when click on "NO"
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Image from Camera'),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              ElevatedButton(
                onPressed: (){
                  _getFromGallery();
                  // Navigator.pop(context,true);
                  // Navigator.pop(context,true);
                },
                //return true when click on "Yes"
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.photo,color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Image from Gallery'),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
        // ??false; //if showDialouge had returned null, then return false
  }

  bottomButtons(status_Index) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if(firstNmaeCtr.text.isEmpty && lastNameCtr.text.isEmpty && phoneController.text.isEmpty && ageController.text.isEmpty){
                  Fluttertoast.showToast(msg: ALL_FIELDSREQUIRDE);
                }
                bookAppointment();
                // openCheckout(bookingPrice);
                // print("priceeee herrerer ${bookingPrice}");
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(12, 5, 12, 15),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: LIME,
                ),
                child: Center(
                  child: Text(
                    ADD_APPOINTMENT,
                    style: TextStyle(color: WHITE, fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // int selectedDay;
  Future<Null> _selectDate(BuildContext context,current_Index1) async {

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        currentDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days:7),),

    );

    if (picked != null)

      setState(() {
        selectedDate = picked;
        myDay = DateFormat('EEE').format(selectedDate);
        selectedDay = DateFormat('EEE').format(selectedDate);


        print(selectedDate.toString().substring(0, 10));

        selectedFormattedDate = selectedDate.day.toString() +
            " " +
            monthsList[selectedDate.month] +
            ", " +
            selectedDate.year.toString();
      });
    getTimeSlote();
  }

  timeSlot(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
        Wrap(
          direction: Axis.horizontal,
          children: getTimeSlotModel.data.map((i) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                    color: LIME
              ),
              child: Center(child: Text("${i.startTime}")),
            ),
          )).toList(),
        ),
          content: SizedBox.shrink(),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }


  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
      initialTime: selectedTime,
    );

    selectedTime = picked;
    print(DateTime.now().minute);
    print(selectedTime.minute);
    print(DateTime.now().minute > selectedTime.minute);
    print(DateTime.now().hour >= selectedTime.hour);
    print(DateTime.now().day == selectedDate.day);

    if (picked != null) if ((DateTime.now().minute >= selectedTime.minute &&
        DateTime.now().hour >= selectedTime.hour &&
        DateTime.now().day == selectedDate.day)) {
      print("-> Condition true");
      messageDialog('Alert', 'Select a future time');
    } else {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour < 10
            ? "0" + selectedTime.hour.toString()
            : selectedTime.hour.toString();
        _minute = selectedTime.minute < 10
            ? "0" + selectedTime.minute.toString()
            : selectedTime.minute.toString();
        current_index = _hour + ":" + _minute;

        print(" this is a current+++++++++++>${selectedDate.day}");
      });
    }
  }

  // button() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: InkWell(
  //           onTap: () {
  //             if (selectedTile == null) {
  //               // errorDialog(PLEASE_SELECT_A_SUBSCRIPTION_PLAN);
  //               return;
  //             }
  //             if (isLoggedIn) {
  //               setState(() {
  //                 date = (DateTime.now().day < 10
  //                     ? "0" + DateTime.now().day.toString()
  //                     : DateTime.now().day.toString()) +
  //                     "-" +
  //                     (DateTime.now().month < 10
  //                         ? "0" + DateTime.now().month.toString()
  //                         : DateTime.now().month.toString()) +
  //                     "-" +
  //                     DateTime.now().year.toString();
  //                 _time = (DateTime.now().hour < 12
  //                     ? (DateTime.now().hour < 10
  //                     ? "0" + DateTime.now().hour.toString()
  //                     : DateTime.now().hour.toString())
  //                     : (DateTime.now().hour - 12 < 10
  //                     ? "0" + (DateTime.now().hour - 12).toString()
  //                     : (DateTime.now().hour - 12).toString())) +
  //                     ":" +
  //                     (DateTime.now().minute < 10
  //                         ? "0" + DateTime.now().minute.toString()
  //                         : DateTime.now().minute.toString()) +
  //                     " " +
  //                     (DateTime.now().hour < 12 ? "Am" : "Pm");
  //                 paymentType = "2";
  //               });
  //               //openCheckout();
  //
  //
  //             } else {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => LoginScreen(),
  //                   ));
  //             }
  //           },
  //           child: Container(
  //             margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
  //             height: 50,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(25),
  //               color: LIME,
  //             ),
  //             child: Center(
  //               child: Text(
  //                 isLoggedIn ? ADD_SUBSCRIPTION : LOGIN_TO_ADD_SUBSCRIPTION,
  //                 style: TextStyle(color: WHITE,fontWeight: FontWeight.w700, fontSize: 17),
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  getDepartmentsList() async {
    print('Getting departments');

    final response = await get(Uri.parse("$SERVER_ADDRESS/api/getdepartment"));

    print(response.request);

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      setState(() {
        departmentsList = DepartmentsList.fromJson(jsonResponse);
      });
    }
  }
  fetchDoctorsAndServices(int id) async {
    print('_____sdsfsdfsd_____${id}_________');
    setState(() {
      doctorValue = null;
      serviceValue = null;
      isLoadingDoctorAndServices = true;
      print(doctorValue.toString());
      doctorsAndServices = null;
    });
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/getdoctorandservicebydeptid?department_id=$id"));
    final jsonResponse = jsonDecode(response.body);
    print('_____sdsfsdfsd_____${id}_________');

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      setState(() {
        doctorsAndServices = DoctorsAndServices.fromJson(jsonResponse);
        isLoadingDoctorAndServices = false;
      });
    }
  }


  BookAppoinmentModel bookAppoinmentModel;
  String bookingPrice;

  bookAppointment() async {
    print("booking appoinment apiiiiii");
    if (departmentId == null ||
        serviceId == null ||
        current_index == "Select Time" || ageController.text.isEmpty) {
      print("checking all fields here ${departmentId} and ${serviceId} and ${doctorId} and ${current_index}");
      messageDialog("Error", ENTER_FIELDS_TO_MAKE_APPOINTMENT);
    }
    else {
      dialog();

      print("department_id:" +
          departmentId.toString() + "\n" + "service_id:" +
          serviceId.toString() + "\n" + "doctor_id:" + "4" + "\n"
          + "name:" + firstNmaeCtr.text + "\n" + "last_name:" + lastNameCtr.text + "\n" + "phone_no:" + phoneController.text + "\n" +
          "date:" +
          selectedDate.toString().substring(0, 10) +
          "\n" +
          "time:" +
          current_index +
          "\n" +
          "user_id:" +
          userId.toString() +
          "\n" +
          "messages:" +
          message +
          "\n"
      );

      // addServices()async{
      //   var headers = {
      //     'Cookie': 'ci_session=bcf2871e64e7fec397eaa77e3b6fa2b916b3eade'
      //   };
      //   var request = http.MultipartRequest('POST', Uri.parse('https://completewomencares.com/api/bookappointment'));
      //   request.fields.addAll({
      //     "department_id": departmentId.toString(),
      //     "service_id": serviceId.toString(),
      //     "doctor_id": doctorId.toString(),
      //     "name": nameController.text,
      //     "phone_no": phoneController.text,
      //     "date": selectedDate.toString().substring(0, 10),
      //     "time": current_index,
      //     "user_id": userId.toString(),
      //     "messages": message,
      //     "image" : imageFile.path.toString()
      //     // 'other_images[]': '${uploadImages.toString()}'
      //   });
      //   // if(type == "7"){
      //   //   request.fields.addAll({
      //   //     'per_day_charge' : '${perDayController.text}',
      //   //   });
      //   // }
      //
      //   imageFile == null
      //       ? null
      //       : request.files.add(await http.MultipartFile.fromPath(
      //       'other_images[]', imageFile.path[0].toString()));
      //
      //   request.files.add(await http.MultipartFile.fromPath(
      //       'services_image', '${imageFile.path[0].toString()}'));
      //   print("checking request of api here ${request.fields} aand ${request.files.toString()}");
      //
      //   request.headers.addAll(headers);
      //   http.StreamedResponse response = await request.send();
      //   if (response.statusCode == 200) {
      //     var finalResponse = await response.stream.bytesToString();
      //     final jsonResponse = json.decode(finalResponse);
      //     print("checking result ${jsonResponse}");
      //     if(jsonResponse['status'] == "success") {
      //       setState(() {
      //         // Fluttertoast.showToast(msg: "Added successfully");
      //       });
      //       Navigator.pop(context, true);
      //     }
      //   }
      //   else {
      //     print(response.reasonPhrase);
      //   }
      // }
      var request = http.MultipartRequest('POST', Uri.parse('${SERVER_ADDRESS}/api/bookappointment'));
      request.fields.addAll({
        "department_id": departmentId.toString(),
        "service_id": serviceId.toString(),
        "doctor_id": "1",
        "name": firstNmaeCtr.text,
        'last_name': lastNameCtr.text,
        "phone_no": phoneController.text,
        "date": selectedDate.toString().substring(0, 10),
        "time": current_index,
        "user_id": userId.toString(),
        "messages": msgCtr.text,
        "age":ageController.text,
         // "image" : imageFile.path.toString()
      });
          print("checking here params here ${request.fields}");
      if (imageFile != null ) {
        request.files.add(await http.MultipartFile.fromPath(
            'image', imageFile.path.toString()));
        print(" this is a  magesssssssssss=>${request.files}");
      }      print(" this is a  magesssssssssss=>${request.files}");
      http.StreamedResponse response = await request.send();
        print("checking here now one here ${response.statusCode}");
      if (response.statusCode == 200) {
        setState(() {
        });
        // var snackBar = SnackBar(
        //   content: Text('Booking Done'),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   Fluttertoast.showToast(msg: "Appointment done");
        var finalResult = await response.stream.bytesToString();
        final jsonResponse = BookAppoinmentModel.fromJson(json.decode(finalResult));
        bookingPrice = jsonResponse.data.price;
        print("Bookinggggg Priceeeeee ${bookingPrice}");
        print("final respnse here ${jsonResponse}");
        openCheckout(bookingPrice);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => TabBarScreen()));
      }
      else {
        Navigator.pop(context);
        setSnackbar("Error", context);
      }
      //
      // final response =
      //     await post(Uri.parse("$SERVER_ADDRESS/api/bookappointment"), body: {
      //   "department_id": departmentId.toString(),
      //   "service_id": serviceId.toString(),
      //   "doctor_id": doctorId.toString(),
      //   "name": nameController.text,
      //   "phone_no": phoneController.text,
      //   "date": selectedDate.toString().substring(0, 10),
      //   "time": current_index,
      //   "user_id": userId.toString(),
      //   "messages": message,
      //       "image":imageFile.path.toString(),
      //
      // });
      // //imageFile == null  ? null:  response..add(await http.MultipartFile.fromPath('image', imageFile.path.toString()));
      // // imageFile == null  ? null : response.files.add(await http.MultipartFile.fromPath('img', imageFile.path.toString()));
      // print("this is a respones====>${response}");
      //
      // final jsonResponse = jsonDecode(response.body);
      //
      // print("this a all Responce========>${jsonResponse}");
      // if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      //   print("Success");
      //
      // } else {
      //   Navigator.pop(context);
      //   messageDialog("Error", jsonResponse['msg']);
      // }
     }
  }


  var currentindex = 1;
  var datee;
  var lastDAte;
  var datepick;
  var pick;
  DateTime startDate;

  DateTime endDate;

  List<DateTime> selectedDates = [];

  Future<void> selectStartDate(BuildContext context) async {
    //lastDAte= DateTime.now().add(Duration(days:5));
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      //lastDate:pick.add(Duration(days: 8)),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        //var lastDAte= picked.add(Duration(days:3));
        pick = picked;
        // print(lastDAte);
        lastDAte = (pick.add(Duration(days: 5)));
      });
      print(lastDAte);
    }
  }

  dialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              PROCESSING,
            ),
            content: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      PLEASE_WAIT_WHILE_MAKING_APPOINTMENT,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        barrierDismissible: false,
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
                  if (isAppointmentMadeSuccessfully) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabBarScreen(),
                        ));
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(backgroundColor: LIME),
                child: Text(
                  OK,
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
}
