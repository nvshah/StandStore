class HttpException implements Exception{
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    //own implementation of Exception message
    return message;
    //return super.toString();    
  }

}