import 'package:flutter/material.dart';
import 'package:bulk_messenger/group.dart';
import '../widgets/card.dart';

class ContactPicker extends StatefulWidget {
  ContactPicker({Key? key, this.page}) : super(key: key);
  Group? page;

  @override
  _ContactPickerState createState() => _ContactPickerState();
}

class _ContactPickerState extends State<ContactPicker> {
  Group group = Group('', []);

  @override
  void initState() {
    super.initState();
    group.setName(widget.page!.getName());
    group.setNumbers(List.from(widget.page!.getNumbers()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Contact Picker"),
        actions: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.1),
            child: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(group.getNumbers());
              },
            ),
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: group.getNumbers().length,
              itemBuilder: (BuildContext context, int index) {
                String number = group.getNumbers()[index];
                return ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  title: Text(
                    number.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Container(
            height: height * 0.35,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.white12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: width * 0.4,
                  padding: EdgeInsets.symmetric(vertical: height * 0.09),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/my_contacts')
                          .then((value) {
                        if (value is List<String>) {
                          setState(
                            () {
                              for (int i = 0; i < value.length; i++) {
                                group.addNumber(value[i]);
                              }
                            },
                          );
                        }
                      });
                    },
                    child: const CustomCard(
                      icon: Icons.contacts,
                      text: "My Contacs",
                      radius: 30,
                    ),
                  ),
                ),
                Container(
                  width: width * 0.4,
                  padding: EdgeInsets.symmetric(vertical: height * 0.09),
                  child: GestureDetector(
                    onTap: () {},
                    child: const CustomCard(
                      icon: Icons.file_present,
                      text: "From a CSV file",
                      radius: 30,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
