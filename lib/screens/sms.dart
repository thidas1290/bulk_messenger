import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:bulk_messenger/model/model_group.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final controller = TextEditingController();
  final controller_2 = TextEditingController();

  late Box box;
  List<StoredGroup> groups = [];
  StoredGroup? selectedGroup;
  List<StoredGroup> selectedGroups = [];
  List<bool> states = [];
  bool deleteSelected = false;

  int count = 0;
  late int selected;
  bool isEmpty_2 = false;
  bool isEmpty_1 = false;

  @override
  void initState() {
    super.initState();
    selected = 1;
    initHive();
  }

  void initHive() async {
    await Hive.openBox<StoredGroup>('group');
    box = Hive.box<StoredGroup>('group');
    updatestate();
  }

  void updatestate() {
    List<StoredGroup> _groups = [];
    final keys = box.keys.map((e) => e as int);
    for (int i = 0; i < keys.length; i++) {
      final current = box.get(keys.elementAt(i));
      _groups.add(current);
    }
    groups = _groups;
    setState(() {});
  }

  void setSelected(val) {
    setState(() {
      selected = val;
    });
  }

  DropdownMenuItem<StoredGroup> buildeMenuItems(StoredGroup group) =>
      DropdownMenuItem(
        value: group,
        child: Text(
          group.name,
          style: kBodyText.copyWith(
            color: Colors.white,
          ),
        ),
      );

  void delete() {
    var count = 0;
    final h = StoredGroup();
    for (int i = 0; i < states.length; i++) {
      if (states[i]) {
        count++;
        selectedGroups[i] = h;
      }
    }
    for (int i = 0; i < count; i++) {
      selectedGroups.remove(h);
    }

    states = selectedGroups.map((e) => false).toList();
    setState(() {});
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("SMS"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.01, vertical: height * 0.03),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(left: width * 0.03),
                            child: TextField(
                              onChanged: (text) {
                                if (text.isEmpty || text.trim().isEmpty) {
                                  setState(() {
                                    isEmpty_1 = true;
                                  });
                                } else {
                                  setState(() {
                                    isEmpty_1 = false;
                                  });
                                }
                              },
                              controller: controller,
                              style: kBodyText.copyWith(color: Colors.white),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                errorText:
                                    isEmpty_1 ? "Enter a valid Number" : null,
                                contentPadding: const EdgeInsets.only(left: 10),
                                hintText: "Add number",
                                hintStyle: kBodyText,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kFocusBorderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: width * 0.03,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ElevatedButton(
                              onPressed: () {
                                StoredGroup newG = StoredGroup();
                                newG.name = controller.text;
                                newG.numbers = [controller.text];
                                selectedGroups.add(newG);
                                controller.text = '';
                                states =
                                    selectedGroups.map((e) => false).toList();
                                setState(() {});
                              },
                              child: const Text("add"),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: DropdownButton<StoredGroup>(
                            items:
                                groups.map((e) => buildeMenuItems(e)).toList(),
                            onChanged: (val) {
                              selectedGroup = val;
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                            dropdownColor: Colors.black12,
                            value: selectedGroup,
                            focusColor: Colors.white,
                            isExpanded: true,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton(
                                child: Text(
                                  "add",
                                  style:
                                      kBodyText.copyWith(color: Colors.black),
                                ),
                                onPressed: selectedGroup == null
                                    ? null
                                    : () {
                                        selectedGroups.add(selectedGroup!);
                                        states = selectedGroups
                                            .map((e) => false)
                                            .toList();
                                        setState(() {});
                                      },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.blue),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ElevatedButton(
                                onPressed: () {
                                  delete();
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedGroups.length,
                            itemBuilder: (context, index) {
                              final current = selectedGroups.elementAt(index);

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.005,
                                ),
                                child: ListTile(
                                  onTap: () => setState(() {
                                    states[index] = !states[index];
                                  }),
                                  tileColor: Colors.white,
                                  title: Text(current.name),
                                  trailing: SizedBox(
                                    width: width * 0.2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.05),
                                          child: Text(current.numbers.length
                                              .toString()),
                                        ),
                                        Icon(
                                          states[index]
                                              ? Icons.circle_rounded
                                              : Icons.circle_outlined,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.green),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Radio(
                                value: 1,
                                groupValue: selected,
                                onChanged: (val) {
                                  setSelected(val);
                                },
                                activeColor: Colors.white,
                                fillColor: null,
                              ),
                              title: Text(
                                "EN",
                                style: kBodyText.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: Radio(
                                // fillColor: Colors.white,
                                value: 2,
                                groupValue: selected,
                                onChanged: (val) {
                                  setSelected(val);
                                },
                                activeColor: Colors.white,
                              ),
                              title: Text(
                                "සිං",
                                style: kBodyText.copyWith(fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text("Count : $count"),
                              tileColor: Colors.white60,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.03, horizontal: width * 0.02),
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              count = text.length;
                            });
                          },
                          autocorrect: false,
                          autofocus: false,
                          controller: controller_2,
                          style: kBodyText.copyWith(color: Colors.white),
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 8,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            errorText:
                                isEmpty_2 ? "Name shouldn't be empty" : null,
                            contentPadding: const EdgeInsets.all(30),
                            hintText: "Your message...",
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
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    // ignore: prefer_const_constructors
                    decoration: BoxDecoration(
                        color: Colors.white, borderRadius: kRadius),
                    child: const Center(
                      child: Text(
                        'Send',
                        style: kButtonText,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
