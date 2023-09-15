import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

class Settings extends StatefulWidget {
  const Settings({
    super.key,
    required this.lang,
    required this.changeLanguage,
  });
  final String lang;
  final void Function(String v) changeLanguage;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool about = false;

  late String lang;
  @override
  void initState() {
    super.initState();
    lang = widget.lang;
  }

  FlagsCode current() {
    switch (lang) {
      case 'EN':
        return FlagsCode.GB;
      case 'ES':
        return FlagsCode.ES;
    }
    return FlagsCode.GB_ENG;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: DropdownButton(
                hint: Flag.fromCode(current(), width: 32),
                iconSize: 32,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.all(10),
                dropdownColor: Colors.grey.shade900,
                onChanged: (value) {
                  setState(() {
                    lang = ['EN', 'ES'][value!];
                    widget.changeLanguage(lang);
                  });
                },
                items: [
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    value: 0,
                    child: Flag.fromCode(FlagsCode.GB, width: 50),
                  ),
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    value: 1,
                    child: Flag.fromCode(FlagsCode.ES, width: 50),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => about ^= true),
              child: AnimatedContainer(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade900,
                          blurRadius: 3,
                          spreadRadius: 6),
                    ]),
                duration: const Duration(milliseconds: 200),
                width: about ? 250 : 60,
                height: about ? 250 : 60,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    about
                        ? 'This application was made as a final project for a degree at UPC - CITM'
                        : 'イ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: about ? 24 : 36,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
