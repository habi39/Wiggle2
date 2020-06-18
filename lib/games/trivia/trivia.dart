import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Wiggle2/games/trivia/answerScreen.dart';
import 'package:Wiggle2/games/trivia/question.dart';
import 'package:Wiggle2/models/user.dart';
import 'package:Wiggle2/models/wiggle.dart';
import 'package:Wiggle2/services/database.dart';

import '../../models/wiggle.dart';

class Trivia extends StatefulWidget {
  UserData userData;
  List<Wiggle> wiggles;
  Wiggle wiggle;

  Trivia(this.wiggle, this.userData, this.wiggles);
  @override
  _TriviaState createState() => _TriviaState();
}

class _TriviaState extends State<Trivia> {
  int index = 0;
  String currentQuestion;

  List<Questions> questions = [
    Questions(text: 'Pick a card'),
    Questions(text: 'If you could live anywhere, where would it be?'),
    Questions(text: 'What is your biggest fear?'),
    Questions(text: 'What is your favorite family vacation?'),
    Questions(text: 'What would you change about yourself if you could?'),
    Questions(text: 'What really makes you angry?'),
    Questions(text: 'What motivates you to work hard?'),
    Questions(text: 'What is your favorite thing about your career?'),
    Questions(text: 'What is your biggest complaint about your job?'),
    Questions(text: 'What is your proudest accomplishment?'),
    Questions(text: 'What is your favorite book to read?'),
    Questions(text: 'What makes you laugh the most?'),
    Questions(text: 'What was the last movie you went to? What did you think?'),
    Questions(text: 'What did you want to be when you were small?'),
    Questions(text: 'What does your child want to be when he/she grows up?'),
    Questions(
        text:
            'If you could choose to do anything for a day, what would it be?'),
    Questions(text: 'What is your favorite game or sport to watch and play?'),
    Questions(
        text: 'Would you rather ride a bike, ride a horse, or drive a car?'),
    Questions(text: 'What would you sing at Karaoke night?'),
    Questions(
        text: 'What two radio stations do you listen to in the car the most?'),
    Questions(
        text:
            'Which would you rather do: wash dishes, mow the lawn, clean the bathroom, or vacuum the house?'),
    Questions(
        text:
            'If you could hire someone to help you, would it be with cleaning, cooking, or yard work?'),
    Questions(
        text:
            'If you could only eat one meal for the rest of your life, what would it be?'),
    Questions(text: 'Who is your favorite author?'),
    Questions(text: 'Have you ever had a nickname? What is it?'),
    Questions(text: 'Do you like or dislike surprises? Why or why not?'),
    Questions(
        text:
            'In the evening, would you rather play a game, visit a relative, watch a movie, or read?'),
    Questions(text: 'Would you rather vacation in Hawaii or Alaska, and why?'),
    Questions(
        text:
            'Would you rather win the lottery or work at the perfect job? And why?'),
    Questions(
        text: 'Who would you want to be stranded with on a deserted island?'),
    Questions(text: 'If money was no object, what would you do all day?'),
    Questions(
        text: 'If you could go back in time, what year would you travel to?'),
    Questions(text: 'How would your friends describe you?'),
    Questions(text: 'What are your hobbies?'),
    Questions(text: 'What is the best gift you have been given?'),
    Questions(text: 'What is the worst gift you have been given?'),
    Questions(
        text:
            'Aside from necessities, what one thing could you not go a day without?'),
    Questions(text: 'List two pet peeves.'),
    Questions(text: 'Where do you see yourself in five years?'),
    Questions(text: 'How many pairs of shoes do you own?'),
    Questions(text: 'If you were a super-hero, what powers would you have?'),
    Questions(text: 'What would you do if you won the lottery?'),
    Questions(
        text:
            'What form of public transportation do you prefer? (air, boat, train, bus, car, etc.)'),
    Questions(text: 'What is your favorite zoo animal?'),
    Questions(
        text:
            'If you could go back in time to change one thing, what would it be?'),
    Questions(
        text:
            'If you could share a meal with any 4 individuals, living or dead, who would they be?'),
    Questions(text: 'How many pillows do you sleep with?'),
    Questions(
        text: 'What is the longest you\'ve gone without sleep (and why)?'),
    Questions(text: 'What is the tallest building you\'ve been to the top in?'),
    Questions(
        text:
            'Would you rather trade intelligence for looks or looks for intelligence?'),
    Questions(text: 'How often do you buy clothes?'),
    Questions(text: 'Have you ever had a secret admirer?'),
    Questions(text: 'What\'s your favorite holiday?'),
    Questions(text: 'What\'s the most daring thing you\'ve ever done?'),
    Questions(text: 'What was the last thing you recorded on TV?'),
    Questions(text: 'What was the last book you read?'),
    Questions(text: 'What\'s your favorite type of foreign food?'),
    Questions(text: 'Are you a clean or messy person?'),
    Questions(text: 'Who would you want to play you in a movie of your life?'),
    Questions(text: 'How long does it take you to get ready in the morning?'),
    Questions(text: 'What kitchen appliance do you use every day?'),
    Questions(text: 'What\'s your favorite fast food chain?'),
    Questions(text: 'What\'s your favorite family recipe?'),
    Questions(text: 'Do you love or hate rollercoasters?'),
    Questions(text: 'What\'s your favorite family tradition?'),
    Questions(text: 'What is your favorite childhood memory?'),
    Questions(text: 'What\'s your favorite movie?'),
    Questions(
        text:
            'How old were you when you learned Santa wasn\'t real? How did you find out?'),
    Questions(text: 'Is your glass half full or half empty?'),
    Questions(
        text: 'What\'s the craziest thing you’ve done in the name of love?'),
    Questions(
        text: 'What three items would you take with you on a deserted island?'),
    Questions(text: 'What was your favorite subject in school?'),
    Questions(text: 'What\'s the most unusual thing you\'ve ever eaten?'),
    Questions(text: 'Do you collect anything?'),
    Questions(
        text: 'Is there anything you wished would come back into fashion?'),
    Questions(text: 'Are you an introvert or an extrovert?'),
    Questions(
        text: 'Which of the five senses would you say is your strongest?'),
    Questions(
        text:
            'Have you ever had a surprise party? (that was an actual surprise)'),
    Questions(text: 'Are you related or distantly related to anyone famous?'),
    Questions(text: 'What do you do to keep fit?'),
    Questions(text: 'Does your family have a “motto” – spoken or unspoken?'),
    Questions(
        text:
            'If you were ruler of your own country what would be the first law you would introduce?'),
    Questions(text: 'Who was your favorite teacher in school and why?'),
    Questions(text: 'What three things do you think of the most each day?'),
    Questions(text: 'If you had a warning label, what would yours say?'),
    Questions(text: 'What song would you say best sums you up?'),
    Questions(
        text:
            'What celebrity would you like to meet at Starbucks for a cup of coffee?'),
    Questions(text: 'Who was your first crush?'),
    Questions(
        text:
            'What\'s the most interesting thing you can see out of your office or kitchen window?'),
    Questions(text: 'On a scale of 1-10 how funny would you say you are?'),
    Questions(text: 'Where do you see yourself in 10 years?'),
    Questions(text: 'What was your first job?'),
    Questions(
        text:
            'If you could join any past or current music group which would you want to join?'),
    Questions(text: 'How many languages do you speak?'),
    Questions(text: 'What is your favorite family holiday tradition?'),
    Questions(text: 'Who is the most intelligent person you know?'),
    Questions(
        text:
            'If you had to describe yourself as an animal, which one would it be?'),
    Questions(text: 'What is one thing you will never do again?'),
    Questions(text: 'Who knows you the best?'),
  ];

