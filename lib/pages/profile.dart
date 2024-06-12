// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import '../controllers/review.dart';
import '../controllers/place.dart';
import '../controllers/user.dart' as Usuario;
import 'login_screen.dart';

String _getMoodEmoji(int moodRating) {
  switch (moodRating) {
    case 1:
      return '😢 ';
    case 2:
      return '😞 ';
    case 3:
      return '😐 ';
    case 4:
      return '🙂 ';
    case 5:
      return '😄 ';
    default:
      return '';
  }
}

class ProfilePage extends StatefulWidget {
  final String userID;
  const ProfilePage({super.key, required this.userID});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

}


class _ProfilePageState extends State<ProfilePage> {
  late Usuario.User usuario;
  late String userImgLnk = "";
  @override
  void initState() {
    _fetchUserImage();
    //print(widget.place.idPlace!);
    super.initState();

  }
  Map<String, TextEditingController> controllers = {};
  final TextEditingController _commentController =
      TextEditingController(); // Form to insert data
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _moodRating = 0;


  Future<void> _fetchUserImage() async{
    usuario = await new Usuario.User.NoData().retrieveUserData(widget.userID);
    userImgLnk = usuario.profileURL!;
  }

  Future<Map<String, dynamic>> _fetchAllPreferences() async {
    usuario = await new Usuario.User.NoData().retrieveUserData(widget.userID);
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, dynamic> prefsMap = {};
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
      controllers[key] = TextEditingController(text: prefs.get(key).toString());
    }
    return prefsMap;
  }

  Future<void> _updatePreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchAllPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              return Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 25),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: Text("My details", style: TextStyle(fontSize: 20),),
                        ),
                        Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 20),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(image: NetworkImage(userImgLnk), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.entries.map((entry) {
                        return Container(
                            color: Colors.white,
                            height: 70,
                            padding: const EdgeInsets.symmetric(horizontal:25, vertical:10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(entry.key, style: TextStyle(fontSize: 18),),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controllers[entry.key],
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Enter ${entry.key}"),
                                    onSubmitted: (value) {
                                      _updatePreference(entry.key, value);
                                    },
                                    onChanged:(value){
                                      _updatePreference(entry.key, value);
                                    } ,
                                  ),
                                )
                              ]
                            )
                            /*ListTile(
                            title: Text("${entry.key}"),
                            subtitle: TextField(

                              controller: controllers[entry.key],
                              decoration: InputDecoration.collapsed(
                                  hintText: "Enter ${entry.key}"),
                              onSubmitted: (value) {
                                _updatePreference(entry.key, value);
                              },
                            ),
                          ),*/
                            );
                      }).toList(),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 76),
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        _showLogoutConfirmationDialog();
                      },
                      child: Text('Logout'),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                _signOut(); // Realiza el logout
              },
            ),
          ],
        );
      },
    );
  }

  // Función para hacer logout
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut(); // Hace logout
    // Redirige a la pantalla de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

// Update alertDialog
  void _showUpdateDialog(BuildContext context, String key,
      String currentComment, int currentRating) {
    TextEditingController commentController =
        TextEditingController(text: currentComment);
    int rating = currentRating;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Feedback"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: commentController,
                decoration: InputDecoration(labelText: "Comment"),
              ),
              SizedBox(height: 16.0),
              Text('Mood Rating:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for (int i = 1; i <= 5; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = i;
                        });
                      },
                      child: Text(
                        _getMoodEmoji(i),
                        style: TextStyle(
                          fontSize: 24.0,
                          color: rating == i ? Colors.amber : Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Update feedback in database
                DatabaseReference feedbackRef = FirebaseDatabase.instance
                    .reference()
                    .child('feedback')
                    .child(key);
                feedbackRef.update({
                  'comment': commentController.text,
                  'moodRating': rating,
                }).then((_) {
                  Fluttertoast.showToast(
                    msg: "Feedback updated successfully.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.of(context).pop();
                }).catchError((error) {
                  print("Failed to update feedback: $error");
                  Fluttertoast.showToast(
                    msg: "Failed to update feedback.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                });
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

// Insert function in firebase
  void _submitFeedback(BuildContext context, User? user) {
    String comment = _commentController.text;
    if (comment.isEmpty || _moodRating == null) {
      Fluttertoast.showToast(
        msg: "Please fill all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }
    DatabaseReference feedbackRef =
        FirebaseDatabase.instance.reference().child('feedback');
    feedbackRef.push().set({
      'uid': user?.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'comment': comment,
      'moodRating': _moodRating,
    }).then((value) {
      Fluttertoast.showToast(
        msg: "Feedback submitted successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }).catchError((error) {
      print("Failed to submit feedback: $error");
      Fluttertoast.showToast(
        msg: "Failed to submit feedback.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    });
  }
}
