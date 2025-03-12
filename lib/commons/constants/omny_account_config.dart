import 'package:omnyqr/commons/constants/omny_account_type.dart';

List<String> accountType = ['free', 'pro', 'gold', 'enterprise', 'business'];


// INT HIS FILE WE SET ALL LEVELS PARAMETERS

// DO NOT EDIT

int getAccountReferentsLimit(AccountType value) {
  switch (value) {
    case AccountType.free:
      return 4;
    case AccountType.pro:
      return 8;
    case AccountType.gold:
      return 4;
    case AccountType.enterprise:
      return 1000;
    case AccountType.business:
      return 40;
    default:
      return 4;
  }
}

int getAccountUtilitiesLimit(AccountType value) {
  switch (value) {
    case AccountType.free:
      return 2;
    case AccountType.pro:
      return 4;
    case AccountType.gold:
      return 2;
    case AccountType.enterprise:
      return 1000;
    case AccountType.business:
      return 20;
    default:
      return 2;
  }
}
