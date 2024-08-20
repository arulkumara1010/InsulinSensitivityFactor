import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login UI',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Unfocus the text fields
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/1053265.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.9),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hello',
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
                  // Set adaptive width for the TextField
                  SizedBox(
                    width: screenWidth * 0.86, // 80% of screen width
                    child: TextField(
                      cursorColor: Colors.white,
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
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
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
                  SizedBox(
                    width: screenWidth *
                        0.86, // Same width for the password TextField
                    child: TextField(
                      cursorColor: Colors.white,
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
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
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
                  const SizedBox(height: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 48.0, // Match the TextField height
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
                  SizedBox(
                    width:
                        screenWidth * 0.5, // Set adaptive width for the button
                    height: 50.0, // Set the desired height
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent, // Background color
                        elevation: 8.0, // Button shadow elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 10.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
