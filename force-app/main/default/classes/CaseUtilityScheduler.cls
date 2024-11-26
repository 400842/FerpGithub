public class CaseUtilityScheduler implements Schedulable {
   public void execute(SchedulableContext SC) {
      Database.executebatch(new CaseUtilityBatch());
   }
}