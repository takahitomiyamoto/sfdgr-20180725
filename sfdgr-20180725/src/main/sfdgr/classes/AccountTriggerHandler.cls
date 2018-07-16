public without sharing class AccountTriggerHandler extends BaseTriggerHandler {

  public List<Account> oldAccounts;
  public List<Account> newAccounts;
  public Map<Id, Account> oldAccountMap;
  public Map<Id, Account> newAccountMap;

  public AccountTriggerHandler() {
    super();
    System.debug(LoggingLevel.DEBUG, 'Trigger.isExecuting: ' + this.triggerIsExecuting);
    System.debug(LoggingLevel.DEBUG, 'Trigger.size: ' + this.triggerSize);
    System.debug(LoggingLevel.DEBUG, 'Trigger.TriggerOperation: ' + this.TriggerOperationType);
    this.oldAccounts = (List<Account>)this.oldObjects;
    this.newAccounts = (List<Account>)this.newObjects;
    this.oldAccountMap = (Map<Id, Account>)this.oldObjectMap;
    this.newAccountMap = (Map<Id, Account>)this.newObjectMap;
  }

  protected override void addObservers() {
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

  protected override void onBeforeInsert() {
    System.debug(LoggingLevel.DEBUG, 'AccountTriggerHandler onBeforeInsert');

    System.debug(LoggingLevel.DEBUG, 'firstRun: ' + firstRun);
    if (!firstRun) {
      return;
    }

    for (BaseTriggerObserver triggerObserver : beforeInsertObservers) {
      triggerObserver.onBeforeInsert();
    }
  }

  protected override void onBeforeUpdate() {
    System.debug(LoggingLevel.DEBUG, 'AccountTriggerHandler onBeforeUpdate');

    System.debug(LoggingLevel.DEBUG, 'firstRun: ' + firstRun);
    if (!firstRun) {
      return;
    }

    for (BaseTriggerObserver triggerObserver : beforeUpdateObservers) {
      triggerObserver.onBeforeUpdate();
    }
  }

  protected override void onBeforeDelete() {}
  protected override void onAfterInsert() {}
  protected override void onAfterUpdate() {}
  protected override void onAfterDelete() {}
  protected override void onAfterUndelete() {}

}
