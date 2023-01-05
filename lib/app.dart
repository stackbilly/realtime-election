import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/admin/login.dart';
import 'package:realtime_election/admin/notifications.dart';
import 'package:realtime_election/analysis.dart';
import 'package:realtime_election/tabs/faculty_tab.dart';
import 'package:realtime_election/tabs/general_tab.dart';
import 'package:realtime_election/tabs/governing_council_tab.dart';
import 'package:realtime_election/utilities/utilities.dart';

class RealtimeElection extends StatelessWidget {
  const RealtimeElection({Key? key}) : super(key: key);

  static ThemeData themeData = ThemeData(primarySwatch: Colors.blue);

  Route<dynamic> route(Widget widget) {
    return CupertinoPageRoute(builder: (BuildContext context) {
      return widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Realtime Election Home",
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: HomePage(
        theme: false,
      ),
    );
  }
}

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.theme}) : super(key: key);

  bool theme;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Tab> tabs = <Tab>[
    Tab(
      text: "General",
    ),
    Tab(
      text: "Faculty Reps",
    ),
    Tab(
      text: "Gov-Council",
    )
  ];

  int size = 0;

  Future<int> notification() async {
    QuerySnapshot notifications =
        await FirebaseFirestore.instance.collection("notifications").get();
    setState(() {
      size = notifications.size;
    });
    return size;
  }

  @override
  void initState() {
    super.initState();

    notification();
  }

  final RealtimeElection realtime = const RealtimeElection();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
          home: Scaffold(
              appBar: AppBar(
                title: const Text("Election Results"),
                actions: [
                  IconButton(
                    onPressed: (() {
                      setState(() {
                        widget.theme = !widget.theme;
                      });
                    }),
                    icon: (widget.theme)
                        ? const Icon(Icons.light_mode)
                        : const Icon(
                            Icons.dark_mode,
                          ),
                    tooltip: (widget.theme) ? 'Light mode' : 'Dark mode',
                  ),
                  IconButton(
                    onPressed: (() {
                      notification();
                      Navigator.of(context)
                          .push(realtime.route(ViewNotifications(
                        theme: widget.theme,
                        user: User.normal,
                      )));
                    }),
                    icon: (size == 0)
                        ? const Icon(Icons.notifications)
                        : const Icon(
                            Icons.notification_add,
                            color: Colors.red,
                          ),
                    tooltip: (size == 0)
                        ? 'No new notifcations'
                        : 'You have $size new notfications',
                  )
                ],
                bottom: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3.0,
                  tabs: tabs,
                ),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: 100,
                      child: DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                          ),
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: Center(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: InkWell(
                                    onLongPress: (() => Navigator.of(context)
                                        .push(realtime.route(
                                            AdminLogin(theme: widget.theme)))),
                                    child: const Text(
                                      'Realtime Election',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )))),
                    ),
                    ListTile(
                        leading: const Icon(
                          Icons.notifications,
                        ),
                        title: const Text('Notifications'),
                        onTap: (() => Navigator.of(context)
                                .push(realtime.route(ViewNotifications(
                              theme: widget.theme,
                              user: User.normal,
                            )))),
                        trailing: Container(
                          width: 35,
                          height: 35,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.amber),
                          child: Center(
                            child: Text(
                              "$size",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )),
                    ListTile(
                      leading: const Icon(
                        Icons.leaderboard,
                      ),
                      title: const Text('Analysis'),
                      onTap: (() => Navigator.of(context).push(realtime
                          .route(GeneralAnalysis(theme: widget.theme)))),
                    ),
                    ListTile(
                      leading: Icon(
                          (widget.theme) ? Icons.light_mode : Icons.dark_mode),
                      title:
                          Text((widget.theme) ? "Light Theme" : "Dark Theme"),
                      onTap: (() {
                        setState(() {
                          widget.theme = !widget.theme;
                        });
                      }),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  GeneralTab(
                    theme: widget.theme,
                  ),
                  FacultyTab(
                    theme: widget.theme,
                  ),
                  GoverningCouncilTab(
                    theme: widget.theme,
                  ),
                ],
              ))),
    );
  }
}
