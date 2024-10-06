import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'setup.dart';
import 'history.dart';
import 'hom.dart';
import 'fooddetails.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
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

class _HomeScreenState extends State<HomeScreen> {
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

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser as User;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
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
          
          child: Container(
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
              
                Spacer(),
                IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  // Handle bell icon press
                },
                ),
                
                GestureDetector(
                  onTap: () {
                  // Navigate to the profile page
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfile()),
              );
              
                  Navigator.pushNamed(context, "ProfilePage");
                  },
                  child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
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
        Center(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
          SizedBox(height: 60.0), // Space for the welcome text
          
          SizedBox(height: 100.0), // Space before the button
          ElevatedButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FooddetailsPage()),
              );
              Navigator.pushNamed(context, "FoodDetailsPage");


              // Implement your onPressed logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'ENTER YOUR FOOD',
              style: GoogleFonts.inter(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 5, // Text color
              ),
            ),
          ),
          SizedBox(height: 150.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FoodHistoryPage()),
              );
              Navigator.pushNamed(context, "HistoryPage");
              // Implement your onPressed logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'HISTORY',
              style: GoogleFonts.inter(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 5, // Text color
              ),
            ),
          ),
          SizedBox(height: 150.0),
          
          SizedBox(height: 30.0),
          
           // Space before the list
          
              ],
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

class HistoryItem extends StatefulWidget {
  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0), // Space between items
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 161, 126, 167)),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
    );
  }
}

