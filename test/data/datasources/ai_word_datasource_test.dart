import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:infiltrado/core/api/open_router_client.dart';
import 'package:infiltrado/data/datasources/ai_word_datasource.dart';
import 'package:infiltrado/data/models/word_pair_model.dart';
import 'ai_word_datasource_test.mocks.dart';

@GenerateMocks([OpenRouterClient, Dio])
void main() {
  late MockOpenRouterClient mockClient;
  late MockDio mockDio;
  late AiWordDatasource datasource;

  setUp(() {
    mockClient = MockOpenRouterClient();
    mockDio = MockDio();
    when(mockClient.dio).thenReturn(mockDio);
    datasource = AiWordDatasource(mockClient);
  });

  const tCategory = 'Cinema';
  const tJsonString = '{"civilian": "Filme", "infiltrator": "Pipoca"}';
  const tWordPairModel = WordPairModel(civilian: 'Filme', infiltrator: 'Pipoca');

  test('should return WordPairModel when call is successful', () async {
    // Arrange
    when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'choices': [
            {
              'message': {'content': tJsonString}
            }
          ]
        },
      ),
    );

    // Act
    final result = await datasource.fetchWordPair(tCategory);

    // Assert
    expect(result, tWordPairModel);
  });

  test('should parse JSON even if wrapped in markdown', () async {
    // Arrange
    const tMarkdownContent = 'Sure! Here is the JSON:\n```json\n{"civilian": "Filme", "infiltrator": "Pipoca"}\n```';
    
    when(mockDio.post(any, data: anyNamed('data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'choices': [
            {
              'message': {'content': tMarkdownContent}
            }
          ]
        },
      ),
    );

    // Act
    final result = await datasource.fetchWordPair(tCategory);

    // Assert
    expect(result, tWordPairModel);
  });

  test('should retry 3 times and then throw exception on failure', () async {
    // Arrange
    when(mockDio.post(any, data: anyNamed('data'))).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

    // Act & Assert
    await expectLater(datasource.fetchWordPair(tCategory), throwsException);
    verify(mockDio.post(any, data: anyNamed('data'))).called(3);
  });
}
