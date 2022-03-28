import 'package:bulk_messenger/constants.dart';
import 'package:flutter/material.dart';
import '../group.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/model_group.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Group> groups = [];
  late TextEditingController controller_1;

  late double width;
  late double height;

  final bottomNode = FocusNode();

  List<StoredGroup?> listOfGroups = [];
  late Box box;
  List<int> id = [];

  bool selected = false;
  bool deleteMode = false;
  bool isEmpty = false;
  List<bool> states = [];

  @override
  void initState() {
    super.initState();
    controller_1 = TextEditingController();
    hiveInit();
  }

  void hiveInit() async {
    await Hive.openBox<StoredGroup>('group');
    box = Hive.box<StoredGroup>('group');
    updateState();
  }

  void updateState() {
    Iterable<dynamic> keys = box.keys;
    List<Group> newGroup = [];
    id = keys.map((e) => e as int).toList();

    for (int i = 0; i < keys.length; i++) {
      StoredGroup current;
      current = box.get(keys.elementAt(i));
      newGroup.add(Group(current.name, current.numbers));
    }
    groups = newGroup;
    states = groups.map((e) => false).toList();
    setState(() {});
  }

  Future<dynamic> showBottomSheet() {
    setState(() {
      deleteMode = false;
      selected = false;
    });

    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      elevation: 0,
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, setState) => SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.03),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                  child: TextField(
                    focusNode: bottomNode,
                    onChanged: (text) {
                      if (text.isEmpty || text.trim().isEmpty) {
                        setState(() {
                          isEmpty = true;
                        });
                      } else {
                        setState(() {
                          isEmpty = false;
                        });
                      }
                    },
                    controller: controller_1,
                    autofocus: true,
                    style: kBodyText.copyWith(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      errorText: isEmpty ? "Enter a valid Name" : null,
                      contentPadding: const EdgeInsets.all(20),
                      hintText: "Group Name",
                      hintStyle: kBodyText,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: kFocusBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.1),
                  child: InkWell(
                    onTap: () {
                      if (!isEmpty && controller_1.text.isNotEmpty) {
                        final newGroup = StoredGroup();

                        newGroup.name = controller_1.text;
                        newGroup.numbers = [];
                        box.add(newGroup); // creating and adding a new group
                        controller_1.text = '';
                        updateState();

                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          isEmpty = true;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(height * 0.018),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        "add group",
                        style: kBodyText.copyWith(
                            color: Colors.black,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    controller_1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showBottomSheet();
        },
        child: const Icon(
          Icons.add,
          color: kBackgroundColor,
        ),
      ),
      appBar: AppBar(
        title: const Text("Contact Groups"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: selected
                ? () {
                    for (int i = 0; i < groups.length; i++) {
                      if (states[i]) {
                        box.delete(id.elementAt(
                            i)); // deleting the specific group objects from the hive database
                      }
                    }

                    updateState();
                  }
                : null,
            icon: selected ? const Icon(Icons.delete) : const Icon(Icons.clear),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    Group group = groups[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: height * 0.0075, horizontal: width * 0.01),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: ListTile(
                          onTap: deleteMode
                              ? () {
                                  setState(() {
                                    states[index] = !states[index];
                                  });
                                }
                              : () {
                                  Navigator.of(context)
                                      .pushNamed('/editor', arguments: group)
                                      .then((value) {
                                    if (value is Group) {
                                      final storedKey = id.elementAt(index);
                                      StoredGroup current = box.get(storedKey);

                                      current.name = value.getName();
                                      current.numbers = value.getNumbers();
                                      box.put(storedKey, current);

                                      updateState();
                                    }
                                  });
                                },
                          onLongPress: () {
                            setState(() {
                              selected = !selected;
                              deleteMode = !deleteMode;
                              states = states.map((e) => false).toList();
                            });
                          },
                          leading: const Icon(Icons.group),
                          title: Text(group.getName()),
                          trailing: selected
                              ? states[index]
                                  ? const Icon(Icons.circle_rounded,
                                      color: Colors.black)
                                  : const Icon(
                                      Icons.circle_outlined,
                                    )
                              : Text(group.getNumbers().length.toString())),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
