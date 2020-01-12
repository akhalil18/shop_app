class HttpException implements Exception {
  final String exceptionMessage;
  HttpException(this.exceptionMessage);

  @override
  String toString() {
    return exceptionMessage;
  }
}
