import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealSetupPage extends StatefulWidget {
  final String mealName;

  const MealSetupPage({super.key, required this.mealName});

  @override
  // ignore: library_private_types_in_public_api
  _MealSetupPageState createState() => _MealSetupPageState();
}

class _MealSetupPageState extends State<MealSetupPage> {
  final TextEditingController insulinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '${widget.mealName} Setup',
          style: GoogleFonts.inter(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), // Back icon color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: insulinController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter insulin for ${widget.mealName}',
                labelStyle: GoogleFonts.inter(
                  fontSize: 18,
                  color: Colors.black45,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
              style: GoogleFonts.inter(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  if (insulinController.text.isEmpty) {
                    // Show a SnackBar if the field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter insulin data.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Proceed with saving if data is present
                    Navigator.pop(context, insulinController.text);
                  }
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.inter(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
