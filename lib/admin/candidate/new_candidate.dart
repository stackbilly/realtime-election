import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewCandidate extends StatefulWidget {
  const NewCandidate({Key? key, required this.position, required this.theme})
      : super(key: key);

  final bool theme;
  final String position;
  @override
  State<NewCandidate> createState() => _NewCandidateState();
}

class _NewCandidateState extends State<NewCandidate> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController? facultyController;
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController regNoController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();

  static const double fieldWidth = 400.0;
  static const double rightPadding = 10.0;
  static const double leftPadding = 20.0;

  @override
  void initState() {
    super.initState();

    facultyController = TextEditingController(text: widget.position);
    imageUrlController.text = "";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    regNoController.dispose();
    facultyController!.dispose();
    imageUrlController.dispose();
    phoneNoController.dispose();

    super.dispose();
  }

  Future<void> save() async {
    final CollectionReference candidates = FirebaseFirestore.instance
        .collection(
            "position/${widget.position.trim()}/${widget.position.trim()}");
    return candidates.doc(regNoController.text.trim()).set({
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "facultyName": facultyController!.text,
      "regNo": regNoController.text,
      "imgUrl": imageUrlController.text,
      "phoneNo": phoneNoController.text,
      "votes": 0
    });
  }

  Future<void> uploadImage(String lastName) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      String filename = lastName.trim();

      Reference ref = FirebaseStorage.instance.ref().child('$filename.jpg');
      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;

        await ref.putData(fileBytes!);
        ref.getDownloadURL().then((value) {
          setState(() {
            imageUrlController.text = value;
          });
        });
      }
    } on FirebaseException {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              content: SizedBox(
                height: 80,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Error Uploading Image",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextButton(
                            onPressed: (() => Navigator.of(context).pop()),
                            child: const Text('OK')),
                      )
                    ],
                  ),
                ),
              ),
            );
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Create Candidate",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo),
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
          body: SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.3,
              child: Padding(
                  padding: const EdgeInsets.only(left: 200.0, top: 20.0),
                  child: Card(
                    // color: Colors.white60,
                    child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 50.0, right: 50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  "CANDIDATE REGISTRATION",
                                  style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: leftPadding,
                                        bottom: 20.0,
                                        top: 10.0),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "firstname cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: firstNameController,
                                        decoration: InputDecoration(
                                            labelText: 'Firstname',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: rightPadding,
                                        bottom: 20.0,
                                        top: 10.0),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "lastname cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: lastNameController,
                                        decoration: InputDecoration(
                                            labelText: 'Lastname',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: leftPadding,
                                        bottom: 20.0,
                                        top: 10.0),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "faculty name cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        readOnly: true,
                                        controller: facultyController,
                                        decoration: InputDecoration(
                                            labelText: 'Position',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: rightPadding,
                                          bottom: 20.0,
                                          top: 10.0),
                                      child: SizedBox(
                                        width: fieldWidth,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "reg no cannot be empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: regNoController,
                                          decoration: InputDecoration(
                                              labelText: "Registration no",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              )),
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: leftPadding,
                                        bottom: 20.0,
                                        top: 10.0),
                                    child: SizedBox(
                                      width: fieldWidth,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Select photo to continue";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: imageUrlController,
                                        readOnly: true,
                                        onTap: () {
                                          uploadImage(lastNameController.text);
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Profile Picture',
                                            prefixIcon: const Icon(Icons.image),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: rightPadding,
                                          bottom: 20.0,
                                          top: 10.0),
                                      child: SizedBox(
                                        width: fieldWidth,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "phone no cannot be empty";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: phoneNoController,
                                          decoration: InputDecoration(
                                              labelText: "Mobile no",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              )),
                                        ),
                                      ))
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        save().then((value) =>
                                            Navigator.of(context).pop());
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(200, 55),
                                        backgroundColor: Colors.red[800]),
                                    child: const Text(
                                      "Register Candidate",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  )),
                            ],
                          ),
                        )),
                  ))),
        ));
  }
}
