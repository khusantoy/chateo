import 'package:chateo/controllers/users_controller.dart';
import 'package:chateo/models/user_model.dart';
import 'package:chateo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    final usersController = context.read<UsersController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: StreamBuilder(
          stream: usersController.list,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("No available contacts"),
              );
            }

            final users = snapshot.data!.docs;

            return users.isEmpty
                ? const Center(
                    child: Text("No available contacts"),
                  )
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = UserModel.fromQuerySnapshot(users[index]);
                      return ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.chat,
                              arguments: user);
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        title: Text(user.username),
                        subtitle: Text(user.email),
                      );
                    },
                  );
          }),
    );
  }
}
