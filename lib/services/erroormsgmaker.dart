class ErrorMsgMaker {
  static String msgMaker({String error}) {
    var emsg = "Something went Wrong Please Try Again!";

    if (error.contains('ERROR_INVALID_EMAIL'))
      emsg = 'The Entered Email Address Format is not valid';
    if (error.contains('ERROR_WRONG_PASSWORD'))
      emsg = 'The Entered Password is incorrect';
    if (error.contains('ERROR_NETWORK_REQUEST_FAILED'))
      emsg = 'Unable to connect to Internet Please Try Again...';
    if (error.contains('ERROR_INVALID_EMAIL'))
      emsg = 'The Entered Email Address Format is not valid';

    print('Error Msg sended by msgMaker is $emsg');
    return emsg; //+ "  =>  $error";
  }
}
