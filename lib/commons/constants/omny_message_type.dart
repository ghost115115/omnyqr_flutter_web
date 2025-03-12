// DO NOT EDIT OR DELETE THIS FILE

enum MsgType { init, message, invitation, reminder, unavailableInvitation }

MsgType getMessageType(String value) {
  switch (value.toUpperCase()) {
    case 'MESSAGE':
      return MsgType.message;
    case 'INVITATION':
      return MsgType.invitation;
    case 'REMINDER':
      return MsgType.reminder;
    case 'UNAVAILABLE_INVITATION':
      return MsgType.unavailableInvitation;
    default:
      return MsgType.init;
  }
}
