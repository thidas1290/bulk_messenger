class Group {
  late String _name;
  late List<String> _numbers;

  Group(String name, List<String> numbers) {
    _name = name;
    _numbers = numbers;
  }

  void addNumber(String number) => _numbers.add(number);

  void setNumbers(List<String> n) => _numbers = n;

  List<String> getNumbers() => _numbers;

  String getName() => _name;

  void setName(String name) => _name = name;
}
