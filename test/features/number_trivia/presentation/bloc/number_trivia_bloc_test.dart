import 'package:course2/core/error/failures.dart';
import 'package:course2/core/usecases/usecase.dart';
import 'package:course2/core/util/input_converter.dart';
import 'package:course2/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:course2/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:course2/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:course2/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:course2/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<GetConcreteNumberTrivia>(
      as: #MockGetConcreteNumberTrivia, returnNullOnMissingStub: true),
  MockSpec<GetRandomNumberTrivia>(
      as: #MockGetRandomNumberTrivia, returnNullOnMissingStub: true),
  MockSpec<InputConverter>(
      as: #MockInputConverter, returnNullOnMissingStub: true),
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
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (blocCurrent) => blocCurrent.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (blocCurrent) => blocCurrent.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Loading(), Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data FAILS',
      setUp: () {
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (blocCurrent) => blocCurrent.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data FAILS with a proper message',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (blocCurrent) => blocCurrent.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () =>
          <NumberTriviaState>[Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (blocCurrent) => blocCurrent.add(GetTriviaForRandomNumber()),
      expect: () =>
          <NumberTriviaState>[Loading(), Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data FAILS',
      setUp: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data FAILS with a proper message',
      setUp: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => NumberTriviaBloc(
          getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
          getRandomNumberTrivia: mockGetRandomNumberTrivia,
          inputConverter: mockInputConverter),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () =>
          <NumberTriviaState>[Loading(), Error(message: CACHE_FAILURE_MESSAGE)],
    );
  });
}
