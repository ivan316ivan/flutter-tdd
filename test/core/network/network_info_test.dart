import 'package:course2/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Connectivity>(
      as: #MockDataConnectionChecker, returnNullOnMissingStub: true)
])
void main() {
  final mockDataConnectionChecker = MockDataConnectionChecker();
  final networkInfo = NetworkInfoImpl(mockDataConnectionChecker);

  group('Is Connected', () {
    test(
      'should forward the call to DataConnectionChecker',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(ConnectivityResult.wifi);
        when(mockDataConnectionChecker.checkConnectivity())
            .thenAnswer((_) => tHasConnectionFuture);
        // act
        final result = await networkInfo.isConnected;
        // assert
        verify(mockDataConnectionChecker.checkConnectivity());
        expect(result, true);
      },
    );
  });
}
