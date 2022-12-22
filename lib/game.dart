import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> gameField = [];

  @override
  void initState() {
    super.initState();

    for (int number = 0; number <= 8; number++) {
      gameField.add("");
    }
  }

  String currentPlayer = "X";
  String winningPlayer = "";
  String startPlayer = "X";

  Map<String, int> wins = {
    "X": 0,
    "O": 0,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (startPlayer == "X") {
            startPlayer = "O";
          } else {
            startPlayer = "X";
          }
        },
        tooltip: "Switch starting player",
        child: const Icon(Icons.rotate_left_rounded),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tic Tac Toe",
              style: GoogleFonts.nunito(
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "X: ${wins["X"].toString()}",
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Y: ${wins["O"].toString()}",
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      VerticalDivider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: GridView.builder(
                      itemCount: gameField.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) => InkWell(
                        borderRadius: getBorderRadiusForTile(index),
                        hoverColor: Colors.grey.withOpacity(0.2),
                        onTap: () {
                          bool gameIsFull = true;

                          for (String field in gameField) {
                            if (field == "") {
                              gameIsFull = false;
                            }
                          }

                          if (gameIsFull) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Tie",
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                                action: SnackBarAction(
                                  label: "Reset",
                                  onPressed: () {
                                    setState(() {
                                      for (int i = 0;
                                          i < gameField.length;
                                          i++) {
                                        gameField[i] = "";
                                      }
                                      currentPlayer = "X";
                                    });
                                  },
                                ),
                              ),
                            );
                            return;
                          }

                          if (gameField[index] != "") {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(
                                  "This field is already taken.",
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            gameField[index] = currentPlayer;
                          });

                          // Check win
                          bool winGame = false;

                          // Check the rows and colums
                          for (int i = 0; i < 3; i++) {
                            if (gameField[3 * i] == currentPlayer &&
                                gameField[1 + (3 * i)] == currentPlayer &&
                                gameField[2 + (3 * i)] == currentPlayer) {
                              winGame = true;
                            }

                            if (gameField[i] == currentPlayer &&
                                gameField[i + 3] == currentPlayer &&
                                gameField[i + 6] == currentPlayer) {
                              winGame = true;
                            }
                          }

                          // Check from top left to bottom right
                          if (gameField[0] == currentPlayer &&
                              gameField[4] == currentPlayer &&
                              gameField[8] == currentPlayer) {
                            winGame = true;
                          }

                          // Check from bottom left to top right
                          if (gameField[6] == currentPlayer &&
                              gameField[4] == currentPlayer &&
                              gameField[2] == currentPlayer) {
                            winGame = true;
                          }

                          if (winGame) {
                            resetGame(currentPlayer);
                            currentPlayer = startPlayer;
                            return;
                          }

                          if (currentPlayer == "X") {
                            currentPlayer = "O";
                          } else {
                            currentPlayer = "X";
                          }
                        },
                        child: Center(
                          child: Text(
                            gameField[index],
                            style: GoogleFonts.nunito(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (winningPlayer != "")
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.white.withOpacity(0.3),
                          child: Center(
                            child: Text(
                              "$winningPlayer won\nthe game!",
                              style: GoogleFonts.nunito(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetGame(String currentPlayer) {
    setState(() {
      winningPlayer = currentPlayer;
      wins[currentPlayer] = wins[currentPlayer]! + 1;
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        winningPlayer = "";
        for (int i = 0; i < gameField.length; i++) {
          gameField[i] = "";
        }
      });
    });
  }

  BorderRadius getBorderRadiusForTile(int index) {
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(25),
      );
    }

    if (index == 2) {
      return const BorderRadius.only(
        topRight: Radius.circular(25),
      );
    }

    if (index == 6) {
      return const BorderRadius.only(
        bottomLeft: Radius.circular(25),
      );
    }

    if (index == 8) {
      return const BorderRadius.only(
        bottomRight: Radius.circular(25),
      );
    }

    return BorderRadius.circular(0);
  }
}
