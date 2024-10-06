import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealSetupPage extends StatefulWidget {
  final String mealName;

  const MealSetupPage({super.key, required this.mealName});

  @override
  _MealSetupPageState createState() => _MealSetupPageState();
}

class _MealSetupPageState extends State<MealSetupPage> {
  final TextEditingController insulinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('${widget.mealName} Setup'),
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
                labelStyle: GoogleFonts.inter(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, insulinController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
