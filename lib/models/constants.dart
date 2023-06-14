

  import 'package:flutter/services.dart';

 const String INCOMING_CALL = "incoming-call";
  const String REGISTER = "register";
  const String UNREGISTER = "unregister";
  const String OUTGOING_CALL = "outgoing-call";
  const String PAUSE = "pause";
  const String HANG_UP = "hang-up";
  const String DELETE = "delete";
  const String UPDATE_CALL_STATE = "update-call-state";
  const String UPDATE_REGISTRATION_STATE = "update-registration-state";
  const String ACCEPT = "accept";
  const String MUTE = "mute";
  const String SPEAKER_OFF = "speaker-off";
  const String ADJUST_MIC = "adjust-mic";
  const String ADJUST_AUDIO = "adjust-audio";
  const String CALL_TRANFER = "call-tranfer";
  const String ADD_PARTICIPANT = "add-participant";
  const String CREATE_CONFERENCE = "create-conference";
  const String UPDATE_PARTICIPANT_LIST = "update_participant_list";
  const String UPDATE_CONFERENCE_STATE = "update_conference_state";
  const String CHECK_CALLS = "check-calls";
  const String SNOOPING_CALL = "snooping-call";
  const String SEND_MESSAGE = "send-message";
  const String MESSAGE_DELIVERED = "message-delivered";
  const String INCOMING_MESSAGE = "incoming-message";
  const String REQUEST_FETCH_MESSAGE_DATA = "request_fetch_message_data";
  const String CHECK_IN_CALL = "check-in-call";
  const String CHECK_INCOMING_CALL = "check-incoming-call";
  const String REQUSET_UPDATE_FEATURE_ID = "request-update-feature-id";


  MethodChannel callChannel = const MethodChannel("com.example.linphone_sdk/call");

  ///action
  const String GO_TO_CALL_SCREEN = "go-to-call-screen";
  const String GO_TO_MESS_SCREEN = "go-to-mess-screen";

const int INCOMING_MESSAGE_NOTIFICATION_ID = 0;