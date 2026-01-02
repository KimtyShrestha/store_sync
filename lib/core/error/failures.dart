abstract class Failure {
  final String message;
  const Failure(this.message);
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(super.message);
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure(super.message, {this.statusCode});
}
