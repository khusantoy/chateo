import 'dart:io';

import 'package:chateo/controllers/auth_controller.dart';
import 'package:chateo/controllers/users_controller.dart';
import 'package:chateo/utils/messages.dart';
import 'package:chateo/views/widgets/textformfield_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  File? imageFile;

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      Navigator.pop(context);
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      Navigator.pop(context);
    }
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      Messages.showLoadingDialog(context);
      await _authController
          .register(
        emailAddress: emailController.text,
        password: passwordController.text,
      )
          .then((user) {
        addUser();
        Navigator.pop(context);
      });
    }
  }

  void addUser() async {
    Messages.showLoadingDialog(context);
    await context.read<UsersController>().addUser(
        usernameController.text, emailController.text, "online", imageFile!);

    if (context.mounted) {
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            shape: BoxShape.circle,
                          ),
                          child: imageFile == null
                              ? const Icon(
                                  Icons.person,
                                  size: 50,
                                )
                              : Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(24.0),
                                      height: 250,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: openCamera,
                                                child: const SizedBox(
                                                  width: 150,
                                                  height: 100,
                                                  child: Card(
                                                    color: Color(0xFFF7F7FC),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.camera),
                                                        Text("Camera")
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: openGallery,
                                                child: const SizedBox(
                                                  width: 150,
                                                  height: 100,
                                                  child: Card(
                                                    color: Color(0xFFF7F7FC),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.photo),
                                                        Text("Gallery")
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          SizedBox(
                                            height: 52,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor:
                                                      Colors.white),
                                              child: const Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.edit,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextformfieldItem(
                  labelText: "Username",
                  textEditingController: usernameController,
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your username";
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextformfieldItem(
                  labelText: "Email",
                  textEditingController: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your email";
                    } else {
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return "Email is wrong";
                      }
                    }

                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextformfieldItem(
                  labelText: "Password",
                  textEditingController: passwordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your password";
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextformfieldItem(
                  labelText: "Confirm Password",
                  textEditingController: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Enter your password";
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _validateAndSubmit,
                    child: const Text("Register"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("If you already heave an account"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
