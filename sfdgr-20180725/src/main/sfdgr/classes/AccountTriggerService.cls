public with sharing class AccountTriggerService implements BaseTriggerObserver {

  // Constants
  private static final System.LoggingLevel LOGGING_LEVEL_DEFAULT = LoggingLevel.DEBUG;  // TODO: カスタム設定で設定
  private static final String CLASS_NAME = AccountTriggerService.class.getName();
  private static final String NAME_PREFIX_SAMPLE = AccountConstants.NAME_PREFIX_SAMPLE;

  private List<Account> oldAccounts;
  private List<Account> newAccounts;
  private Map<Id, Account> oldAccountMap;
  private Map<Id, Account> newAccountMap;

  public AccountTriggerService(AccountTriggerHandler accountTriggerHandler) {
    this.oldAccounts = accountTriggerHandler.oldAccounts;
    this.newAccounts = accountTriggerHandler.newAccounts;
    this.oldAccountMap = accountTriggerHandler.oldAccountMap;
    this.newAccountMap = accountTriggerHandler.newAccountMap;
  }

  public void onBeforeInsert() {
    System.debug(LoggingLevel.DEBUG, 'AccountTriggerService onBeforeInsert');
    this.addPrefixToName(newAccounts);
  }

  public void onBeforeUpdate() {}
  public void onBeforeDelete() {}
  public void onAfterInsert() {}
  public void onAfterUpdate() {}
  public void onAfterDelete() {}
  public void onAfterUndelete() {}

  private void addPrefixToName(List<Account> newAccounts) {
    for (Account a : newAccounts) {
      System.debug(LoggingLevel.DEBUG, 'a.Name: ' + a.Name);
      a.Name = NAME_PREFIX_SAMPLE + a.Name;
      System.debug(LoggingLevel.DEBUG, 'a.Name: ' + a.Name);
    }
  }

}
