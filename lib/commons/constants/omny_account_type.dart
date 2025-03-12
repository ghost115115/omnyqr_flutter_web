enum AccountType { init, free, pro, enterprise, gold, business }

List<String> accountType = ['free', 'pro', 'gold', 'enterprise', 'business'];

AccountType getAccountType(String value) {
  switch (value.toLowerCase()) {
    case 'free':
      return AccountType.free;
    case 'pro':
      return AccountType.pro;
    case 'gold':
      return AccountType.gold;
    case 'enterprise':
      return AccountType.enterprise;
    case 'business':
      return AccountType.business;
    default:
      return AccountType.free;
  }
}
