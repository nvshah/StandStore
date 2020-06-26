class HttpException implements Exception{
  final String message;

  HttpException(this.message);
  
  //Inorder to show custom message need to overrdie the toString()
  @override
  String toString() {
    //own implementation of Exception message
    return message;
    //return super.toString();    
  }

}