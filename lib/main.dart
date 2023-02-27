import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:providerhive/ChangeScreenProvider.dart';
import 'package:providerhive/database/PostConstant.dart';
import 'package:providerhive/database/models/post_info_model.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PostInfoAdapter());
  await Hive.openBox<PostInfo>(postList);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ChangeScreenProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ChangeScreenProvider changeProvider;

  @override
  void initState() {
    super.initState();
    changeProvider = Provider.of<ChangeScreenProvider>(context, listen: false);
    PostConstant().getPostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<PostInfo>(postList).listenable(),
          builder: (context, value, child) {
            final listOfPost = value.values.toList().cast<PostInfo>();
            return ListView.builder(
              itemCount: listOfPost != null ? listOfPost.length : 0,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: listItem(listOfPost[index]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Consumer<ChangeScreenProvider>(
        builder: (context, value, child) {
          return FloatingActionButton.extended(
            backgroundColor: value.isEnableAddTask ? Colors.green : Colors.grey,
            onPressed: () {
              changeProvider.changeAddTaskState(enable: !value.isEnableAddTask);
            },
            tooltip: 'Increment',
            label: Text(value.isEnableAddTask ? "Disable" : "Enable"),
          );
        },
      ),
    );
  }

  Widget listItem(PostInfo info) {
    return Card(
      margin: const EdgeInsets.only(left: 12, right: 12, top: 8),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Material(
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white24, width: 2),
            borderRadius: BorderRadius.circular(4)),
        child: InkWell(
          splashColor: Colors.orange,
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  info.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  info.title,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
