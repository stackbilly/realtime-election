import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/app.dart';
import 'package:realtime_election/utilities/utilities.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key, required this.theme});

  final bool theme;
  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController keyIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  ProjectUtilities utilities = ProjectUtilities();

  @override
  void dispose() {
    usernameController.dispose();
    keyIdController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> createSubAdmin() async {
    return FirebaseFirestore.instance
        .collection('election-admins')
        .doc(keyIdController.text)
        .set({
      "id": keyIdController.text,
      "username": usernameController.text,
      "type": "SUBADMIN",
      "password": utilities.hashPassword(passwordController.text).toString()
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Create Admin",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Create Admin"),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: 400,
            width: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Admin Details",
                        style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "username cannot be null";
                          } else {
                            return null;
                          }
                        },
                        controller: usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'User name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Key id cannot be null";
                          } else {
                            return null;
                          }
                        },
                        controller: keyIdController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Key Id',
                            prefixIcon: const Icon(Icons.insert_drive_file),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "password cannot be null";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: (() {
                            if (_formKey.currentState!.validate()) {
                              createSubAdmin().then((value) =>
                                  Navigator.of(context).push(
                                      const RealtimeElection().route(
                                          SubAdmins(theme: widget.theme))));
                            }
                          }),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(300, 50),
                              backgroundColor: Colors.red[800],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                          child: const Text("Create Admin"),
                        )),
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

class SubAdmins extends StatelessWidget {
  const SubAdmins({super.key, required this.theme});

  final bool theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sub Admins",
      darkTheme: ThemeData.dark(),
      themeMode: (theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sub Admins"),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("election-admins")
              .snapshots(),
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
                  "No Available data!",
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
                return ListTile(
                  title: Text(data.docs[index]['username']),
                  onTap: (() => true),
                  subtitle: Text(data.docs[index]['id']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: (() => showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                        "Delete ${data.docs[index]['username']}?"),
                                  ),
                                  TextButton(
                                    onPressed: (() {
                                      FirebaseFirestore.instance
                                          .collection('election-admins')
                                          .doc(data.docs[index]['id'])
                                          .delete();
                                    }),
                                    child: const Text("Delete"),
                                  )
                                ],
                              ),
                            ),
                          );
                        }))),
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
