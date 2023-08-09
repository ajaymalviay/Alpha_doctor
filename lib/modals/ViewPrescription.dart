import 'package:flutter/material.dart';

class ViewPrrescription extends StatefulWidget {
  const ViewPrrescription({Key key}) : super(key: key);

  @override
  State<ViewPrrescription> createState() => _ViewPrrescriptionState();
}

class _ViewPrrescriptionState extends State<ViewPrrescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("View Your Prescription", style: TextStyle(fontSize: 15),),
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
}
