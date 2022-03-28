import 'package:bulk_messenger/constants.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class MyContactSelector extends StatefulWidget {
  const MyContactSelector({Key? key}) : super(key: key);

  @override
  _MyContactSelectorState createState() => _MyContactSelectorState();
}

class _MyContactSelectorState extends State<MyContactSelector> {
  List<Contact> contacts = [];
  List<String> selectedContacts = [];
  List<Contact> sortedContacts = [];
  List<bool> states = [];
  bool allSelected = false;
  bool isSorting = false;
  late TextEditingController controllerSearch;

  @override
  void initState() {
    super.initState();
    getContacts();
    controllerSearch = TextEditingController(text: "");
  }

  void getContacts() async {
    var data = (await ContactsService.getContacts()).toList();
    setState(() {
      contacts = data;
      sortedContacts = List.from(data);
      states = data.map((e) => false).toList();
    });
  }

  void selectAll() {
    allSelected = !allSelected;

    setState(() {
      if (allSelected) {
        states = states.map((e) => true).toList();
      } else {
        states = states.map((e) => false).toList();
      }
    });
  }

  void sortContacts(String text) {
    if (text.isNotEmpty) {
      sortedContacts = List.from(contacts);
      sortedContacts.retainWhere((contact) {
        String _contactName = contact.displayName!.toLowerCase();
        return _contactName.contains(text);
      });
      setState(() {
        // sortedContacts = sortedContacts;
        states = sortedContacts.map((e) => false).toList();
        isSorting = true;
      });
    } else {
      setState(() {
        states = contacts.map((e) => false).toList();
        isSorting = false;
      });
    }
  }

  void passData() {
    List<int> indices = [];
    for (int i = 0; i < states.length; i++) {
      if (states[i]) {
        indices.add(i);
      }
    }
    for (int i = 0; i < indices.length; i++) {
      selectedContacts
          .add((contacts[indices[i]].phones!.elementAt(0).value.toString()));
    }
    Navigator.of(context).pop(selectedContacts);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Contacts"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              passData();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.1),
              child: TextField(
                keyboardType: TextInputType.name,
                autofocus: true,
                controller: controllerSearch,
                style: kBodyText,
                decoration: InputDecoration(
                  hintText: "Search",
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
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onChanged: (text) {
                  sortContacts(text);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    selectAll();
                  },
                  child: const Text("select all")),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount:
                      isSorting ? sortedContacts.length : contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    Contact current;
                    if (isSorting) {
                      current = sortedContacts[index];
                    } else {
                      current = contacts[index];
                    }
                    return ListTile(
                      onTap: () {
                        setState(() {
                          states[index] = !states[index];
                        });
                      },
                      leading: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      title: Text(
                        current.displayName!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        current.phones!.elementAt(0).value.toString(),
                        style: const TextStyle(color: Colors.white54),
                      ),
                      trailing: states[index]
                          ? const Icon(
                              Icons.circle_sharp,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.circle_outlined,
                              color: Colors.white,
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
