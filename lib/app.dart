import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_election/admin/login.dart';
import 'package:realtime_election/analysis.dart';
import 'package:realtime_election/sub_admins/sub_admin_login.dart';
import 'package:realtime_election/tabs/faculty_tab.dart';
import 'package:realtime_election/tabs/general_tab.dart';
import 'package:realtime_election/tabs/governing_council_tab.dart';

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
      text: "Governing Council",
    )
  ];

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
                                            AdminRoute(theme: widget.theme)))),
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
                        Icons.summarize,
                      ),
                      title: const Text('Summary'),
                      onTap: (() => true),
                    ),
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

class AdminRoute extends StatefulWidget {
  const AdminRoute({super.key, required this.theme});

  final bool theme;

  @override
  State<AdminRoute> createState() => _AdminRouteState();
}

class _AdminRouteState extends State<AdminRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController idController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AdminRoute",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (widget.theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Admin's Route"),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (() {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: SizedBox(
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: TextFormField(
                                      validator: ((value) {
                                        if (value == null || value.isEmpty) {
                                          return "value cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      }),
                                      controller: idController,
                                      decoration: const InputDecoration(
                                          labelText: 'Key id'),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: (() => Navigator.of(context).push(
                                      const RealtimeElection().route(AdminLogin(
                                          theme: widget.theme,
                                          id: idController.text)))),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Proceed'),
                                )
                              ],
                            ),
                          ),
                        );
                      }));
                }),
                child: const Text("ADMIN"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: (() {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: TextFormField(
                                        validator: ((value) {
                                          if (value == null || value.isEmpty) {
                                            return "value cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        }),
                                        controller: idController,
                                        decoration: const InputDecoration(
                                            labelText: 'Key id'),
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: (() => Navigator.of(context)
                                        .push(const RealtimeElection().route(
                                            SubAdminLogin(
                                                theme: widget.theme,
                                                id: idController.text)))),
                                    icon: const Icon(Icons.arrow_forward),
                                    label: const Text('Proceed'),
                                  )
                                ],
                              ),
                            ),
                          );
                        }));
                  }),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("SUBADMIN"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
