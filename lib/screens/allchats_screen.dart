import 'package:chatapp1st/screens/inbox_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  final usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final QueryDocumentSnapshot document = documents[index];
              final String name = document['name'];
              final String email = document['email'];
              final String? photoUrl = document['photoUrl'];
              return ListTile(
                leading: photoUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl),
                      )
                    : const Icon(Icons.account_circle),
                title: Text(name),
                subtitle: Text(email),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InboxScreen()));
                },
              );
            },
          );
        },
      ),
    );
  }
}
