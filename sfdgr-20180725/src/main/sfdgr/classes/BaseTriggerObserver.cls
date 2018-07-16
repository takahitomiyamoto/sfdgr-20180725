public interface BaseTriggerObserver {
  void onBeforeInsert();
  void onBeforeUpdate();
  void onBeforeDelete();
  void onAfterInsert();
  void onAfterUpdate();
  void onAfterDelete();
  void onAfterUndelete();
}