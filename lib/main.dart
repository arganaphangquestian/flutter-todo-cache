import 'package:cach/core.dart';
import 'package:cach/model.dart';
import 'package:cach/network.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

void main() {
  Core();
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

  void getTodos() {
    TodoNetwork.getTodos().then((value) {
      debugPrint('Get TODOS ${value.length}');
      todos = RxList.from(value);
      update();
    }).catchError((e) {});
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
            debugPrint("${_.todos.length}");
          },
          child: ListView.builder(
            itemBuilder: (ctx, idx) {
              return Card(
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
