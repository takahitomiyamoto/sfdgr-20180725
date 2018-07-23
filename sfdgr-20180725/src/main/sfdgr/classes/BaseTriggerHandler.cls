/**************************************************
 * Name: BaseTriggerHandler.cls
 * Description: Base class for all triggers
 **************************************************/
public abstract class BaseTriggerHandler {

  // Custom Exception
  private class CommonException extends Exception {}

  // Constants
  private static final String CLASS_NAME = BaseTriggerHandler.class.getName();
  private static final System.loggingLevel LOGGING_LEVEL_DEFAULT = CommonConstants.LOGGING_LEVEL_DEFAULT;

  // Logger Variable
  private final CommonLogger logger = CommonLogger.getInstance();

  // Class Variables
  private static String methodName;
  public static Boolean firstRun = true;

  // Instance Variables
  protected List<SObject> oldObjects;
  protected List<SObject> newObjects;
  protected Map<Id, SObject> oldObjectMap;
  protected Map<Id, SObject> newObjectMap;
  protected Boolean triggerIsExecuting;
  protected Integer triggerSize;
  protected System.TriggerOperation triggerOperationType;
  protected List<BaseTriggerObserver> beforeInsertObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> beforeUpdateObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> beforeDeleteObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterInsertObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterUpdateObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterDeleteObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterUndeleteObservers = new List<BaseTriggerObserver>();

  // Abstract Methods
  protected abstract void addObservers();

  /**************************************************
   * Name: BaseTriggerHandler
   * Description: Constructor with no parameter
   *
   * @param  none
   * @return BaseTriggerHandler
   **************************************************/
  public BaseTriggerHandler() {
    methodName = 'BaseTriggerHandler';

    this.oldObjects = Trigger.old;
    this.newObjects = Trigger.new;
    this.oldObjectMap = Trigger.oldMap;
    this.newObjectMap = Trigger.newMap;
    this.triggerIsExecuting = Trigger.isExecuting;
    this.triggerSize = Trigger.size;
    this.triggerOperationType = Trigger.operationType;
  }

  /************************************************************
   * Name: isRecursive
   * Description: Validate whether this is recursive or not
   *
   * @param  none
   * @return Boolean
   ************************************************************/
  public Boolean isRecursive() {
    methodName = 'isRecursive';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'firstRun: ' + BaseTriggerHandler.firstRun);

