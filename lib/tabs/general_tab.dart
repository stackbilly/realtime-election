import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/app.dart';

class GeneralTab extends StatelessWidget {
  const GeneralTab({super.key, required this.theme});

  final RealtimeElection realtime = const RealtimeElection();
  final bool theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (MediaQuery.of(context).size.width < 1007)
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: const Text(
                          "Male Hostel Rep",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: (() => Navigator.of(context).push(
                              realtime.route(CategoryResults(
                                  categoryName: "Male Hostel Rep",
                                  theme: theme)))),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                            color: Colors.blue,
                          ),
                          tooltip: 'Proceed',
                        ),
                        onTap: (() => Navigator.of(context).push(realtime.route(
                            CategoryResults(
                                categoryName: "Male Hostel Rep",
                                theme: theme)))),
                      ),
                      ListTile(
                        title: const Text(
                          "Female Hostel Rep",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: (() => Navigator.of(context).push(
                              realtime.route(CategoryResults(
                                  categoryName: "Female Hostel Rep",
                                  theme: theme)))),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                            color: Colors.blue,
                          ),
                          tooltip: 'Proceed',
                        ),
                        onTap: (() => Navigator.of(context).push(realtime.route(
                            CategoryResults(
                                categoryName: "Female Hostel Rep",
                                theme: theme)))),
                      ),
                      ListTile(
                        title: const Text(
                          "Non Resident Male Rep",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: (() => Navigator.of(context).push(
                              realtime.route(CategoryResults(
                                  categoryName: "Non Resident Male Rep",
                                  theme: theme)))),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                            color: Colors.blue,
                          ),
                          tooltip: 'Proceed',
                        ),
                        onTap: (() => Navigator.of(context).push(realtime.route(
                            CategoryResults(
                                categoryName: "Non Resident Male Rep",
                                theme: theme)))),
                      ),
                      ListTile(
                        title: const Text(
                          "Non Resident Female Rep",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                        trailing: IconButton(
                          onPressed: (() => Navigator.of(context).push(
                              realtime.route(CategoryResults(
                                  categoryName: "Non Resident Female Rep",
                                  theme: theme)))),
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            size: 17,
                            color: Colors.blue,
                          ),
                          tooltip: 'Proceed',
                        ),
                        onTap: (() => Navigator.of(context).push(realtime.route(
                            CategoryResults(
                                categoryName: "Non Resident Female Rep",
                                theme: theme)))),
                      )
                    ]),
              ),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListTile(
                title: const Text(
                  "Male Hostel Rep",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: (() => Navigator.of(context).push(realtime.route(
                      CategoryResults(
                          categoryName: "Male Hostel Rep", theme: theme)))),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.blue,
                  ),
                  tooltip: 'Proceed',
                ),
                onTap: (() => Navigator.of(context).push(realtime.route(
                    CategoryResults(
                        categoryName: "Male Hostel Rep", theme: theme)))),
              ),
              ListTile(
                title: const Text(
                  "Female Hostel Rep",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: (() => Navigator.of(context).push(realtime.route(
                      CategoryResults(
                          categoryName: "Female Hostel Rep", theme: theme)))),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.blue,
                  ),
                  tooltip: 'Proceed',
                ),
                onTap: (() => Navigator.of(context).push(realtime.route(
                    CategoryResults(
                        categoryName: "Female Hostel Rep", theme: theme)))),
              ),
              ListTile(
                title: const Text(
                  "Non Resident Male Rep",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: (() => Navigator.of(context).push(realtime.route(
                      CategoryResults(
                          categoryName: "Non Resident Male Rep",
                          theme: theme)))),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.blue,
                  ),
                  tooltip: 'Proceed',
                ),
                onTap: (() => Navigator.of(context).push(realtime.route(
                    CategoryResults(
                        categoryName: "Non Resident Male Rep", theme: theme)))),
              ),
              ListTile(
                title: const Text(
                  "Non Resident Female Rep",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: (() => Navigator.of(context).push(realtime.route(
                      CategoryResults(
                          categoryName: "Non Resident Female Rep",
                          theme: theme)))),
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.blue,
                  ),
                  tooltip: 'Proceed',
                ),
                onTap: (() => Navigator.of(context).push(realtime.route(
                    CategoryResults(
                        categoryName: "Non Resident Female Rep",
                        theme: theme)))),
              )
            ]),
    );
  }
}

class CategoryResults extends StatelessWidget {
  const CategoryResults(
      {super.key, required this.categoryName, required this.theme});

  final String categoryName;
  final bool theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                    "position/${categoryName.trim()}/${categoryName.trim()}")
                .orderBy('votes', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Error retrieving data!",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 17,
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
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }
              final data = snapshot.requireData;
              return ListView.builder(
                itemCount: data.size,
                itemBuilder: ((context, index) {
                  return SizedBox(
                    height: 100,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: ListTile(
                          leading: InkWell(
                            onTap: (() {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 120,
                                        child: ClipRRect(
                                          child: Image.network(
                                              data.docs[index]['imgUrl']),
                                        ),
                                      ),
                                    );
                                  }));
                            }),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(data.docs[index]['imgUrl']),
                            ),
                          ),
                          title: Text(
                            "${data.docs[index]['firstName']} ${data.docs[index]['lastName']}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            data.docs[index]['regNo'],
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500),
                          ),
                          trailing: Text(
                            "Votes ${data.docs[index]['votes'].toString()}",
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 17),
                          ),
                        )),
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
