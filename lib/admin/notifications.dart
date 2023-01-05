import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/app.dart';

import '../utilities/utilities.dart';

class AddNotification extends StatefulWidget {
  const AddNotification({super.key, required this.theme});

  final bool theme;
  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  CollectionReference ref =
      FirebaseFirestore.instance.collection("notifications");
  Future<DocumentReference<Object?>> postNotification() async {
    return ref
        .add({"timestamp": Timestamp.now(), "message": messageController.text});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notification Add",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Add Notification"),
            leading: InkWell(
              onTap: (() => Navigator.of(context).pop()),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "message cannot be empty";
                          } else {
                            return null;
                          }
                        }),
                        controller: messageController,
                        maxLines: 7,
                        decoration: InputDecoration(
                            labelText: 'Message',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    )),
                ElevatedButton(
                  onPressed: (() {
                    postNotification().then((value) {
                      Navigator.of(context).push(
                          const RealtimeElection().route(ViewNotifications(
                        theme: widget.theme,
                        user: User.admin,
                      )));
                      messageController.clear();
                    });
                  }),
                  child: const Text("Notify"),
                )
              ],
            ),
          )),
    );
  }
}

class ViewNotifications extends StatelessWidget {
  const ViewNotifications({super.key, required this.theme, required this.user});

  final bool theme;
  final User user;
  @override
  Widget build(BuildContext context) {
    final CollectionReference notifications =
        FirebaseFirestore.instance.collection("notifications");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notifications",
      darkTheme: ThemeData.dark(),
      themeMode: (theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("notifications")
              .orderBy("timestamp", descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error retrieving data!",
                  style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "No new notifications!",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.requireData;

            return ListView.builder(
              itemCount: data.size,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 180,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 10.0,
                            top: 10.0,
                            child: Text(
                              "Realtime-Election",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: (theme)
                                      ? Colors.white
                                      : Colors.blueGrey[800]),
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Text(
                              ((data.docs[index]['timestamp'] as Timestamp)
                                      .toDate())
                                  .toString()
                                  .split(' ')
                                  .last
                                  .split('.')
                                  .first,
                              style: TextStyle(color: Colors.amber.shade600),
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            bottom: 10.0,
                            child: Text(
                                (data.docs[index]['timestamp'] as Timestamp)
                                    .toDate()
                                    .toString()
                                    .split(' ')
                                    .first),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50.0,
                              left: 10.0,
                            ),
                            child: Text(
                              data.docs[index]['message'].toString(),
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 17),
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            left: 10.0,
                            child: TextButton.icon(
                                onPressed: (() => false),
                                icon: Icon(
                                  Icons.notification_important,
                                  color: Colors.red.shade900,
                                ),
                                label: Text(
                                  "Information",
                                  style: TextStyle(color: Colors.red.shade800),
                                )),
                          ),
                          Positioned(
                            left: 150.0,
                            bottom: 10.0,
                            child: (user == User.admin)
                                ? IconButton(
                                    onPressed: (() {
                                      notifications
                                          .doc(data.docs[index].reference.id)
                                          .delete();
                                    }),
                                    icon: const Icon(Icons.delete),
                                  )
                                : const Text(" "),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
