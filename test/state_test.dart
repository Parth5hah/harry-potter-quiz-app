import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_app/models/state.dart';
import 'package:test/test.dart';
import 'state_test.mocks.dart';
import 'questions.dart';

@GenerateMocks([http.Client])
void main() {

  final client = MockClient();

  when(client.get(Uri.parse('https://stevecassidy.github.io/harry-potter-quiz-app/lib/data/questions.json')))
    .thenAnswer((_) async => http.Response(jsonEncode(questionsJson), 200));

  var testState = StateModel(client);
  test('State model returns quiz questions', () {
    testState.addListener(() {
      expect(testState.questions.length, 6);
      expect(testState.getCurrentQuestion().questionText, startsWith("What"));
    });
  });

  test('State model advances to next question', () {
    testState.addListener(() {
      var temp = testState.currentQuestionNumber;
      if (temp >= 0) {
        testState.advanceQuestion();
        expect(testState.currentQuestionNumber, temp + 1);
      }
    });
  });

  test('addAnswer adds an answer', () {
    testState.addListener(() {
      testState.addAnswer('answer');
      expect(testState.answers[testState.currentQuestionNumber], ['answer']);
    });
  });

  test('currentQuestionNumber gets the current question number', () {
    testState.addListener(() {
      expect(testState.currentQuestionNumber, testState.currentQuestion + 1);
    });
  });

  test('getSummaryData gets the summary data', () {
    testState.addListener(() {
      expect(testState.currentQuestionNumber, testState.currentQuestion + 1);
    });
  });
}