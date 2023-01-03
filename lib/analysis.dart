import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;
  final int y;
  final Color color;
}

class GeneralAnalysis extends StatelessWidget {
  const GeneralAnalysis({super.key, required this.theme});

  final bool theme;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> votesStream =
        FirebaseFirestore.instance.collection('votes').snapshots();
    final List<ChartData> chartData = [];
    return MaterialApp(
      title: "General Analysis",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: (theme) ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("General Analysis"),
          leading: InkWell(
            onTap: (() => Navigator.of(context).pop()),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder(
                stream: votesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      "Error retrieving data!",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Text(
                      "No Available data!",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    );
                  }
                  Map<String, dynamic> data = {};
                  if (snapshot.hasData) {
                    snapshot.data!.docs.map((DocumentSnapshot doc) {
                      data = doc.data()! as Map<String, dynamic>;
                    }).toList();
                    chartData.add(
                        ChartData('Votes Cast', data['votesCast'], Colors.red));
                    chartData.add(ChartData(
                        'Votes Counted', data['votesCounted'], Colors.blue));
                    chartData.add(ChartData(
                        'Votes Spoilt', data['votesSpoilt'], Colors.green));
                  }

                  return SfCircularChart(
                    legend: Legend(isVisible: true),
                    title: ChartTitle(text: "Election Summary"),
                    margin: const EdgeInsets.all(15),
                    series: <CircularSeries>[
                      PieSeries<ChartData, String>(
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                        dataSource: chartData,
                        pointColorMapper: (ChartData data, _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                      )
                    ],
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Progress",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: votesStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                        "Error retrieving data!",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Text(
                        "No Available data!",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    Map<String, dynamic> data = {};
                    if (snapshot.hasData) {
                      snapshot.data!.docs.map((DocumentSnapshot doc) {
                        data = doc.data()! as Map<String, dynamic>;
                      }).toList();
                    }
                    double value = data['votesCounted'] / data['votesCast'];
                    int rValue = (value * 100).toInt();
                    return CircularPercentIndicator(
                      radius: 100,
                      animation: true,
                      backgroundColor: Colors.blue,
                      animationDuration: 3000,
                      percent: value,
                      lineWidth: 20,
                      center: Text(
                        "$rValue %",
                        style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
