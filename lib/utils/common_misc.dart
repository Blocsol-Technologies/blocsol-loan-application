enum BankAccountType {
  savings,
  current,
}

extension BankAccountTypeExtension on BankAccountType {
  int get value {
    switch (this) {
      case BankAccountType.savings:
        return 1;
      case BankAccountType.current:
        return 0;
    }
  }
}