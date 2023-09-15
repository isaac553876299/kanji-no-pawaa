import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:rive/rive.dart';

import 'kanjim.dart';
import 'testk.dart';
import 'flashk.dart';
import 'levelr.dart';
import 'settings.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyScrollBehavior(),
      title: '漢字のパワー',
      home: const Placeholder(),
      routes: {
        'xd': (context) => const MyWidget(),
      },
      initialRoute: 'xd',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade800,
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

enum Screens {
  test,
  flash,
}

class _MyWidgetState extends State<MyWidget> {
  bool kami = false;

  //Artboard? _riveArtboard;
  SMINumber? _numInput;

  bool settings = false;
  String language_code = 'EN';

  bool filtering = true;
  Screens screen = Screens.test;

  late List<Kanji> kdb = [];
  int filter = 0;

  @override
  void initState() {
    super.initState();
    loadKustom().then((value) {
      setState(() => kdb = value);
    });
    /*rootBundle.load('assets/漢字のパワー.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        setState(() {
          _riveArtboard = artboard;
          final controller =
              StateMachineController.fromArtboard(artboard, 'State Machine 1');
          controller!.isActive = true;
          artboard.addController(controller!);
          _numInput = controller.findInput<double>('state') as SMINumber;
          artboard.advance(0);
          _numInput?.value = 0;
        });
      },
    );*/
  }

  void changeFilter(int code) {
    setState(() {
      filter = code;
    });
  }

  void changeLanguage(String new_code) {
    setState(() => language_code = new_code);
  }

  void onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _numInput = controller.findInput<double>('state') as SMINumber;
    setState(() {
      _numInput!.value = 0;
    });
  }

  void stepAnim(int code) {
    if (_numInput!.value == 0) {
      _numInput!.change(code.toDouble());
    } else {
      _numInput!.change(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kdb.isEmpty) return const CircularProgressIndicator();
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (_) {
          if (_.delta.dx.abs() > 6 && 6 < _.delta.dy.abs()) {
            setState(() {
              filtering ^= true;
              stepAnim(9);
            });
          }
        },
        onSecondaryLongPress: () => setState(() => filtering ^= true),
        onDoubleTap: () => setState(() {
          switch (screen) {
            case Screens.test:
              screen = Screens.flash;
              stepAnim(8);
              break;
            case Screens.flash:
              screen = Screens.test;
              stepAnim(0);
              break;
          }
        }),
        onLongPress: () => setState(() {
          settings ^= true;
          stepAnim(9);
        }),
        child: Center(
          child: AspectRatio(
            aspectRatio: 0.5625,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Expanded(child: SizedBox.shrink()),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: AspectRatio(
                    aspectRatio: 1.333,
                    child: RiveAnimation.asset(
                      'assets/漢字のパワー.riv',
                      artboard: 'main',
                      stateMachines: const ['State Machine 1'],
                      onInit: onRiveInit,
                    ),
                  ),
                ),
                MyDivider(Colors.grey.shade700, 10, 1, 10, 2),
                MyDivider(Colors.grey.shade300, 10, 1, 10, 2),
                MyDivider(Colors.white, 10, 1, 10, 2),
                MyDivider(Colors.grey.shade300, 10, 1, 10, 2),
                MyDivider(Colors.grey.shade700, 10, 1, 10, 2),
                Flexible(
                  flex: 10,
                  fit: FlexFit.tight,
                  child: SizedBox.expand(
                    child: settings
                        ? Settings(
                            lang: language_code, changeLanguage: changeLanguage)
                        : filtering
                            ? LevelR(onReFilter: changeFilter)
                            : screen == Screens.test
                                ? TestK(
                                    kdb: kdb,
                                    lang: language_code,
                                    filter: filter,
                                    animate: stepAnim,
                                  )
                                : screen == Screens.flash
                                    ? FlashK(kdb: kdb)
                                    : const Placeholder(),
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget MyDivider(Color c, double? ei, double? h, double? i, double? t) {
  return Divider(color: c, endIndent: ei, height: h, indent: i, thickness: t);
}
