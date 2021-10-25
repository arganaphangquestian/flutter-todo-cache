import 'package:cach/model.dart';
import 'package:cach/network.dart';
import 'package:cach/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupStorage();
  setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [ListScreen(), BookmarkScreen()][_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (idx) {
          setState(() {
            _selectedTab = idx;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookmark',
          ),
        ],
      ),
    );
  }
}

class ListScreenController extends GetxController {
  var todos = <Todo>[].obs;

  @override
  onInit() {
    super.onInit();
    getTodos();
  }

  void getTodos() async {
    TodoNetwork.getTodos().then((value) async {
      var box = await Hive.openBox('local_todos');
      box.put("data", value).then((_) {
        var local = box.get("data", defaultValue: []);
        todos = RxList.from(local ?? []);
        update();
      });
    }).catchError((e) {
      debugPrint("$e");
    });
  }
}

class ListScreen extends StatelessWidget {
  ListScreen({Key? key}) : super(key: key);
  final ListScreenController con = Get.put(ListScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListScreenController>(
      init: ListScreenController(),
      builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            _.getTodos();
          },
          child: ListView.builder(
            itemBuilder: (ctx, idx) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(_.todos[idx].title)),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          debugPrint('$idx');
                        },
                        icon: const Icon(Icons.favorite),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: _.todos.length,
          ),
        );
      },
    );
  }
}

class BookmarkScreenController extends GetxController {}

class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({Key? key}) : super(key: key);
  final BookmarkScreenController con = Get.put(BookmarkScreenController());

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Bookmark"),
    );
  }
}
