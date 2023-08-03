import 'package:chatapp1st/model/appicons.dart';
import 'package:chatapp1st/screens/allchats_screen.dart';
import 'package:chatapp1st/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  bool chkvalue1 = false;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        // User signed in
        print('User signed in: ${account.email}');
      } else {
        // User signed out
        print('User signed out');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text('Google SignIn'), centerTitle: true),
        body: Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Chat App',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Sign In with Google",
                                  style: TextStyle(fontSize: 18)),
                              const SizedBox(
                                width: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(AppIcons.google),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ))
              ])),
    ));
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Authentication succeeded
        setState(() {
          loading = true;
        });
        final String? photoUrl = googleUser.photoUrl;
        print('User signed in: ${googleUser.email}');
        Utils().toastmessage('User signed in: ${googleUser.email}');
        // Retrieve the user's profile image URL
       await addUserToFirestore(googleUser, photoUrl);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllChatsScreen()),
        );
      } else {
        // Authentication failed
        print('Sign in failed');
        setState(() {
          loading = false;
        });
        Utils().toastmessage('Sign in failed');
      }
    } catch (error) {
      // Handle the error
      print(error);
      setState(() {
        loading = false;
      });
      Utils().toastmessage(error.toString());
    }
  }

  Future<void> addUserToFirestore(GoogleSignInAccount user, String? photoUrl) async {
  final usersRef = FirebaseFirestore.instance.collection('users');

  final userDoc = usersRef.doc(user.id);

  await userDoc.set({
    'name': user.displayName,
    'email': user.email,
    'photoUrl': photoUrl,
  });
}

}
