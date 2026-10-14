import 'package:dio/dio.dart';
import 'package:rfid/core/error/exceptions.dart';
import 'package:rfid/core/error/failure.dart';
import 'package:rfid/core/error/result.dart';
import 'package:rfid/core/network/api_envelope_parser.dart';

/// The only place where exceptions become failures.
Future<Result<T>> guard<T>(Future<T> Function() request) async {
  try {
    return Success(await request());
  } on DioException catch (error) {
    return Failed(failureFromDioException(error));
  } on ApiException catch (error) {
    return Failed(
      ServerFailure(message: error.message, statusCode: error.statusCode),
    );
  } on RfidException catch (error) {
    return Failed(RfidFailure(error.reason, details: error.details));
  } on FormatException catch (error) {
    return Failed(ParsingFailure(error.message));
  } on TypeError catch (error) {
    return Failed(ParsingFailure(error.toString()));
  } catch (error) {
    return Failed(UnexpectedFailure(error.toString()));
  }
}

Failure failureFromDioException(DioException error) {
  final response = error.response;
  if (response == null) return const NetworkFailure();

  final message = ApiEnvelopeParser.messageOf(response.data);
  if (response.statusCode == 401) return UnauthorizedFailure(message: message);
  return ServerFailure(message: message, statusCode: response.statusCode);
}
