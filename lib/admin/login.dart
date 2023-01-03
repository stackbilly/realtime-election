import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/admin/home.dart';
import 'package:realtime_election/app.dart';
import 'package:realtime_election/utilities/utilities.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key, required this.theme, required this.id});

  final bool theme;
  final String id;
  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController? keyIdController;
  TextEditingController passwordController = TextEditingController();

  ProjectUtilities utilities = ProjectUtilities();

  @override
  void initState() {
    super.initState();

    keyIdController = TextEditingController(text: widget.id);
  }

  @override
  void dispose() {
    keyIdController!.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference ref =
        FirebaseFirestore.instance.collection('election-admins');
    return MaterialApp(
      title: "Admin Login",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Login"),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: 300,
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
                          "Login Details",
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
                              return "Key id cannot be null";
                            } else {
                              return null;
                            }
                          },
                          controller: keyIdController,
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Key id',
                              prefixIcon: const Icon(Icons.email),
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
                          child: FutureBuilder(
                            future: ref.doc(keyIdController!.text.trim()).get(),
                            builder: (_, snapshot) {
                              Map<String, dynamic> data = {};
                              if (snapshot.hasData) {
                                data = snapshot.data!.data()
                                    as Map<String, dynamic>;
                              }
                              return ElevatedButton(
                                onPressed: (() {
                                  if (utilities.isValid(
                                      data['password'].toString(),
                                      passwordController.text)) {
                                    Navigator.of(context).push(
                                        const RealtimeElection().route(
                                            AdminHome(
                                                isDarkTheme: widget.theme)));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: ((context) {
                                          return const AlertDialog(
                                            content: SizedBox(
                                              height: 100,
                                              child: Center(
                                                child: Text(
                                                  "Invalid Credentials!",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          );
                                        }));
                                  }
                                }),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[800],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    minimumSize: const Size(130, 50)),
                                child: const Text("Login"),
                              );
                            },
                          ))
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
