public abstract class BaseTriggerHandler {

  // Custom Exception
  private class BaseTriggerHandlerException extends Exception {}

  // Constants
  private static final String CLASS_NAME = BaseTriggerHandler.class.getName();
  private static final System.loggingLevel LOGGING_LEVEL_DEFAULT = CommonConstants.LOGGING_LEVEL_DEFAULT;

  // Logger Variable
  private final CommonLogger logger = CommonLogger.getInstance();

  // Class Fields
  private static String methodName;
  public static Boolean firstRun = true;

  // Instance Fields
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
  protected abstract void addObservers();

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

  public static Boolean isRecursive() {
    System.debug(LOGGING_LEVEL_DEFAULT, 'firstRun: ' + BaseTriggerHandler.firstRun);

    if (BaseTriggerHandler.firstRun) {
      BaseTriggerHandler.firstRun = false;
      return false;
    } else {
      return true;
    }
  }

  public void invoke() {
    methodName = 'invoke';

    System.Savepoint savepoint = System.Database.setSavepoint();
    try {
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
        }
        when AFTER_UPDATE {
          this.onAfterUpdate();
        }
        when AFTER_DELETE {
          this.onAfterDelete();
        }
        // AFTER_UNDELETE
        when else {
          this.onAfterUndelete();
        }
      }
    } catch (Exception e) {
      Database.rollback(savepoint);
      logger.stackDebugLog(LoggingLevel.ERROR, CLASS_NAME, methodName, CommonErrorUtils.createErrorMessage(e));
    } finally {
      logger.fetchDebugLogs();
    }
  }

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

  private void onBeforeInsert() {
    methodName = 'onBeforeInsert';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'beforeInsertObservers: ' + beforeInsertObservers.size());

    for (BaseTriggerObserver triggerObserver : beforeInsertObservers) {
      triggerObserver.onBeforeInsert();
    }
  }

  private void onBeforeUpdate() {
    methodName = 'onBeforeUpdate';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'beforeUpdateObservers: ' + beforeUpdateObservers.size());

    for (BaseTriggerObserver triggerObserver : beforeUpdateObservers) {
      triggerObserver.onBeforeUpdate();
    }
  }

  private void onBeforeDelete() {
    methodName = 'onBeforeDelete';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'beforeDeleteObservers: ' + beforeDeleteObservers.size());

    for (BaseTriggerObserver triggerObserver : beforeDeleteObservers) {
      triggerObserver.onBeforeDelete();
    }
  }

  private void onAfterInsert() {
    methodName = 'onAfterInsert';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterInsertObservers: ' + afterInsertObservers.size());

    for (BaseTriggerObserver triggerObserver : afterInsertObservers) {
      triggerObserver.onAfterInsert();
    }
  }

  private void onAfterUpdate() {
    methodName = 'onAfterUpdate';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterUpdateObservers: ' + afterUpdateObservers.size());

    for (BaseTriggerObserver triggerObserver : afterUpdateObservers) {
      triggerObserver.onAfterUpdate();
    }
  }

  private void onAfterDelete() {
    methodName = 'onAfterDelete';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterDeleteObservers: ' + afterDeleteObservers.size());

    for (BaseTriggerObserver triggerObserver : afterDeleteObservers) {
      triggerObserver.onAfterDelete();
    }
  }

  private void onAfterUndelete() {
    methodName = 'onAfterUndelete';
    logger.stackDebugLog(LOGGING_LEVEL_DEFAULT, CLASS_NAME, methodName, 'afterUndeleteObservers: ' + afterUndeleteObservers.size());

    for (BaseTriggerObserver triggerObserver : afterUndeleteObservers) {
      triggerObserver.onAfterUndelete();
    }
  }

}