    if (BaseTriggerHandler.firstRun) {
      return false;
    } else {
      return true;
    }
  }

  /********************************************************************************
   * Name: invoke
   * Description: Invoke each custom action depending on the Apex DML operations
   *
   * @param  none
   * @return void
   ********************************************************************************/
  public void invoke() {
    methodName = 'invoke';

    System.Savepoint savepoint = System.Database.setSavepoint();
    try {
      if (this.isRecursive()) {
        return;
      }

      this.addObservers();

      switch on Trigger.operationType {
        when BEFORE_INSERT {
          this.onBeforeInsert();
        }
        when BEFORE_UPDATE {
          this.onBeforeUpdate();
        }
        when BEFORE_DELETE {
          this.onBeforeDelete();
        }
        when AFTER_INSERT {
          this.onAfterInsert();
          BaseTriggerHandler.firstRun = false;
        }
        when AFTER_UPDATE {
          this.onAfterUpdate();
          BaseTriggerHandler.firstRun = false;
        }
        when AFTER_DELETE {
          this.onAfterDelete();
          BaseTriggerHandler.firstRun = false;
        }
        // AFTER_UNDELETE
        when else {
          this.onAfterUndelete();
          BaseTriggerHandler.firstRun = false;
        }
      }
    } catch (Exception e) {
      Database.rollback(savepoint);
      logger.stackDebugLog(LoggingLevel.ERROR, CLASS_NAME, methodName, CommonErrorUtils.createErrorMessage(e));
    } finally {
      logger.fetchDebugLogs();
    }
  }

  /************************************************************
   * Name: addObserver
   * Description: Add an observer
   *
   * @param  List<System.TriggerOperation> triggerOperations
   * @param  BaseTriggerObserver triggerObserver
   * @return void
   ************************************************************/
  public void addObserver(List<System.TriggerOperation> triggerOperations, BaseTriggerObserver triggerObserver){
    methodName = 'addObserver';

    for (System.TriggerOperation triggerOperation : triggerOperations) {
      switch on triggerOperation {
        when BEFORE_INSERT {
          beforeInsertObservers.add(triggerObserver);
        }
        when BEFORE_UPDATE {
          beforeUpdateObservers.add(triggerObserver);
        }
        when BEFORE_DELETE {
          beforeDeleteObservers.add(triggerObserver);
        }
        when AFTER_INSERT {
          afterInsertObservers.add(triggerObserver);
        }
        when AFTER_UPDATE {
          afterUpdateObservers.add(triggerObserver);
        }
        when AFTER_DELETE {
          afterDeleteObservers.add(triggerObserver);
        }
        // AFTER_UNDELETE
        when else {
          afterUndeleteObservers.add(triggerObserver);
        }
      }
    }
  }

  /*******************************************************
   * Name: onBeforeInsert
   * Description: Custom action in case of before insert
   *
   * @param  null
   * @return void
   ********************************************************/
  private void onBeforeInsert() {
    methodName = 'onBeforeInsert';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'beforeInsertObservers: ' + beforeInsertObservers.size());

    for (BaseTriggerObserver triggerObserver : beforeInsertObservers) {
      triggerObserver.onBeforeInsert();
    }
  }

  /*******************************************************
   * Name: onBeforeUpdate
   * Description: Custom action in case of before update
   *
   * @param  null
   * @return void
   ********************************************************/
  private void onBeforeUpdate() {
    methodName = 'onBeforeUpdate';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'beforeUpdateObservers: ' + beforeUpdateObservers.size());

    for (BaseTriggerObserver triggerObserver : beforeUpdateObservers) {
      triggerObserver.onBeforeUpdate();
    }
  }

  /*******************************************************
   * Name: onBeforeDelete
   * Description: Custom action in case of before delete
   *
   * @param  null
   * @return void
   ********************************************************/
  private void onBeforeDelete() {
    methodName = 'onBeforeDelete';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'beforeDeleteObservers: ' + beforeDeleteObservers.size());

    for (BaseTriggerObserver triggerObserver : beforeDeleteObservers) {
      triggerObserver.onBeforeDelete();
    }
  }

  /*******************************************************
   * Name: onAfterInsert
   * Description: Custom action in case of after insert
   *
   * @param  null
   * @return void
   ********************************************************/
  private void onAfterInsert() {
    methodName = 'onAfterInsert';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterInsertObservers: ' + afterInsertObservers.size());

    for (BaseTriggerObserver triggerObserver : afterInsertObservers) {
      triggerObserver.onAfterInsert();
    }
  }

  /*******************************************************
   * Name: onAfterUpdate
   * Description: Custom action in case of after update
   *
   * @param  null
   * @return void
   ********************************************************/
  private void onAfterUpdate() {
    methodName = 'onAfterUpdate';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterUpdateObservers: ' + afterUpdateObservers.size());

    for (BaseTriggerObserver triggerObserver : afterUpdateObservers) {
      triggerObserver.onAfterUpdate();
    }
  }

  /*******************************************************
   * Name: onAfterDelete
   * Description: Custom action in case of after delete
   *
   * @param  null
   * @return void
   * @deprecated
   ********************************************************/
  private void onAfterDelete() {
    methodName = 'onAfterDelete';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterDeleteObservers: ' + afterDeleteObservers.size());

    for (BaseTriggerObserver triggerObserver : afterDeleteObservers) {
      triggerObserver.onAfterDelete();
    }
  }

  /*******************************************************
   * Name: onAfterUndelete
   * Description: Custom action in case of after undelete
   *
   * @param  null
   * @return void
   * @deprecated
   ********************************************************/
  private void onAfterUndelete() {
    methodName = 'onAfterUndelete';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterUndeleteObservers: ' + afterUndeleteObservers.size());

    for (BaseTriggerObserver triggerObserver : afterUndeleteObservers) {
      triggerObserver.onAfterUndelete();
    }
  }

}
