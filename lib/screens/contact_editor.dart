import 'package:flutter/material.dart';
import '../constants.dart';
import '../group.dart';

class Selector extends StatefulWidget {
  Selector({Key? key, this.currentGroup}) : super(key: key);
  final Group? currentGroup;

  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  bool isEmpty_1 = false;
  late TextEditingController textController_1;
  TextEditingController textController_2 = TextEditingController();

  List<String> numbers = [];
  List<String> sortedNumbers = [];
  List<bool> states = [];

  Group group = Group('', []);

  bool deleteEnabled = false;
  bool allSelected = false;
  bool isSorting = false;

  @override
  void initState() {
    super.initState();
    group.setName(widget.currentGroup!.getName());
    group.setNumbers(List.from(widget.currentGroup!.getNumbers()));
    textController_1 = TextEditingController(text: group.getName());
    numbers = group.getNumbers();
    sortedNumbers = List.from(numbers);
    states = numbers.map((e) => false).toList();
    updateMicroStates();
  }

  void updateMicroStates() {
    numbers.isNotEmpty ? deleteEnabled = true : deleteEnabled = false;
  }

  void selectAll() {
    setState(() {
      allSelected = !allSelected;
      if (allSelected) {
        states = states.map((e) => false).toList();
      } else {
        states = states.map((e) => true).toList();
      }
    });
  }

  void onDelete() {
    setState(() {
      var count = 0;
      for (int i = 0; i < states.length; i++) {
        if (states[i]) {
          count++;
          numbers[i] = '';
        }
      }
      for (int i = 0; i < count; i++) {
        numbers.remove('');
      }
      states = numbers.map((e) => false).toList();
      updateMicroStates();
    });
  }

  void sortNumbers(String text) {
    if (text.isNotEmpty) {
      sortedNumbers = List.from(numbers);
      sortedNumbers
          .retainWhere((element) => element.contains(text.toLowerCase()));
      setState(() {
        states = sortedNumbers.map((e) => false).toList();
        isSorting = true;
      });
    } else {
      setState(() {
        states = numbers.map((e) => false).toList();
        isSorting = false;
      });
    }
  }

  void onSave() {
    group.setNumbers(numbers);
    if (textController_1.value.text.isNotEmpty) {
      group.setName(textController_1.value.text);
    }
    Navigator.of(context).pop(group);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Group Editor"),
        actions: [
          IconButton(
              onPressed: () {
                onSave();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.01,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: textController_1,
                  style: kBodyText.copyWith(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    errorText: isEmpty_1 ? "Enter a valid Name" : null,
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.2, vertical: height * 0.01),
                child: TextField(
                  onTap: () {},
                  controller: textController_2,
                  onChanged: (text) {
                    sortNumbers(text);
                  },
                  style: kBodyText.copyWith(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  autofocus: numbers.isNotEmpty ? true : false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    hintText: "Search Contacts",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: deleteEnabled ? Colors.white : Colors.white38,
                        child: const Text("Select all"),
                      ),
                      onTap: deleteEnabled
                          ? () {
                              selectAll();
                            }
                          : null,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: deleteEnabled
                                ? Colors.red[300]
                                : Colors.white38,
                            child: const Icon(Icons.delete),
                          ),
                          onTap: deleteEnabled
                              ? () {
                                  onDelete();
                                }
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color:
                                  deleteEnabled ? Colors.white : Colors.white38,
                              child: const Icon(Icons.sort),
                            ),
                            onTap: () {
                              setState(() {
                                numbers.sort();
                              });
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: isSorting ? sortedNumbers.length : numbers.length,
                  itemBuilder: (BuildContext builder, int index) {
                    String number;
                    if (isSorting) {
                      number = sortedNumbers[index];
                    } else {
                      number = numbers[index];
                    }
                    bool state = states[index];
                    return Column(
                      children: [
                        SizedBox(
                            height: 0.5,
                            child: Container(
                              color: Colors.white,
                            )),
                        ListTile(
                          // tileColor: Colors.white,
                          leading: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          trailing: state == true
                              ? const Icon(
                                  Icons.circle_rounded,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.circle_outlined,
                                  color: Colors.white,
                                ),
                          onTap: () {
                            setState(() {
                              states[index] = !states[index];
                            });
                          },
                          title: Text(
                            number,
                            style: const TextStyle(color: Colors.white),
                          ),
                          // minVerticalPadding: 20,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/picker', arguments: group)
                          .then((value) {
                        if (value is List<String>) {
                          setState(
                            () {
                              numbers = value;
                              states = numbers.map((e) => false).toList();
                              updateMicroStates();
                            },
                          );
                        }
                      });
                    },
                    child: Center(
                      child: Text(
                        "Add Numbers",
                        textAlign: TextAlign.center,
                        style: kBodyText3.copyWith(
                            color: Colors.black,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(vertical: height * 0.02),
                  width: width * 0.7,
                  height: height * 0.05,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: kRadius,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
