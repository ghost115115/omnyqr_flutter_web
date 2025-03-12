enum GeneralStatus {
  init,
  acepted,
  accountDeleted,
  accountDisabled,
  accountNotActive,
  authenticated,
  authenticationError,
  authWrongCrendential,
  complete,
  emailAlreadyInUse,
  error,
  invalidCredential,
  loaded,
  loading,
  logoutUser,
  networkError,
  notFound,
  pushSent,
  refused,
  sending,
  showQr,
  success,
  updateError,
  updateSuccess,
  wrongEmail,
  wrongPosition
}

GeneralStatus getStatus(String? value) {
  switch (value) {
    case 'init':
      return GeneralStatus.init;
    case 'acepted':
      return GeneralStatus.acepted;
    case 'accountDeleted':
      return GeneralStatus.accountDeleted;
    case 'accountDisabled':
      return GeneralStatus.accountDisabled;
    case 'accountNotActive':
      return GeneralStatus.accountNotActive;
    case 'authenticated':
      return GeneralStatus.authenticated;
    case 'authWrongCrendential':
      return GeneralStatus.authWrongCrendential;
    case 'complete':
      return GeneralStatus.complete;
    case 'emailAlreadyInUse':
      return GeneralStatus.emailAlreadyInUse;
    case 'error':
      return GeneralStatus.error;
    case 'enterprise':
      return GeneralStatus.invalidCredential;
    case 'loaded':
      return GeneralStatus.loaded;
    case 'loading':
      return GeneralStatus.loading;
    case 'logoutUser':
      return GeneralStatus.logoutUser;
    case 'networkError':
      return GeneralStatus.networkError;
    case 'notFound':
      return GeneralStatus.notFound;
    case 'pushSent':
      return GeneralStatus.pushSent;
    case 'refused':
      return GeneralStatus.refused;
    case 'sending':
      return GeneralStatus.sending;
    case 'showQr':
      return GeneralStatus.showQr;
    case 'success':
      return GeneralStatus.success;
    case 'updateError':
      return GeneralStatus.updateError;
    case 'updateSuccess':
      return GeneralStatus.updateSuccess;
    case 'wrongEmail':
      return GeneralStatus.wrongEmail;
    case 'wrongPosition':
      return GeneralStatus.wrongPosition;
    default:
      return GeneralStatus.error;
  }
}
