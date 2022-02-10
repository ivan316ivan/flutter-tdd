import 'package:course2/core/platform/network_info.dart';
import 'package:course2/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:course2/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:course2/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

// class MockRemoteDataSource extends Mock
//     implements NumberTriviaRemoteDataSource {}

// class MockLocalDataSource extends Mock
//     implements NumberTriviaLocalDataSource {}

// class MockNetworkInfo extends Mock
//     implements NetworkInfo {}
@GenerateMocks([], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(
      as: #MockRemoteDataSource, returnNullOnMissingStub: true),
  MockSpec<NumberTriviaLocalDataSource>(
      as: #MockLocalDataSource, returnNullOnMissingStub: true),
  MockSpec<NetworkInfo>(as: #MockNetworkInfo, returnNullOnMissingStub: true)
])
void main() {
  final mockRemoteDataSource = MockRemoteDataSource();
  final mockLocalDataSource = MockLocalDataSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo);
}
