// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'setup.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user's details from Firestore
  Future<Map<String, dynamic>?> getUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Retrieve user data from Firestore using the user's UID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print("User data does not exist in Firestore.");
        return null;
      }
    }
    return null;
  }
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isloggedin = false;
  User? user1 = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "SignIn");
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser as User;
        isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentification();
    getUser();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? data = await _userService.getUserDetails();
    setState(() {
      userData = data;
      isLoading = false; // Data loaded, stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: MediaQuery.of(context).size.width / 2 - 170,
          child: SizedBox(
            width: 340,
            height: 45,
            child: Row(
              children: [
                if (isLoading)
                  const CircularProgressIndicator() // Show loading indicator while data is being fetched
                else if (userData != null && userData!['name'] != null)
                  Text(
                    "Hello ${userData!['name']}!",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                else
                  Text(
                    "Hello!",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    // Handle bell icon press
                  },
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      userData != null && userData!['initial'] != null
                          ? userData!['initial']
                          : '',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                /* IconButton(
                  icon: const Icon(Icons.person, color: Colors.black, size: 30,),
                  onPressed: () {
                    //Navigator.pushNamed(context, "ProfilePage");
                  },
                ), */
              ],
            ),
          ),
        ),
        Positioned(
          top: 250,
          left: MediaQuery.of(context).size.width / 2 -
              100, // Center horizontally
          child: SizedBox(
            width: 200,
            height: MediaQuery.of(context).size.height * 0.27,
            child: Center(
              child: Text(
                'Start your insulin journey with us...',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (userData != null &&
                  userData!['height'] != null &&
                  userData!['weight'] != null) {
                // If height and weight are already entered, go to SetupPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetupPage()),
                );
              } else {
                // Otherwise, go to Homepage2 to input data
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage2()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent, // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Container(
              width: 248,
              height: 49, // Set the width to 248 px
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align the text at the center
                children: [
                  Text(
                    "C H A N G E   Y O U R  ",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "L I F E !",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.85,
          left:
              MediaQuery.of(context).size.width / 2 - 50, // Center horizontally
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              "Log Out",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Let us help you in making your life easier...',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ]),
    );
  }
}

class Homepage2 extends StatefulWidget {
  const Homepage2({super.key});

  @override
  _Homepage2State createState() => _Homepage2State();
}

class _Homepage2State extends State<Homepage2> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController longactinginsulinController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User user;
  bool isloggedin = false;
  User? user1 = FirebaseAuth.instance.currentUser;
  final UserService _userService = UserService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, "SignIn");
      }
    });
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.86,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black, size: 18.0),
          labelText: labelText,
          labelStyle: GoogleFonts.inter(color: Colors.black),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, width: 1.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser as User;
        isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentification();
    getUser();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic>? data = await _userService.getUserDetails();
    setState(() {
      userData = data;
      isLoading = false; // Data loaded, stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
          width: 338,
          height: 45,
          margin: const EdgeInsets.only(top: 40, left: 15),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Start your insulin journey",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          )),
      Positioned(
        top: 200,
        left: 50, // Center horizontally
        child: SizedBox(
          width: 270,
          height: 25,
          child: Text(
            'Help Us Get to Know You!',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height *
            0.26, // Adjust the top position as needed
        left: MediaQuery.of(context).size.width *
            0.07, // Adjust the left position as needed
        right: MediaQuery.of(context).size.width *
            0.07, // Adjust the right position as needed
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              _buildTextField(
                  weightController, 'Weight (in kg)', Icons.monitor_weight,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16.0),
              _buildTextField(heightController, 'Height (in cm)', Icons.height,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16.0),
              _buildTextField(longactinginsulinController,
                  'Long-Acting Insulin (in units)', Icons.medication,
                  keyboardType: TextInputType.number),
            ],
          ),
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height *
            0.90, // Adjust the top position as needed
        left: MediaQuery.of(context).size.width *
            0.07, // Adjust the left position as needed
        right: MediaQuery.of(context).size.width *
            0.07, // Adjust the right position as needed
        child: ElevatedButton(
          onPressed: () {
            // Handle continue button press
            heightweightUser();
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
    ]));
  }

  void heightweightUser() async {
    String weight = weightController.text.trim();
    String height = heightController.text.trim();
    String longActingInsulinText = longactinginsulinController.text.trim();

    // Validate the input
    if (weight.isEmpty || height.isEmpty || longActingInsulinText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Try parsing long-acting insulin as an integer
    int? longactinginsulin = int.tryParse(longActingInsulinText);
    if (longactinginsulin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number for long-acting insulin'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'height': height,
        'weight': weight,
        'longactinginsulin': longactinginsulin,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Height and Weight entered successfully'),
          backgroundColor: Colors.greenAccent,
        ),
      );

      // Navigate to the setup page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetupPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
