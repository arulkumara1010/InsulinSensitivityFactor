import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'homepageaftersetup.dart';


class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int dayCount = 1;
  List<bool> mealCompleted = [false, false, false]; // Track meal completion

  @override
  void initState() {
    super.initState();
    _loadSetupData();
  }

  Future<void> _loadSetupData() async {
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        // Load data from Firestore
        dayCount = userDoc['dayCount'] ?? 1;
        mealCompleted =
            List<bool>.from(userDoc['mealCompleted'] ?? [false, false, false]);
      });
    } else {
      // If user document doesn't exist, initialize it
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'dayCount': 1,
        'mealCompleted': [false, false, false],
        'completedSetup': false,
      });
    }
  }

  Future<void> _saveSetupData() async {
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'dayCount': dayCount,
      'mealCompleted': mealCompleted,
    });
  }

  Future<void> _updateCompletedSetup() async {
    final userId =
        FirebaseAuth.instance.currentUser!.uid; // Get current user ID
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'completedSetup': true, // Set completedSetup to true
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.86,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Complete your setup!',
                  style: GoogleFonts.inter(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.86,
              child: Align(
                alignment: Alignment.topLeft,
                child: RichText(
                  text: TextSpan(
                    text: 'Day ',
                    style: GoogleFonts.inter(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                    ),
                    children: [
                      TextSpan(
                        text: '$dayCount',
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' of 3',
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: screenWidth * 0.86,
              child: _buildSegmentedProgressBar(),
            ),
            const SizedBox(height: 32.0),
            _buildButtons(screenWidth),
            const SizedBox(height: 16.0),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (index) {
        bool isCompleted = index < dayCount;

        BorderRadius borderRadius;
        if (index == 0) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
          );
        } else if (index == 2) {
          borderRadius = const BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          );
        } else {
          borderRadius = BorderRadius.zero;
        }

        return Container(
          width: 0.84 * MediaQuery.of(context).size.width / 3,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          decoration: BoxDecoration(
            color: isCompleted ? Colors.greenAccent : Colors.grey[300],
            borderRadius: borderRadius,
          ),
        );
      }),
    );
  }

  Widget _buildButtons(double screenWidth) {
    return Column(
      children: [
        _buildButton(screenWidth, 'Breakfast', 0),
        const SizedBox(height: 16.0),
        _buildButton(screenWidth, 'Lunch', 1),
        const SizedBox(height: 16.0),
        _buildButton(screenWidth, 'Dinner', 2),
      ],
    );
  }

  Widget _buildButton(double screenWidth, String title, int index) {
    bool isCompleted = mealCompleted[index];

    return SizedBox(
      width: screenWidth * 0.86,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.greenAccent : Colors.white,
          side: BorderSide(
              width: 2.0,
              color: isCompleted ? Colors.transparent : Colors.greenAccent),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        ),
        onPressed: () {
          setState(() {
            mealCompleted[index] = true; // Mark meal as completed
          });
          _saveSetupData(); // Save the state
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                color: isCompleted ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
            if (!isCompleted)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 16.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    bool allMealsCompleted = mealCompleted.every((completed) => completed);

    return allMealsCompleted
        ? Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 120.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  side: const BorderSide(width: 1.0, color: Colors.black),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                ),
                onPressed: () async {
                  setState(() {
                    if (dayCount < 3) {
                      dayCount++;
                      mealCompleted = [
                        false,
                        false,
                        false
                      ]; // Reset meal completion
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Setup Complete'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Update completedSetup status in Firestore
                      _updateCompletedSetup();

                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      });
                    }
                  });
                  _saveSetupData(); // Save the state
                },
                child: Text(
                  dayCount < 3 ? 'NEXT' : 'SUBMIT',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
