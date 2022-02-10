import 'package:course2/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  ///
  /// SHOULD ACTUALLY BE [<NUMBER TRIVIA>]
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  ///
  /// SHOULD ACTUALLY BE [<NUMBER TRIVIA>]
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
