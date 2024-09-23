import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String selectedGender = 'Male'; // Default is 'choose'
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  bool _isPasswordVisible = false;
  DateTime? selectedDate;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
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
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.86,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.greenAccent),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Let\'s Get Started!',
                            style: GoogleFonts.inter(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _buildTextField(
                        nameController, 'Full Name', Icons.person_outline),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                        emailController, 'Email', Icons.email_outlined),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(
                        passwordController, 'Password', Icons.lock_outline),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                        phoneController, 'Phone Number', Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16.0),
                    _buildDateField(dobController, 'Date of Birth',
                        Icons.calendar_today_outlined),
                    const SizedBox(height: 16.0),
                    _buildDropdown(selectedGender, genderOptions, 'Gender',
                        (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    }),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      width: screenWidth * 0.5,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: _registerUser, // Call registration function
                        child: Text(
                          'REGISTER',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 5.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account? ",
                          style: GoogleFonts.inter(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign in',
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
          ],
        ),
      ),
    );
  }

  // Function to register the user and store data in Firestore and Firebase Auth
  void _registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();
    String dob = dobController.text.trim();
    String gender = selectedGender;

    // Basic validation (you can add more)
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty ||
        gender == 'choose') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      // Step 1: Create user in Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      // Step 2: Store additional user data in Firestore
      // Update displayName in Firebase Auth
      

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(user?.uid).set({
        'uid': user?.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob,
        'gender': gender,
      });

      await user?.updateDisplayName(name);
      // Update display name in Firebase Authentication
      await user?.updateProfile(displayName: name);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully'),
          backgroundColor: Colors.greenAccent,
        ),
      );

      // Navigate to the login page or clear the fields
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70, size: 18.0),
          labelText: labelText,
          labelStyle: GoogleFonts.inter(color: Colors.white70),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, width: 1.0),
          ),
          filled: true,
          fillColor: Colors.black26,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller, String labelText, IconData icon) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.86,
      child: TextField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70, size: 18.0),
          labelText: labelText,
          labelStyle: GoogleFonts.inter(color: Colors.white70),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, width: 1.0),
          ),
          filled: true,
          fillColor: Colors.black26,
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: Colors.white70,
                size: 18.0),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
      TextEditingController controller, String labelText, IconData icon) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                primaryColor: Colors.greenAccent,
                colorScheme:
                    const ColorScheme.dark(primary: Colors.greenAccent),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Colors.white,
                  selectionColor: Colors.greenAccent,
                  selectionHandleColor: Colors.greenAccent,
                ),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );

        setState(() {
          if (pickedDate != null) {
            controller.text = "${pickedDate.day.toString().padLeft(2, '0')}/"
                "${pickedDate.month.toString().padLeft(2, '0')}/"
                "${pickedDate.year}";
          }
        });
            },
      child: AbsorbPointer(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.86,
          child: TextField(
            controller: controller,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.white70, size: 18.0),
              labelText: labelText,
              labelStyle: GoogleFonts.inter(color: Colors.white70),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54, width: 1.0),
              ),
              filled: true,
              fillColor: Colors.black26,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String selectedValue, List<String> items,
      String labelText, ValueChanged<dynamic> onChanged) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.86,
      child: DropdownButtonFormField(
        value: selectedValue,
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.inter(color: Colors.white70),
          filled: true,
          fillColor: Colors.black26,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54, width: 1.0),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
          ),
        ),
        dropdownColor: Colors.black87,
        items: items.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: value == 'choose' ? Colors.white70 : Colors.white,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
