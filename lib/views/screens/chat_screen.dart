import 'dart:io';
import 'dart:math';

import 'package:chateo/controllers/chat_controller.dart';
import 'package:chateo/models/message.dart';
import 'package:chateo/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = ChatController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();

  bool isButtonEnabled = true;

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

  final loggedUserEmail =
      FirebaseAuth.instance.currentUser?.email ?? "default@example.com";

  //! StreamBuilder'siz ma'lumotlarni eshitib turish
  // void listenForMessages() {
  //   _chatFirebaseServices
  //       .streamMessagesFromChatWithParticipants(
  //           loggedUserEmail, widget.user.email)
  //       .listen((messages) {
  //     if (messages != null) {
  //       for (var message in messages) {
  //         print(message);
  //       }
  //     } else {
  //       print("Ikkala email mavjud bo'lgan chat topilmadi.");
  //     }
  //   });
  // }

  void sendMessage() async {
    if (_formKey.currentState!.validate()) {
      await _chatController.addMessage(
          loggedUserEmail, widget.user.email, _textController.text, "text");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              widget.user.imageUrl,
            ),
          ),
          title: Text(widget.user.username),
          subtitle: Text(widget.user.status),
        ),
      ),
      body: StreamBuilder(
        stream: _chatController.streamMessagesFromChatWithParticipants(
            loggedUserEmail, widget.user.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final messages = snapshot.data;

          return Column(mainAxisSize: MainAxisSize.min, children: [
            !snapshot.hasData || snapshot.data == null
                ? const Expanded(
                    child: Center(
                      child: Text("No messages here yet..."),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: messages!.length,
                      itemBuilder: (context, index) {
                        final message = Message.fromFirestore(messages[index]);

                        final formattedDate = DateFormat('yyyy-MM-dd - kk:mm')
                            .format(message.timestamp.toDate());

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment:
                                message.senderId == loggedUserEmail
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: message.senderId == loggedUserEmail
                                      ? Colors.blue.shade100
                                      : const Color(0xFFF7F7FC),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.text,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            Form(
              key: _formKey,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F7FC),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: const EdgeInsets.all(24.0),
                                height: min(280, 300),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Select a image from:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: openCamera,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 100,
                                            child: const Card(
                                              color: Color(0xFFF7F7FC),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            height: 100,
                                            child: const Card(
                                              color: Color(0xFFF7F7FC),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                            foregroundColor: Colors.white),
                                        child: const Text('Cancel'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(Icons.attach_file),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: "Message",
                          border: InputBorder.none,
                        ),
                        // onChanged: (value) {
                        //   if (value.trim().isNotEmpty) {
                        //     setState(() {
                        //       isButtonEnabled = true;
                        //     });
                        //   } else {
                        //     setState(() {
                        //       isButtonEnabled = false;
                        //     });
                        //   }
                        // },
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return "Enter a message";
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: isButtonEnabled ? sendMessage : null,
                      icon: const Icon(Icons.send),
                      tooltip: isButtonEnabled ? 'Send' : 'Disabled',
                    ),
                  ],
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}
