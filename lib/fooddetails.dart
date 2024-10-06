import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:insulin_sensitivity_factor/tab/b_tab.dart';
import 'package:insulin_sensitivity_factor/tab/dr_tab.dart';
import 'package:insulin_sensitivity_factor/tab/r_tab.dart';
import 'package:insulin_sensitivity_factor/tab/d_tab.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const FooddetailsPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FooddetailsPage extends StatefulWidget {
  const FooddetailsPage({super.key});

  @override
  State<FooddetailsPage> createState() => _FooddetailsPageState();
}

class MyTab extends StatelessWidget {
  final String imagePath;
  const MyTab({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 80,
      child: Container(
        child: Image.asset(imagePath),
      ),
    );
  }
}

class _FooddetailsPageState extends State<FooddetailsPage> {
  List<Widget> myTabs = const [
    MyTab(imagePath: 'assets/images/english-breakfast (1).png'),
    MyTab(imagePath: 'assets/images/sweets (1).png'),
    MyTab(imagePath: 'assets/images/rice-bowl (1).png'),
    MyTab(imagePath: 'assets/images/soda.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        
        body: Stack(
          children: [

            
            
            Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
            
            Column(
          
          children: [
            const SizedBox(height: 35),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
              child: Row(
                children:  [

                  Text(
                    'I want to ',
                    style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  Text(
                    ' EAT',
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TabBar(tabs: myTabs),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: [
                  BreakfastTab(),
                  DessertTab(),
                  RiceTab(),
                  DrinkTab(),
                ],
              ),
            ),
            // Add the NEXT button here if needed
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "NEXT",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
          ],
        )
      ),
    );
  }
}