  Widget currentCard;

  generateRandomCard() {
    index = new Random().nextInt(questions.length);
    print(index);
    setState(() {
      currentCard = questionTemplate(index, questions);
    });
    return questionTemplate(index, questions);
  }

  Widget questionTemplate(index, question) {
    this.currentQuestion = question[index].text;
    this.index = index;
    return Padding(
      padding: EdgeInsets.all(30),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: AutoSizeText(
          question[index].text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  getTriviaRoomID(String a, String b) {
    // print(a);
    // print(b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  answerQuestion() {
    DatabaseService().createTriviaRoom(
        getTriviaRoomID(widget.userData.name, widget.wiggle.name),
        widget.userData.name,
        widget.wiggle.name);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnswerScreen(
            wiggles: widget.wiggles,
            userData: widget.userData,
            triviaRoomID: getTriviaRoomID(
                widget.userData.nickname, widget.wiggle.nickname),
            wiggle: widget.wiggle,
            question: this.currentQuestion),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Do I know you?',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(child: currentCard ?? questionTemplate(0, questions)),
          Container(
            child: RaisedButton(
              color: Colors.amber,
              child: Text(
                'Change Card',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                generateRandomCard();
              },
            ),
          ),
          SizedBox(height: 8),
          Container(
            child: RaisedButton(
              color: Colors.amber,
              child: Text(
                'Answer',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                print(widget.wiggle);
                answerQuestion();
              },
            ),
          )
        ],
      ),
    );
  }
}
