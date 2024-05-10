// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/review.dart';
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
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map<String, TextEditingController> controllers = {};
  final TextEditingController _commentController = TextEditingController(); // Form to insert data
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _moodRating = 0;

  Future<Map<String, dynamic>> _fetchAllPreferences() async {
    var x = new Review.NoData();
    var y = await  x.retrieveAllData();
    print(y.length);
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
        backgroundColor: Colors.amber,
        body: FutureBuilder<Map<String, dynamic>>(
          future: _fetchAllPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.entries.map((entry) {
                        return ListTile(
                          title: Text("${entry.key}"),
                          subtitle: TextField(
                            controller: controllers[entry.key],
                            decoration: InputDecoration(
                                hintText: "Enter ${entry.key}"),
                            onSubmitted: (value) {
                              _updatePreference(entry.key, value);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _commentController,
                          decoration: InputDecoration(labelText: 'Comment'),
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
                                    _moodRating = i;
                                  });
                                  _submitFeedback(context, user);
                                },
                                child: Text(
                                  _getMoodEmoji(i),
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: _moodRating == i
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () => _submitFeedback(context, user),
                          child: Text('Submit Feedback'),
                        ),
                        SizedBox(height: 16.0),
                        StreamBuilder(
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('feedback')
                              .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState
                                .waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Widget> commentWidgets = [];
                              Map<dynamic, dynamic>? data = snapshot.data!
                                  .snapshot.value as Map<dynamic, dynamic>?;
                              if (data != null) {
                                data.forEach((key, value) {
                                  commentWidgets.add(
                                    LongPressDraggable(
                                      data: key,
                                      // Utilizamos la clave como datos que se pasan al soltar
                                      feedback: ListTile( // Widget que se muestra mientras se está arrastrando
                                        title: Text(value['comment']),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showUpdateDialog(
                                            context,
                                            key,
                                            value['comment'],
                                            value['moodRating'],
                                          );
                                        },
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Delete Feedback'),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text('Timestamp: ${DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                        value['timestamp'])}'),
                                                    Text(
                                                        'Comment: ${value['comment']}'),
                                                    Text(
                                                        'Mood Rating: ${value['moodRating']}'),
                                                    SizedBox(height: 16),
                                                    Text(
                                                        'Are you sure you want to delete this feedback?'),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      // Delete feedback from Firebase
                                                      DatabaseReference feedbackRef = FirebaseDatabase
                                                          .instance.reference()
                                                          .child('feedback');
                                                      feedbackRef.remove()
                                                          .then((_) {
                                                        Fluttertoast.showToast(
                                                          msg: "Feedback deleted successfully.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                        );
                                                        Navigator.of(context)
                                                            .pop();
                                                      }).catchError((error) {
                                                        print(
                                                            "Failed to delete feedback: $error");
                                                        Fluttertoast.showToast(
                                                          msg: "Failed to delete feedback.",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                        );
                                                      });
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: ListTile(
                                          title: Text(value['comment']),
                                          subtitle: Text(
                                              'Mood Rating: ${value['moodRating']}'),
                                          leading: Text('${DateTime
                                              .fromMillisecondsSinceEpoch(
                                              value['timestamp'])}'),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }
                              return Expanded(
                                child: ListView(
                                  children: commentWidgets,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showLogoutConfirmationDialog();
                    },
                    child: Text('Logout'),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
    );
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
    TextEditingController commentController = TextEditingController(
        text: currentComment);
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
                    .reference().child('feedback').child(key);
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
    DatabaseReference feedbackRef = FirebaseDatabase.instance.reference().child(
        'feedback');
    feedbackRef.push().set({
      'uid': user?.uid,
      'timestamp': DateTime
          .now()
          .millisecondsSinceEpoch,
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
/*

@override
Widget build(BuildContext context) {
  User? user = _auth.currentUser;
  return Scaffold(
    appBar: AppBar(
      title: Text('Third screen'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Comment'),
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
                      _moodRating = i;
                    });
                    _submitFeedback(context, user);
                  },
                  child: Text(
                    _getMoodEmoji(i),
                    style: TextStyle(
                      fontSize: 24.0,
                      color: _moodRating == i ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => _submitFeedback(context, user),
            child: Text('Submit Feedback'),
          ),
          SizedBox(height: 16.0),
          StreamBuilder(
            stream: FirebaseDatabase.instance.reference().child('feedback').onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Widget> commentWidgets = [];
                Map<dynamic, dynamic>? data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                if (data != null) {
                  data.forEach((key, value) {
                    commentWidgets.add(
                      LongPressDraggable(
                        data: key, // Utilizamos la clave como datos que se pasan al soltar
                        feedback: ListTile( // Widget que se muestra mientras se está arrastrando
                          title: Text(value['comment']),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showUpdateDialog(
                              context,
                              key,
                              value['comment'],
                              value['moodRating'],
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Delete Feedback'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Timestamp: ${DateTime.fromMillisecondsSinceEpoch(value['timestamp'])}'),
                                      Text('Comment: ${value['comment']}'),
                                      Text('Mood Rating: ${value['moodRating']}'),
                                      SizedBox(height: 16),
                                      Text('Are you sure you want to delete this feedback?'),
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
                                        // Delete feedback from Firebase
                                        DatabaseReference feedbackRef = FirebaseDatabase.instance.reference().child('feedback');
                                            feedbackRef.remove().then((_) {
                                          Fluttertoast.showToast(
                                            msg: "Feedback deleted successfully.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                          Navigator.of(context).pop();
                                        }).catchError((error) {
                                          print("Failed to delete feedback: $error");
                                          Fluttertoast.showToast(
                                            msg: "Failed to delete feedback.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                          );
                                        });
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(value['comment']),
                            subtitle: Text('Mood Rating: ${value['moodRating']}'),
                            leading: Text('${DateTime.fromMillisecondsSinceEpoch(value['timestamp'])}'),
                          ),
                        ),
                      ),
                    );
                  });
                }
                return Expanded(
                  child: ListView(
                    children: commentWidgets,
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}
*/


