import 'package:course2/core/error/exceptions.dart';
import 'package:course2/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:course2/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient, returnNullOnMissingStub: true)
])
void main() {
  final mockHttpClient = MockHttpClient();
  final dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''
      Should perform a GET request on a url with:
      - number being the endpoint
      - aplication/json the header
      ''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      '''
      Should perform a GET request on a url with:
      - number being the endpoint
      - aplication/json the header
      ''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
