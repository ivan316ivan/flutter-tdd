import 'package:course2/core/util/input_converter.dart';
import 'package:course2/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:course2/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:course2/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:course2/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GetConcreteNumberTrivia>(
      as: #MockGetConcreteNumberTrivia, returnNullOnMissingStub: true),
  MockSpec<GetRandomNumberTrivia>(
      as: #MockGetRandomNumberTrivia, returnNullOnMissingStub: true),
  MockSpec<InputConverter>(
      as: #MockInputConverter, returnNullOnMissingStub: true)
])
void main() {
  final mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  final mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  final mockInputConverter = MockInputConverter();
  final bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter);

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, Empty());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    // test(
    //   'should emit [Error] when the input is invalid',
    //   () async {
    //     // arrange
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Left(InvalidInputFailure()));
    //     // assert later
    //     final expected = [
    //       Empty(),
    //       Error(message: INVALID_INPUT_FAILURE_MESSAGE),
    //     ];
    //     expectLater(bloc.state, emitsInOrder(expected));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );

    // test(
    //   'should get data from the concrete use case',
    //   () async {
    //     // arrange
    //     setUpMockInputConverterSuccess();
    //     when(mockGetConcreteNumberTrivia(any))
    //         .thenAnswer((_) async => Right(tNumberTrivia));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //     await untilCalled(mockGetConcreteNumberTrivia(any));
    //     // assert
    //     verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    //   },
    // );

    // test(
    //   'should emit [Loading, Loaded] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     setUpMockInputConverterSuccess();
    //     when(mockGetConcreteNumberTrivia(any))
    //         .thenAnswer((_) async => Right(tNumberTrivia));
    //     // assert later
    //     final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
    //     expectLater(bloc.state, emitsInOrder(expected));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );
  });
}
