import 'package:flutter/material.dart';

class Electricity extends StatefulWidget {
  const Electricity({super.key});

  @override
  State<Electricity> createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  TextEditingController tillnowunitConsume = TextEditingController();
  TextEditingController perunitprice = TextEditingController();
  TextEditingController previousmonthunit = TextEditingController();
  String calc = "";
  void calculation() {
    int tnuc = int.parse(tillnowunitConsume.text);
    int pup = int.parse(perunitprice.text);
    int pmu = int.parse(previousmonthunit.text);
    int total = tnuc - pmu;
    int priceTotal = total * pup;
    setState(() {
      calc = "$priceTotal";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(22, 27, 53, 62),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(102, 50, 209, 204),
        title: Text("Electricity bill"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tillnowunitConsume,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter current unit shown by meter",
                labelText: "Enter Current Unit",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: perunitprice,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the unit price ",
                labelText: "Per Unit Price",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: previousmonthunit,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter previous month unit",
                labelText: "Previous Month Unit",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculation,

              child: Text("CLick Here To Show  Bill"),
            ),

            Text("Final Rupees To Pay :$calc", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
