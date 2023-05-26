import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      theme: ThemeData(
        fontFamily: "Press Start 2P",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const int paper = 0;
const int rock = 1;
const int scissors = 2;

enum Winner { me, computer, draw }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int computer = rock;
  int me = paper;
  int roundNumber = 0;
  int winNumber = 0;
  List<Winner> roundsWinner = [];
  bool pointerOnUser = true;
  bool pointerOnComputer = false;
  int maxRoundCount = 12;
  Color backgroundColor = Colors.white;

  void setPointerOnUser() {
    setState(() {
      pointerOnUser = true;
      pointerOnComputer = false;
    });
  }

  void setPointerOnComputer() {
    setState(() {
      pointerOnUser = false;
      pointerOnComputer = true;
    });
  }

  void reset() {
    setState(() {
      computer = rock;
      me = paper;
      roundsWinner.clear();
      winNumber = 0;
      roundNumber = 0;
      pointerOnUser = true;
      pointerOnComputer = false;
      backgroundColor = Colors.white;
    });
  }

  void calWinner() {
    late Winner winner;
    if (me == computer) {
      winner = Winner.draw;
    } else if (me == paper) {
      if (computer == scissors) {
        winner = Winner.computer;
      } else {
        winner = Winner.me;
        winNumber++;
      }
    } else if (me == scissors) {
      if (computer == rock) {
        winner = Winner.computer;
      } else {
        winner = Winner.me;
        winNumber++;
      }
    } else {
      // me==paper 100%
      if (computer == paper) {
        winner = Winner.computer;
      } else {
        winner = Winner.me;
        winNumber++;
      }
    }
    roundsWinner.add(winner);
    colorEffect(winner);
  }

  void diceMe() {
    setState(() {
      me = Random().nextInt(3);
      roundNumber++;
    });
  }

  void diceComputer() {
    setState(() {
      computer = Random().nextInt(3);
    });
  }

  void showResult(BuildContext ccontext) async {
    await showDialog(
        context: ccontext,
        builder: (context) {
          bool passed = winNumber > (maxRoundCount / 2);
          return Center(
            child: Container(
              margin: const EdgeInsets.all(18),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: passed ? Colors.green : Colors.red, width: 4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: passed ? Colors.green : Colors.red,
                              width: 5)),
                      child: passed
                          ? const Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 32,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 32,
                            ),
                    ),
                    const DefaultTextStyle(
                      style: TextStyle(
                          fontFamily: "Press Start 2P",
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                      child: Text(
                        "END Game",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DefaultTextStyle(
                      style: const TextStyle(
                          fontFamily: "Press Start 2P",
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w300),
                      child: Text(
                        "YOUR SCORE IS $winNumber/$maxRoundCount",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("PLAY AGAIN"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    reset();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Rock Paper Scissors",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text("When of :"),
              title: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: "Defult 12"),
                onChanged: (String value) {
                  setState(() {
                    maxRoundCount = int.tryParse(value) ?? 12;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 54,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameButton(
                    playerName: "YOU",
                    onTap: () async {
                      if (roundNumber <= maxRoundCount) {
                        setPointerOnUser();
                        await Future.delayed(const Duration(milliseconds: 100));
                        diceMe();
                        await Future.delayed(const Duration(milliseconds: 100));
                        setPointerOnComputer();
                        await Future.delayed(const Duration(milliseconds: 300));
                        diceComputer();
                        await Future.delayed(const Duration(milliseconds: 300));
                        calWinner();

                        setPointerOnUser();
                        if (roundNumber == maxRoundCount) {
                          showSnackBar(context, "Calcolat result");
                          await Future.delayed(const Duration(seconds: 1));
                          showResult(context);
                        }
                      }
                    },
                    random: me,
                    pointer: pointerOnUser,
                  ),
                  const Text(
                    "VS",
                    style: TextStyle(fontSize: 22),
                  ),
                  GameButton(
                    playerName: "Computer",
                    isRotate: true,
                    random: computer,
                    pointer: pointerOnComputer,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("Live Result:"),
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                        roundsWinner.length,
                        (index) => RefereeWidget(
                              winner: roundsWinner[index],
                            )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.restart_alt),
        onPressed: () {
          reset();
        },
      ),
    );
  }

  void colorEffect(Winner value) async {
    setState(() {});
    if (value == Winner.me) {
      backgroundColor = Colors.green[200]!;
    } else if (value == Winner.computer) {
      backgroundColor = Colors.red[200]!;
    }
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      backgroundColor = Colors.white;
    });
  }
}

class Pointer extends StatelessWidget {
  const Pointer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      child: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
        weight: 20,
      ),
    );
  }
}

class RefereeWidget extends StatelessWidget {
  const RefereeWidget({
    super.key,
    required this.winner,
  });
  final Winner winner;
  @override
  Widget build(BuildContext context) {
    if (winner == Winner.me) {
      return const CurrentResult(
        icon: Icon(
          Icons.thumb_up,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      );
    } else if (winner == Winner.computer) {
      return const CurrentResult(
        icon: Icon(
          Icons.thumb_down,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      );
    } else {
      return CurrentResult(
        icon: const Icon(
          Icons.handshake,
          color: Colors.black,
        ),
        backgroundColor: Colors.grey[300]!,
      );
    }
  }
}

class CurrentResult extends StatelessWidget {
  const CurrentResult(
      {Key? key, required this.icon, required this.backgroundColor})
      : super(key: key);
  final Icon icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(18)),
          child: icon,
        ),
      ],
    );
  }
}

class GameButton extends StatelessWidget {
  final bool isRotate;
  final String playerName;
  final VoidCallback? onTap;
  final int random;
  final bool pointer;
  const GameButton(
      {Key? key,
      this.onTap,
      required this.random,
      this.isRotate = false,
      required this.playerName,
      required this.pointer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = TextButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          border: pointer
              ? Border.all(
                  color: Colors.black,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  width: 4,
                )
              : null,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          'assets/images/img$random.png',
          fit: BoxFit.cover,
        ),
      ),
    );
    if (isRotate) {
      body = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
        child: body,
      );
    }
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: pointer,
              maintainAnimation: true,
              maintainSize: true,
              maintainState: true,
              child: const Pointer()),
          body,
          const SizedBox(
            height: 18,
          ),
          Text(
            playerName,
            style: TextStyle(
                fontSize: 20,
                shadows: pointer
                    ? [
                        const BoxShadow(
                            color: Colors.blue, offset: Offset(0, 3))
                      ]
                    : null),
          ),
        ],
      ),
    );
  }
}
