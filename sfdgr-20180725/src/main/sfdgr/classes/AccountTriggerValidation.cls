public with sharing class AccountTriggerValidation implements BaseTriggerObserver {

  // Custom Exception
  private class AccountTriggerValidationException extends Exception {}

  // Constants
  private static final String CLASS_NAME = AccountTriggerValidation.class.getName();
  private static final System.loggingLevel LOGGING_LEVEL_DEFAULT = CommonConstants.LOGGING_LEVEL_DEFAULT;
  private static final String ERROR_MESSAGE_PHONE_REQUIRED = AccountConstants.ERROR_MESSAGE_PHONE_REQUIRED;

  // Logger Variable
  private final CommonLogger logger = CommonLogger.getInstance();

  // Class Fields
  private static String methodName;

  // Instance Fields
  private AccountTriggerHandler handler;

  public AccountTriggerValidation(AccountTriggerHandler handler) {
    methodName = 'AccountTriggerValidation';

    this.handler = handler;
  }

  public void onBeforeInsert() {
    methodName = 'onBeforeInsert';

    this.validatePhone(handler.newAccounts);
  }

  public void onBeforeUpdate() {
    methodName = 'onBeforeUpdate';

    this.validatePhone(handler.newAccounts);
  }

  public void onBeforeDelete() {}
  public void onAfterInsert() {}
  public void onAfterUpdate() {}
  public void onAfterDelete() {}
  public void onAfterUndelete() {}

  private void validatePhone(List<Account> newAccounts) {
    methodName = 'validatePhone';

    for (Account a : newAccounts) {
      Boolean hasFax = String.isNotEmpty(a.Fax);
      Boolean hasPhone = String.isNotEmpty(a.Phone);

      logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'hasFax: ' + hasFax);
      logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'hasPhone: ' + hasPhone);

      if (hasFax && !hasPhone) {
        // a.addError(ERROR_MESSAGE_PHONE_REQUIRED);
        a.Phone.addError(ERROR_MESSAGE_PHONE_REQUIRED);
        throw new AccountTriggerValidationException(ERROR_MESSAGE_PHONE_REQUIRED);
      }
    }
  }

}
