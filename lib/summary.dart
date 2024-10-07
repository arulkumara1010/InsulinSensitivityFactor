import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryPage extends StatefulWidget {
  final Map<String, Map<String, int>> itemCounts;

  const SummaryPage({required this.itemCounts, Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  Map<String, double> carbValues = {};
  double totalCarbs = 0;

  Future<void> fetchCarbValues() async {
    double total = 0;
    for (var category in widget.itemCounts.keys) {
      for (var food in widget.itemCounts[category]!.keys) {
        int count = widget.itemCounts[category]![food]!;
        if (count > 0) {
          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection('foodcarbs') // Ensure the collection name is correct
              .doc(food)
              .get();

          double carbs = (snapshot.get('carbs') as num).toDouble(); // Cast to double
          total += carbs * count;
          carbValues[food] = carbs;
        }
      }
    }
    setState(() {
      totalCarbs = total;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCarbValues(); // Fetch carb values when the page loads
  }

  void heightweightUser() {
    // Handle button press
    print("Continue button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Summary',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: carbValues.keys.length,
                        itemBuilder: (context, index) {
                          String food = carbValues.keys.elementAt(index);
                          int count = widget.itemCounts.entries
                              .firstWhere((element) => element.value.containsKey(food))
                              .value[food]!;
                          return ListTile(
                            title: Text(
                              '$food (x$count)',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              'Carbs: ${(carbValues[food]! * count).toStringAsFixed(2)}g',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                   Container(
  decoration: BoxDecoration(
    color: Colors.black, // Set the container color to green
    borderRadius: BorderRadius.circular(12), // Rounded corners
  ),
  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
  child: Text(
    'Total CARBS : ${totalCarbs.toStringAsFixed(2)}g',
    style: GoogleFonts.inter(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      color: Colors.white, // Change text color to white for contrast
    ),
  ),
),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
                child: ElevatedButton(
                  onPressed: () {
                    heightweightUser(); // Handle continue button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    "CONTINUE",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 5.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
