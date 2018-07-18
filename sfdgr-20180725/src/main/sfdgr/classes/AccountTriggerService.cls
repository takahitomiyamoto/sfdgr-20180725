public with sharing class AccountTriggerService implements BaseTriggerObserver {

  // Custom Exception
  private class CommonException extends Exception {}

  // Constants
  private static final String CLASS_NAME = AccountTriggerService.class.getName();
  private static final System.loggingLevel LOGGING_LEVEL_DEFAULT = CommonConstants.LOGGING_LEVEL_DEFAULT;
  private static final String NAME_PREFIX_SAMPLE = AccountConstants.NAME_PREFIX_SAMPLE;

  // Logger Variable
  private final CommonLogger logger = CommonLogger.getInstance();

  // Class Fields
  private static String methodName;

  // Instance Fields
  private AccountTriggerHandler handler;

  public AccountTriggerService(AccountTriggerHandler handler) {
    methodName = 'AccountTriggerService';

    this.handler = handler;
  }

  public void onBeforeInsert() {
    methodName = 'onBeforeInsert';

    this.addPrefixToName(handler.newAccounts);
  }

  public void onBeforeUpdate() {}
  public void onBeforeDelete() {}
  public void onAfterInsert() {}
  public void onAfterUpdate() {}
  public void onAfterDelete() {}
  public void onAfterUndelete() {}

  private void addPrefixToName(List<Account> newAccounts) {
    methodName = 'addPrefixToName';

    for (Account a : newAccounts) {
      a.Name = NAME_PREFIX_SAMPLE + a.Name;
      logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'Name: ' + a.Name);
    }
  }

}
