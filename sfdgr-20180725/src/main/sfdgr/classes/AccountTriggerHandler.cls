public without sharing class AccountTriggerHandler extends BaseTriggerHandler {

  // Custom Exception
  private class AccountTriggerHandlerException extends Exception {}

  // Constants
  private static final String CLASS_NAME = AccountTriggerHandler.class.getName();
  private static final System.loggingLevel LOGGING_LEVEL_DEFAULT = CommonConstants.LOGGING_LEVEL_DEFAULT;

  // Logger Variable
  private final CommonLogger logger = CommonLogger.getInstance();

  // Class Fields
  private static String methodName;

  // Instance Fields
  public List<Account> oldAccounts;
  public List<Account> newAccounts;
  public Map<Id, Account> oldAccountMap;
  public Map<Id, Account> newAccountMap;

  public AccountTriggerHandler() {
    super();
    methodName = 'AccountTriggerHandler';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'Trigger.isExecuting: ' + this.triggerIsExecuting);
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'Trigger.size: ' + this.triggerSize);
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'Trigger.TriggerOperation: ' + this.TriggerOperationType);
    this.oldAccounts = (List<Account>)this.oldObjects;
    this.newAccounts = (List<Account>)this.newObjects;
    this.oldAccountMap = (Map<Id, Account>)this.oldObjectMap;
    this.newAccountMap = (Map<Id, Account>)this.newObjectMap;
  }

  protected override void addObservers() {
    methodName = 'addObservers';

     // 要件1. 　新規登録時に取引先名(Name)項目の先頭に[サンプル]という文字列を付ける。
    System.TriggerOperation[] activeTriggerOperation1 = new System.TriggerOperation[]{};
    activeTriggerOperation1.add(System.TriggerOperation.BEFORE_INSERT);
    this.addObserver(activeTriggerOperation1, (BaseTriggerObserver)new AccountTriggerService(this));

    // 要件2. 　新規登録または更新時にFax(FAX)項目に値が入っており、かつ電話(Phone)項目に値が入っていない場合は「FAXが入っている場合は電話番号も入力してください」というエラーにする。
    System.TriggerOperation[] activeTriggerOperation2 = new System.TriggerOperation[]{};
    activeTriggerOperation2.add(System.TriggerOperation.BEFORE_INSERT);
    activeTriggerOperation2.add(System.TriggerOperation.BEFORE_UPDATE);
    this.addObserver(activeTriggerOperation2, (BaseTriggerObserver)new AccountTriggerValidation(this));
  }

}
