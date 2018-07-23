/**************************************************
 * Name: AccountTriggerHandler.cls
 * Description: Handler class for Account trigger
 **************************************************/
public without sharing class AccountTriggerHandler extends BaseTriggerHandler {

  // Custom Exception
  private class CommonException extends Exception {}

  // Constants
  private static final System.loggingLevel LOGGING_LEVEL_DEFAULT = CommonConstants.LOGGING_LEVEL_DEFAULT;
  private static final String CLASS_NAME = AccountTriggerHandler.class.getName();

  // Logger Variable
  private final CommonLogger logger = CommonLogger.getInstance();

  // Class Variables
  private static String methodName;

  // Instance Variables
  public List<Account> oldAccounts;
  public List<Account> newAccounts;
  public Map<Id, Account> oldAccountMap;
  public Map<Id, Account> newAccountMap;

  /*********************************************
   * Name: AccountTriggerHandler
   * Description: Constructor with no parameter
   *
   * @param  null
   * @return AccountTriggerHandler
   *********************************************/
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

  /*******************************
   * Name: addObservers
   * Description: Add observers
   *
   * @param  null
   * @return void
   *******************************/
  protected override void addObservers() {
    methodName = 'addObservers';

     // 要件1. 新規登録時
    System.TriggerOperation[] activeTriggerOperation1 = new System.TriggerOperation[]{};
    activeTriggerOperation1.add(System.TriggerOperation.BEFORE_INSERT);
    this.addObserver(activeTriggerOperation1, (BaseTriggerObserver)AccountTriggerService.getInstance(this));

    // 要件2. 新規登録または更新時
    System.TriggerOperation[] activeTriggerOperation2 = new System.TriggerOperation[]{};
    activeTriggerOperation2.add(System.TriggerOperation.BEFORE_INSERT);
    activeTriggerOperation2.add(System.TriggerOperation.BEFORE_UPDATE);
    this.addObserver(activeTriggerOperation2, (BaseTriggerObserver)AccountTriggerValidation.getInstance(this));
  }

}
