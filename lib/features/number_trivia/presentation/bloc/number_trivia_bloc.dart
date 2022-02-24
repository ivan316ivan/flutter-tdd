import 'package:bloc/bloc.dart';
import 'package:course2/core/util/input_converter.dart';
import 'package:course2/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:course2/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:course2/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {

      @override
      Stream<NumberTriviaState> mapEventToState(
        NumberTriviaEvent event,
      ) async* {
        if (event is GetTriviaForConcreteNumber) {
          final inputEither =
              inputConverter.stringToUnsignedInteger(event.numberString);

          yield* inputEither.fold((failure) async* {
            yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
          }, (integer) => throw UnimplementedError());
        }
      }
      
    });
  }
}
