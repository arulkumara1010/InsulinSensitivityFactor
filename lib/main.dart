import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insulin_sensitivity_factor/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss the keyboard when tapping outside
        },
        child: Stack(
          children: [
            // Background image covering the entire screen height
            SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/1053265.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Dark overlay to enhance contrast
            Container(
              height: screenHeight,
              width: screenWidth,
              color: Colors.black.withOpacity(0.9),
            ),
            // Scrollable content (if necessary) with fixed background
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: screenHeight, // Ensure it takes the full height of the screen
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hello ',
                              style: GoogleFonts.inter(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'User!',
                              style: GoogleFonts.inter(
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48.0),
                      // Email input field
                      SizedBox(
                        width: screenWidth * 0.86,
                        child: TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.white70,
                              size: 18.0,
                            ),
                            labelText: 'Email',
                            labelStyle: GoogleFonts.inter(color: Colors.white70),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                            ),
                            filled: true,
                            fillColor: Colors.black26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Password input field
                      SizedBox(
                        width: screenWidth * 0.86,
                        child: TextField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.white70,
                              size: 18.0,
                            ),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.inter(color: Colors.white70),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.greenAccent, width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                            ),
                            filled: true,
                            fillColor: Colors.black26,
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Remember me and forgot password row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 48.0,
                                alignment: Alignment.centerLeft,
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.greenAccent,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Remember me?',
                                style: GoogleFonts.inter(color: Colors.white70),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.inter(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      // Login button
                      SizedBox(
                        width: screenWidth * 0.5,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                            ),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            await login();
                          },
                          child: Text(
                            'LOGIN',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              letterSpacing: 10.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Error message (if any)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const Spacer(), // Pushes the following to the bottom
                      // "Don't have an account? Register" row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              // Handle registration action
                            },
                            child: Text(
                              'Register',
                              style: GoogleFonts.inter(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show a SnackBar if email or password is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return; // Stop execution if fields are empty
    }

    try {
      // Attempt to sign in the user
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // On successful login, show SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.greenAccent,
          duration: Duration(seconds: 2),
        ),
      );

      // Perform further actions like navigation here
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid credentials'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

}
