public with sharing class AccountTriggerValidation implements BaseTriggerObserver {

  // Constants
  private static final System.LoggingLevel LOGGING_LEVEL_DEFAULT = LoggingLevel.DEBUG;  // TODO: カスタム設定で設定
  private static final String CLASS_NAME = AccountTriggerValidation.class.getName();
  private static final String ERROR_MESSAGE_PHONE_REQUIRED = AccountConstants.ERROR_MESSAGE_PHONE_REQUIRED;

  private List<Account> oldAccounts;
  private List<Account> newAccounts;
  private Map<Id, Account> oldAccountMap;
  private Map<Id, Account> newAccountMap;

  public AccountTriggerValidation(AccountTriggerHandler accountTriggerHandler) {
    this.oldAccounts = accountTriggerHandler.oldAccounts;
    this.newAccounts = accountTriggerHandler.newAccounts;
    this.oldAccountMap = accountTriggerHandler.oldAccountMap;
    this.newAccountMap = accountTriggerHandler.newAccountMap;
  }

  public void onBeforeInsert() {
    System.debug(LoggingLevel.DEBUG, 'AccountTriggerValidation onBeforeInsert');
    this.validatePhone(newAccounts);
  }

  public void onBeforeUpdate() {
    System.debug(LoggingLevel.DEBUG, 'AccountTriggerValidation onBeforeUpdate');
    this.validatePhone(newAccounts);
  }

  public void onBeforeDelete() {}
  public void onAfterInsert() {}
  public void onAfterUpdate() {}
  public void onAfterDelete() {}
  public void onAfterUndelete() {}

  private void validatePhone(List<Account> newAccounts) {
    for (Account a : newAccounts) {
      Boolean hasFax = String.isNotEmpty(a.Fax);
      Boolean hasPhone = String.isNotEmpty(a.Phone);

      System.debug(LoggingLevel.DEBUG, 'hasFax: ' + hasFax);
      System.debug(LoggingLevel.DEBUG, 'hasPhone: ' + hasPhone);

      if (hasFax && !hasPhone) {
        // a.addError(ERROR_MESSAGE_PHONE_REQUIRED);
        a.Phone.addError(ERROR_MESSAGE_PHONE_REQUIRED);
      }
    }
  }

}
