

import 'package:flutter/cupertino.dart';

class CallStatusProvider extends ChangeNotifier{

      String? _registation_state;


      String? _call_State;
      String? _callerID;
      String? _callerChannel;

      String? get call_State => _call_State;

      String? get registation_state => _registation_state;

      String? get callerID => _callerID;

      String? get callerChannel => _callerChannel;


      void updateCallerID(String newCallerID){
            _callerID = newCallerID;
            notifyListeners();
      }

      void updateRegistation(String newRegistation){
            _registation_state = newRegistation;
            notifyListeners();
      }

      void updateCallState(String newCalleState){
            _call_State = newCalleState;
            notifyListeners();
      }

      void updateCallerChannel(String newCallerChannel){
            _callerChannel = newCallerChannel;
            notifyListeners();
      }
}