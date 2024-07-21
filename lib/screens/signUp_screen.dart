import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/login/login.dart';
import 'package:flutter_application_1/authentication/signup/utils.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpScreenPage extends StatefulWidget {
  const SignUpScreenPage({Key? key}) : super(key: key);

  @override
  State<SignUpScreenPage> createState() => _SignUpScreenPageState();
}

class _SignUpScreenPageState extends State<SignUpScreenPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _controllerOne = ScrollController();
  Uint8List? _image;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF1A1A), Color(0xFFFF1A1A)],
            ),
          ),
          child: Column(
            children: [
              const SignUpText(),
              const SizedBox(height: 20),
              ProfileImage(image: _image, onImageSelected: selectImage),
              const SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  controller: _controllerOne,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _controllerOne,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: signUpForm(
                        formKey: _formKey,
                        controllerOne: _controllerOne,
                        image: _image,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Sign Up",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 36,
        fontFamily: 'KohSantepheap',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final Uint8List? image;
  final VoidCallback onImageSelected;

  const ProfileImage({
    Key? key,
    required this.image,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        image != null
            ? CircleAvatar(
                radius: 64,
                backgroundImage: MemoryImage(image!),
              )
            : const CircleAvatar(
                radius: 70,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('assets/images/signuUP_profile.png'),
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: onImageSelected,
            icon: const Icon(Icons.add_a_photo),
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class signUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ScrollController controllerOne;
  final Uint8List? image;

  const signUpForm({
    Key? key,
    required this.formKey,
    required this.controllerOne,
    required this.image,
  }) : super(key: key);

  @override
  _signUpFormState createState() => _signUpFormState();
}

class _signUpFormState extends State<signUpForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  String? _selectedUserType;
  String? _selectedBloodType;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void registerUser() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      final ap = Provider.of<AuthProvider>(context, listen: false);

      UserModel userModel = UserModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        gender: _selectedGender ?? "",
        bloodType: _selectedBloodType ?? "",
        userType: _selectedUserType ?? "",
        profileImage: "", 
        uid: "",
        email: _emailController.text.trim(),
      );

      if (widget.image != null) {
        try {
          String? errorMessage = await ap.signUpWithEmailAndPassword(
            context,
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          if (errorMessage == null) {
            userModel.uid = ap.uid;

            // Get image URL from Firebase Storage
            String imageUrl = await ap.storeFileToStorage(
              "profileImages/${ap.uid}.jpg",
              widget.image!,
              context,
            );

            if (imageUrl.isNotEmpty) {
              String? saveUserDataError = await ap.saveUserDataToFirebase(
                context: context,
                userModel: userModel,
                profileImageUrl: imageUrl,
              );

              if (saveUserDataError == null) {
                await ap.saveUserDataToSP();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("Failed to save user data: $saveUserDataError")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to upload profile image")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Sign up failed: $errorMessage")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign up failed: $e")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a profile image")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          textFeld(
            hintText: "First Name",
            inputType: TextInputType.name,
            maxLines: 1,
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter First Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          textFeld(
            hintText: "Last Name",
            inputType: TextInputType.name,
            maxLines: 1,
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Last Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          textFeld(
            hintText: "Email",
            inputType: TextInputType.emailAddress,
            maxLines: 1,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          textFeld(
            hintText: "Contact Number",
            inputType: TextInputType.phone,
            maxLines: 1,
            controller: _contactNumberController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Contact Number';
              }
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Please enter a valid contact number';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedGender,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              decoration: const InputDecoration(
                hintText: 'Gender',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide.none,
                ),
                errorStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a gender' : null,
              items: <String>['Male', 'Female']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedUserType,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              decoration: const InputDecoration(
                hintText: 'Account Type',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide.none,
                ),
                errorStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUserType = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a user type' : null,
              items: <String>['Donor', 'Blood Camp Organizer']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedBloodType,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              decoration: const InputDecoration(
                hintText: 'Blood Type',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  borderSide: BorderSide.none,
                ),
                errorStyle: TextStyle(color: Colors.black),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a blood type' : null,
              items: <String>['A', 'A+', 'A-', 'B', 'B+', 'B-', 'O', 'O+', 'O-']
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          textFeld(
            hintText: "Password",
            inputType: TextInputType.visiblePassword,
            maxLines: 1,
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          textFeld(
            hintText: "ReType Password",
            inputType: TextInputType.visiblePassword,
            maxLines: 1,
            controller: _confirmPasswordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please retype your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: registerUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(200, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'MontserratBold',
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'I Already Have an Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'KohSantepheap',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(170, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget textFeld({
  required String hintText,
  required TextInputType inputType,
  required int maxLines,
  required TextEditingController controller,
  bool obscureText = false,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: TextFormField(
      cursorColor: Colors.white,
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        errorStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    ),
  );
}
