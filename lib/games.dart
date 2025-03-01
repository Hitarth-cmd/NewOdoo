import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:math';

void main() {
  runApp(ElderlyGameApp());
}

class ElderlyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elderly Game Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();
  String selectedGame = '';
  int level = 1;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _speak('Welcome to Elderly Game Hub. Say a game name to start.');
  }

  Future<void> _initializeSpeech() async {
    bool available = await speech.initialize();
    if (!available) {
      _speak('Speech recognition not available.');
    }
  }

  void _speak(String text) async {
    await flutterTts.speak(text);
  }

  void _listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );

      if (available) {
        setState(() => isListening = true);
        speech.listen(onResult: (result) {
          if (result.finalResult) {
            _processCommand(result.recognizedWords.toLowerCase());
          }
        });
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  void _processCommand(String command) {
    if (command.contains('memory match')) {
      _selectGame('Memory Match');
    } else if (command.contains('number puzzle')) {
      _selectGame('Number Puzzle');
    } else if (command.contains('relaxing painting')) {
      _selectGame('Relaxing Painting');
    } else if (command.contains('word search')) {
      _selectGame('Word Search');
    } else if (command.contains('story puzzle')) {
      _selectGame('Story Puzzle');
    } else if (command.contains('next level')) {
      _nextLevel();
    } else if (command.contains('back')) {
      _goBack();
    } else {
      _speak('Sorry, I did not understand that.');
    }
  }

  void _selectGame(String game) {
    setState(() {
      selectedGame = game;
      level = 1;
    });
    _speak('You selected $game. Enjoy playing!');
  }

  void _nextLevel() {
    setState(() {
      level++;
    });
    _speak('Welcome to Level $level');
  }

  void _goBack() {
    setState(() {
      selectedGame = '';
      level = 1;
    });
    _speak('Back to main menu. Say a game name to start.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Elderly Game Hub')),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(isListening ? Icons.mic : Icons.mic_none),
      ),
      body: Center(
        child: selectedGame.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Say a game name to start.', style: TextStyle(fontSize: 24)),
            _gameButton('Memory Match'),
            _gameButton('Number Puzzle'),
            _gameButton('Relaxing Painting'),
            _gameButton('Word Search'),
            _gameButton('Story Puzzle'),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Level $level', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _gameLogic(selectedGame),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextLevel,
              child: Text('Next Level', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _goBack,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Back', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        onPressed: () => _selectGame(title),
        child: Text(title, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget _gameLogic(String game) {
    switch (game) {
      case 'Memory Match':
        return _memoryMatchGame();
      case 'Number Puzzle':
        return _numberPuzzleGame();
      case 'Relaxing Painting':
        return _paintingGame();
      case 'Word Search':
        return _wordSearchGame();
      case 'Story Puzzle':
        return _storyPuzzleGame();
      default:
        return Center(child: Text('Select a game to play.'));
    }
  }

  Widget _memoryMatchGame() {
    List<String> cards = ['🍎', '🍎', '🍌', '🍌', '🍇', '🍇', '🍉', '🍉'];
    cards.shuffle();
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blueAccent,
          child: Center(child: Text(cards[index], style: TextStyle(fontSize: 30))),
        );
      },
    );
  }

  Widget _numberPuzzleGame() {
    int num1 = Random().nextInt(10 * level) + 1;
    int num2 = Random().nextInt(10 * level) + 1;
    return Column(
      children: [
        Text('$num1 + $num2 = ?', style: TextStyle(fontSize: 30)),
        ElevatedButton(
          onPressed: () => _speak('The answer is ${num1 + num2}'),
          child: Text('Show Answer'),
        ),
      ],
    );
  }

  Widget _paintingGame() {
    return Center(child: Text('Say "Start Painting" to begin!', style: TextStyle(fontSize: 24)));
  }

  Widget _wordSearchGame() {
    List<String> words = ['Flutter', 'Dart', 'Game', 'Play', 'Fun'];
    words.shuffle();
    return Column(
      children: words.map((word) => Text(word, style: TextStyle(fontSize: 24))).toList(),
    );
  }

  Widget _storyPuzzleGame() {
    return Text('Say your choice: Go to the forest, Visit the village, or Stay home.', style: TextStyle(fontSize: 22));
  }
}