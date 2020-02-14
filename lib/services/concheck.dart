
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class ConCheck{

  static Future<bool> checkData() async{

    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi ){
      // I am connected to a network 
      bool result = await DataConnectionChecker().hasConnection;
      if(result == true){
         print("I have Data Connection too");
         return true;

      } else {
        print("I dont have Data Connection"); 
        return false;
      }

    } else if(result == ConnectivityResult.none){
      // I am not connected to a Network
      return false;
    } else {
      return false;
    }

  }


}