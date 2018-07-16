public abstract class BaseTriggerHandler {

  protected List<SObject> oldObjects;
  protected List<SObject> newObjects;
  protected Map<Id, SObject> oldObjectMap;
  protected Map<Id, SObject> newObjectMap;
  protected System.TriggerOperation TriggerOperationType;
  protected Boolean triggerIsExecuting = false;
  protected Integer triggerSize = 0;

  protected List<BaseTriggerObserver> beforeInsertObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> beforeUpdateObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> beforeDeleteObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterInsertObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterUpdateObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterDeleteObservers = new List<BaseTriggerObserver>();
  protected List<BaseTriggerObserver> afterUndeleteObservers = new List<BaseTriggerObserver>();

  protected abstract void addObservers();
  protected abstract void onBeforeInsert();
  protected abstract void onBeforeUpdate();
  protected abstract void onBeforeDelete();
  protected abstract void onAfterInsert();
  protected abstract void onAfterUpdate();
  protected abstract void onAfterDelete();
  protected abstract void onAfterUndelete();

  public static Boolean firstRun = true;

  public BaseTriggerHandler() {
    this.oldObjects = Trigger.old;
    this.newObjects = Trigger.new;
    this.oldObjectMap = Trigger.oldMap;
    this.newObjectMap = Trigger.newMap;
    this.TriggerOperationType = Trigger.operationType;
    this.triggerIsExecuting = Trigger.isExecuting;
    this.triggerSize = Trigger.size;
  }

  public void invoke() {
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
      throw e;
    } finally {
      firstRun = false;
    }
  }

  public void addObserver(List<System.TriggerOperation> triggerOperations, BaseTriggerObserver triggerObserver){
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

}
