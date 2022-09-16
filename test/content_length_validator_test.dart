import 'package:content_length_validator/content_length_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Shelf: ', () {
    group('Default values: ', () {
      test('Should return status code 200 and "Hello from /"', () async {
        final handler = const Pipeline()
            .addMiddleware(maxContentLengthValidator())
            .addHandler(syncHandler);
        final response = await makePostRequest(handler);
        expect(response.statusCode, 200);
        expect(response.readAsString(), completion('Hello from /'));
      });

      test(
          'Should return status code 200 and "Hello from /" if content length is < 999',
          () async {
        final handler = const Pipeline()
            .addMiddleware(maxContentLengthValidator())
            .addHandler(syncHandler);
        final response =
            await makePostRequest(handler, headers: {'content-length': '999'});
        expect(response.statusCode, 200);
        expect(response.readAsString(), completion('Hello from /'));
      });

      test('Should return status code 400 and "Invalid payload; too big',
          () async {
        final handler = const Pipeline()
            .addMiddleware(maxContentLengthValidator())
            .addHandler(syncHandler);
        final response =
            await makePostRequest(handler, headers: {'content-length': '1000'});
        expect(response.statusCode, 400);
        expect(response.readAsString(), completion('Invalid payload; too big'));
      });
    });
    test('Should return custom set error code 418 if the payload is to big',
        () async {
      final handler = const Pipeline()
          .addMiddleware(maxContentLengthValidator(errorStatus: 418))
          .addHandler(syncHandler);
      final response =
          await makePostRequest(handler, headers: {'content-length': '1000'});
      expect(response.statusCode, 418);
      expect(response.readAsString(), completion('Invalid payload; too big'));
    });
    test('Should return 400 at a content-length of 5', () async {
      final handler = const Pipeline()
          .addMiddleware(maxContentLengthValidator(maxContentLength: 4))
          .addHandler(syncHandler);
      final response =
          await makePostRequest(handler, headers: {'content-length': '5'});
      expect(response.statusCode, 400);
      expect(response.readAsString(), completion('Invalid payload; too big'));
    });
    test('Should return a custom response if the content-length is too big',
        () async {
      final handler = const Pipeline()
          .addMiddleware(maxContentLengthValidator(errorMessage: 'Hello World'))
          .addHandler(syncHandler);
      final response =
          await makePostRequest(handler, headers: {'content-length': '1000'});
      expect(response.statusCode, 400);
      expect(response.readAsString(), completion('Hello World'));
    });
  });
}
