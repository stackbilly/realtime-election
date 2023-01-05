import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/admin/add_admin.dart';
import 'package:realtime_election/admin/candidate/candidate.dart';
import 'package:realtime_election/admin/candidate/edit_candidate.dart';
import 'package:realtime_election/admin/candidate/new_candidate.dart';
import 'package:realtime_election/admin/notifications.dart';
import 'package:realtime_election/app.dart';
import 'package:realtime_election/utilities/utilities.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key, required this.isDarkTheme});

  final bool isDarkTheme;
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController valueController = TextEditingController();

  ProjectUtilities utilities = ProjectUtilities();
  RealtimeElection realtime = const RealtimeElection();

  @override
  void dispose() {
    valueController.dispose();

    super.dispose();
  }

  Future<void> addValue(String field, int newCount) async {
    DocumentReference votesReference =
        FirebaseFirestore.instance.collection('votes').doc('votes');

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(votesReference);

      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

      transaction.update(votesReference, {field: data[field] + newCount});
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> votesStream =
        FirebaseFirestore.instance.collection("votes").snapshots();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        themeMode: (widget.isDarkTheme) ? ThemeMode.dark : ThemeMode.light,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Realtime Election"),
            actions: const [
              Padding(
                padding: EdgeInsets.only(top: 13.0, right: 10.0),
                child: Text(
                  "Admin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    child: SizedBox(
                      width: 230,
                      child: Container(
                        color: Colors.blueGrey.shade900,
                        child: Column(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 50.0, left: 20.0, right: 20.0),
                              child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/admin.png"),
                                  radius: 40),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Admin",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.indigo),
                              ),
                            ),
                            utilities.listTiles(
                                "Dashboard", Icons.palette, () {}),
                            utilities.listTiles("Home", Icons.home_rounded, () {
                              Navigator.of(context)
                                  .push(realtime.route(HomePage(
                                theme: widget.isDarkTheme,
                              )));
                            }),
                            ListTile(
                              title: const Text(
                                "Category",
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              leading: const Icon(
                                Icons.list_alt,
                                color: Colors.white,
                              ),
                              trailing: IconButton(
                                onPressed: (() => Navigator.of(context)
                                        .push(realtime.route(CreateCategory(
                                      theme: widget.isDarkTheme,
                                    )))),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              onTap: (() {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          height: 120,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: TextButton(
                                                  onPressed: (() =>
                                                      Navigator.of(context)
                                                          .push(realtime
                                                              .route(Category(
                                                        theme:
                                                            widget.isDarkTheme,
                                                        type: "Congress",
                                                      )))),
                                                  child: const Text(
                                                    "Congress",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: (() =>
                                                    Navigator.of(context).push(
                                                        realtime.route(Category(
                                                      theme: widget.isDarkTheme,
                                                      type: "Governing Council",
                                                    )))),
                                                child: const Text(
                                                    "Governing Council",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }),
                            ),
                            ListTile(
                              title: const Text(
                                "Notifications",
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              leading: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              trailing: IconButton(
                                onPressed: (() => Navigator.of(context).push(
                                    realtime.route(AddNotification(
                                        theme: widget.isDarkTheme)))),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              onTap: (() => Navigator.of(context)
                                      .push(realtime.route(ViewNotifications(
                                    theme: widget.isDarkTheme,
                                    user: User.admin,
                                  )))),
                            ),
                            ListTile(
                              title: const Text(
                                "Admin",
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              leading: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              ),
                              trailing: IconButton(
                                onPressed: (() => Navigator.of(context).push(
                                    realtime.route(
                                        AddAdmin(theme: widget.isDarkTheme)))),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                tooltip: 'Add admin',
                              ),
                              onTap: (() => Navigator.of(context).push(
                                  realtime.route(
                                      SubAdmins(theme: widget.isDarkTheme)))),
                            ),
                            utilities.listTiles("Logout", Icons.logout, () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  realtime.route(
                                      HomePage(theme: widget.isDarkTheme)),
                                  (route) => false);
                            }),
                          ],
                        ),
                      ),
                    )),
                Positioned(
                  top: 20.0,
                  left: 400.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 150,
                          width: 250,
                          child: InkWell(
                            onTap: (() {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 160,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: TextFormField(
                                                  validator: ((value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Value cannot be empty";
                                                    } else {
                                                      return null;
                                                    }
                                                  }),
                                                  controller: valueController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Value'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: TextButton(
                                                  onPressed: (() {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      addValue(
                                                              'votesCast',
                                                              int.tryParse(
                                                                  valueController
                                                                      .text)!)
                                                          .then((value) =>
                                                              valueController
                                                                  .clear());
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  }),
                                                  child: const Text("OK"),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                            }),
                            child: Card(
                              color: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0)),
                              child: Stack(
                                children: <Widget>[
                                  const Positioned(
                                    top: 20,
                                    left: 20,
                                    child: Text(
                                      "Votes Cast",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                    ),
                                  ),
                                  Positioned(
                                      top: 70.0,
                                      right: 20.0,
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: votesStream,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<QuerySnapshot>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          Map<String, dynamic> data = {};
                                          if (snapshot.hasData) {
                                            snapshot.data!.docs
                                                .map((DocumentSnapshot doc) {
                                              data = doc.data()!
                                                  as Map<String, dynamic>;
                                            }).toList();
                                          }
                                          return Text(
                                            data['votesCast'].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          );
                                        },
                                      )),
                                  const Positioned(
                                      top: 70.0,
                                      left: 20.0,
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: SizedBox(
                          height: 150,
                          width: 250,
                          child: Card(
                            color: Colors.indigo,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0)),
                            child: Stack(
                              children: <Widget>[
                                const Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Text(
                                    "Votes Counted",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                                Positioned(
                                    top: 70.0,
                                    right: 20.0,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: votesStream,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        Map<String, dynamic> data = {};
                                        if (snapshot.hasData) {
                                          snapshot.data!.docs
                                              .map((DocumentSnapshot doc) {
                                            data = doc.data()!
                                                as Map<String, dynamic>;
                                          }).toList();
                                        }
                                        return Text(
                                          data['votesCounted'].toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        );
                                      },
                                    )),
                                const Positioned(
                                    top: 70.0,
                                    left: 20.0,
                                    child: Icon(
                                      Icons.leaderboard,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: SizedBox(
                            height: 150,
                            width: 250,
                            child: InkWell(
                              onTap: (() {
                                showDialog(
                                    context: context,
                                    builder: ((context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          height: 160,
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: TextFormField(
                                                    validator: ((value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Value cannot be empty";
                                                      } else {
                                                        return null;
                                                      }
                                                    }),
                                                    controller: valueController,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText: 'Value'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: TextButton(
                                                    onPressed: (() {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        addValue(
                                                                'votesSpoilt',
                                                                int.tryParse(
                                                                    valueController
                                                                        .text)!)
                                                            .then((value) =>
                                                                valueController
                                                                    .clear());
                                                        Navigator.of(context)
                                                            .pop();
                                                      }
                                                    }),
                                                    child: const Text("OK"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }));
                              }),
                              child: Card(
                                color: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: Stack(
                                  children: <Widget>[
                                    const Positioned(
                                      top: 20,
                                      left: 20,
                                      child: Text(
                                        "Votes Spoilt",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                                    ),
                                    Positioned(
                                        top: 70.0,
                                        right: 20.0,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: votesStream,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            Map<String, dynamic> data = {};
                                            if (snapshot.hasData) {
                                              snapshot.data!.docs
                                                  .map((DocumentSnapshot doc) {
                                                data = doc.data()!
                                                    as Map<String, dynamic>;
                                              }).toList();
                                            }
                                            return Text(
                                              data['votesSpoilt'].toString(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20),
                                            );
                                          },
                                        )),
                                    const Positioned(
                                        top: 70.0,
                                        left: 20.0,
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (() =>
                Navigator.of(context).push(realtime.route(CreateCategory(
                  theme: widget.isDarkTheme,
                )))),
            child: const Icon(
              Icons.add,
              size: 25,
            ),
          ),
        ));
  }
}

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key, required this.theme});

  final bool theme;
  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController positionController = TextEditingController();

  List<String> type = ["Congress", "Governing Council", "Other"];

  String firstValue = "Congress";
  RealtimeElection realtime = const RealtimeElection();

  @override
  void dispose() {
    positionController.dispose();

    super.dispose();
  }

  Future<void> save() async {
    CollectionReference position =
        FirebaseFirestore.instance.collection("position");

    return position
        .doc(positionController.text.trim())
        .set({"name": positionController.text, "type": firstValue});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Create Position"),
          leading: InkWell(
            onTap: (() => Navigator.pop(context)),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: 350,
            width: 350,
            child: Card(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Position Details",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                color: Colors.blue),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Position name cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: positionController,
                        decoration: InputDecoration(
                            labelText: 'Position',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Type",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 17),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: DropdownButton(
                              value: firstValue,
                              onChanged: (String? value) {
                                setState(() {
                                  firstValue = value!;
                                });
                              },
                              items: type.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: (() {
                              if (_formKey.currentState!.validate()) {
                                save().then((value) =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                        realtime.route(AdminHome(
                                          isDarkTheme: widget.theme,
                                        )),
                                        (route) => false));
                              }
                            }),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(120, 45)),
                            child: const Text("Add"),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ViewCandidates extends StatefulWidget {
  const ViewCandidates(
      {super.key, required this.position, required this.theme});

  final bool theme;
  final String position;

  @override
  State<ViewCandidates> createState() => _ViewCandidateState();
}

class _ViewCandidateState extends State<ViewCandidates> {
  RealtimeElection realtime = const RealtimeElection();

  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController votesController = TextEditingController();

  @override
  void dispose() {
    votesController.dispose();

    super.dispose();
  }

  Future<void> _addVote(String id, int votes) async {
    DocumentReference candidateReference = FirebaseFirestore.instance
        .collection("position/${widget.position}/${widget.position}")
        .doc(id.trim());

    DocumentReference votesReference =
        FirebaseFirestore.instance.collection("votes").doc("votes");

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot candidateSnapshot =
          await transaction.get(candidateReference);
      DocumentSnapshot votesSnapshot = await transaction.get(votesReference);

      Map<String, dynamic> candidateData =
          candidateSnapshot.data()! as Map<String, dynamic>;
      int newVoteCount = candidateData['votes'] + votes;
      transaction.update(candidateReference, {'votes': newVoteCount});

      Map<String, dynamic> votesData =
          votesSnapshot.data()! as Map<String, dynamic>;
      transaction.update(votesReference, {
        'votesCast': votesData['votesCast'] + votes,
        'votesCounted': votesData['votesCounted'] + votes,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Candidate candidate = Candidate('', '', '', '', '', '', 0);
    Stream<QuerySnapshot> candidateStream = FirebaseFirestore.instance
        .collection("position/${widget.position}/${widget.position}")
        .orderBy('votes', descending: true)
        .snapshots();
    return MaterialApp(
      title: widget.position,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.position),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 100.0, top: 20.0, right: 100.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: candidateStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Error retrieving data!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "No available candidates!",
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
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 100,
                    // width: 500,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.docs[index]['firstName']} ${data.docs[index]['lastName']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                  onPressed: (() {
                                    candidate.firstName =
                                        data.docs[index]['firstName'];
                                    candidate.lastName =
                                        data.docs[index]['lastName'];
                                    candidate.facultyName =
                                        data.docs[index]['facultyName'];
                                    candidate.regNo = data.docs[index]['regNo'];
                                    candidate.imgUrl =
                                        data.docs[index]['imgUrl'];
                                    candidate.phoneNo =
                                        data.docs[index]['phoneNo'];
                                    candidate.votes = data.docs[index]['votes'];
                                    Navigator.of(context)
                                        .push(realtime.route(EditCandidate(
                                      candidate: candidate,
                                      theme: widget.theme,
                                    )));
                                  }),
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 25,
                                  ),
                                  tooltip:
                                      'Edit ${data.docs[index]['firstName']}',
                                ),
                                IconButton(
                                  onPressed: (() {
                                    showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            content: SizedBox(
                                              height: 100,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Delete ${data.docs[index]['firstName']}?",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
                                                      child: TextButton(
                                                        onPressed: (() {
                                                          FirebaseStorage
                                                              .instance
                                                              .refFromURL(data
                                                                          .docs[
                                                                      index]
                                                                  ['imgUrl'])
                                                              .delete();
                                                          CollectionReference
                                                              ref =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "position/${widget.position}/${widget.position}");
                                                          ref
                                                              .doc(data.docs[
                                                                      index]
                                                                  ['regNo'])
                                                              .delete();
                                                          Navigator.of(context)
                                                              .pop();
                                                        }),
                                                        child: const Text(
                                                            "Delete"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }));
                                  }),
                                  icon: const Icon(Icons.delete),
                                )
                              ],
                            ),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  NetworkImage(data.docs[index]['imgUrl']),
                            ),
                            trailing: IconButton(
                              onPressed: (() {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: SizedBox(
                                          height: 130,
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: TextFormField(
                                                    validator: ((value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "votes cannot be empty";
                                                      } else {
                                                        return null;
                                                      }
                                                    }),
                                                    controller: votesController,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText: 'Votes'),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: (() {
                                                    _addVote(
                                                        data.docs[index]
                                                            ['regNo'],
                                                        int.tryParse(
                                                            votesController
                                                                .text)!);
                                                    Navigator.of(context).pop();
                                                  }),
                                                  child: const Text("Add"),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              }),
                              icon: const Icon(
                                Icons.add,
                                size: 25,
                                color: Colors.blue,
                              ),
                              tooltip: 'Add vote',
                            ),
                            subtitle: Text(
                              'Votes: ${data.docs[index]['votes']}',
                              style: const TextStyle(
                                  // fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({Key? key, required this.theme, required this.type})
      : super(key: key);

  final bool theme;
  final String type;
  @override
  Widget build(BuildContext context) {
    RealtimeElection realtime = const RealtimeElection();
    final Stream<QuerySnapshot> categories = FirebaseFirestore.instance
        .collection("position")
        .where('type', isEqualTo: type.trim())
        .snapshots();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Elective Positions"),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: categories,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Error retrieving data!",
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
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "No available data!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }
              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.size,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: ListTile(
                      title: Text(
                        data.docs[index]['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: (() => Navigator.of(context).push(
                            realtime.route(NewCandidate(
                                position: data.docs[index]['name'],
                                theme: theme)))),
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Candidate',
                      ),
                      onTap: (() => Navigator.of(context).push(realtime.route(
                          ViewCandidates(
                              position: data.docs[index]['name'],
                              theme: theme)))),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
