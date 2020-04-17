@RestResource(urlMapping='/RunTestClass/*')

global class RunAllTestController_New{

public Id jobId;

public static List<String> completedClassNameList {get;set;}
public static Integer completedClassCount {get;set;}
public static Integer queuedTestClassCount {get;set;}
public static List<ApexTestResult> failedResultList {get;set;}
public static Boolean enablePoller{get; set;}
public static List<ApexTestResult> AddOnfailedResultList;
public static List<Id> queueItemsList;
public static Set<String> jobIdList;
public static List<String> jobIdListToSend;
public static Map<String, Object> mapToSend;

@HttpGet
    // Enqueue all classes ending in "Test". 
    global static List<String> enqueueTests() {
        //queuedTestClassCount = 0;
        completedClassCount = 0;
        enablePoller = true;
        jobIdListToSend = new List<Id>();

        ApexClass[] testClasses = [FIND '@isTest' IN ALL FIELDS RETURNING ApexClass(Id, Name)][0];
            system.debug('testClasses>>>>>>>'+testClasses);
            if(Test.isRunningTest()){
                ApexClass apxClass = new ApexClass();
                apxClass.id = '01p7F00800DGKy4QAH';
                apxClass.Name = 'TestClass';
                
                ApexClass apxClass1 = new ApexClass();
                apxClass1.id = '01p7F00900DGKy4QAH';
                apxClass1.Name = 'TestClass1';
                
                testClasses = new ApexClass[]{apxClass, apxClass1};           
            }
            queuedTestClassCount = testClasses.size();
        if (testClasses.size() > 0) {
            ApexTestQueueItem[] queueItems = new List<ApexTestQueueItem>();
            for (ApexClass cls : testClasses) {
                queueItems.add(new ApexTestQueueItem(ApexClassId=cls.Id));
            }
            if(!Test.isRunningTest()){
                insert queueItems;
            }
            system.debug('queueItems>>>>>>>>>>>'+queueItems);
            queueItemsList = new List<Id>();
            jobIdList = new Set<String>();
            for(ApexTestQueueItem queue : queueItems){
                queueItemsList.add(queue.Id);            
            }
           
            // Get the job ID of the first queue item returned.
            List <ApexTestQueueItem> itemList = 
               [SELECT ParentJobId FROM ApexTestQueueItem 
                WHERE Id IN: queueItemsList];   
            for(ApexTestQueueItem Item : itemList){
                jobIdList.add(Item.ParentJobId);            
            }
                system.debug('jobIdList>>>>>>>>>>'+jobIdList);
                jobIdListToSend.addAll(jobIdList);
                //jobIdListToSend.add(String.valueOf(queuedTestClassCount));
                return jobIdListToSend;
        }
        return null;
    }
     // Get the status and pass rate for each class
    // whose tests were run by the job.
    // that correspond to the specified job ID.
    @HttpPost
    global static MapToSendWrapper checkClassStatus(List<String> jobIdList) {
        MapToSendWrapper wrapperObj = new MapToSendWrapper();
        ApexClass[] testClasses = [FIND '@isTest' IN ALL FIELDS RETURNING ApexClass(Id, Name)][0];
        queuedTestClassCount = testClasses.size();
        system.debug('jobIdList>>>>>>>'+jobIdList);
        completedClassNameList = new List<String>();
        ApexTestQueueItem[] items = 
           [SELECT ApexClass.Name, Status, ExtendedStatus 
            FROM ApexTestQueueItem 
            WHERE ParentJobId IN:jobIdList];
            AddOnfailedResultList = new List<ApexTestResult>();
        for (ApexTestQueueItem item : items) {
            String extStatus = item.extendedstatus == null ? '' : item.extendedStatus;
            System.debug(item.ApexClass.Name + ': ' + item.Status + extStatus);
            //queuedTestClassCount = items.size();
            //queuedTestClassCount = 60;
            system.debug('queuedTestClassCount>>>>>>'+queuedTestClassCount);
            if(item.Status == 'Completed' || (string.isnotBlank(item.ExtendedStatus) && (item.ExtendedStatus.contains('Could not run tests') || item.ExtendedStatus.contains('line')))){
                completedClassNameList.add(item.ApexClass.Name);
            }
            if((string.isnotBlank(item.ExtendedStatus) && (item.ExtendedStatus.contains('Could not run tests') || item.ExtendedStatus.contains('line')))){
                ApexTestResult apexTestRes = new ApexTestResult();
                apexTestRes.ApexClass = item.ApexClass;
                apexTestRes.Outcome = 'Fail';
                apexTestRes.Message = item.ExtendedStatus;
                AddOnfailedResultList.add(apexTestRes);
            }
            
        }
        system.debug('AddOnfailedResultList>>>>>>>>'+AddOnfailedResultList);
        if(completedClassNameList != null){
            completedClassCount = completedClassNameList.size();
            system.debug('completedClassCount>>>>>>'+completedClassCount);
        }       
        wrapperObj.queuedTestClassCount1 = queuedTestClassCount;
        wrapperObj.completedClassCount1= completedClassCount;

        return wrapperObj;
    }

    // Get the result for each test method that was executed.
    @HttpPut
    global static FailureSendWrapper checkMethodStatus(List<String> jobIdList) {
        FailureSendWrapper wrapperObj1 = new FailureSendWrapper();
        failedResultList = new List<ApexTestResult>();
        ApexTestResult[] results = 
           [SELECT Outcome, ApexClass.Name, MethodName, Message, StackTrace 
            FROM ApexTestResult 
            WHERE AsyncApexJobId IN:jobIdList];
            
            system.debug('results>>>>>>>>>>>>'+results);
        wrapperObj1.allTestResultList1 = results;
        for (ApexTestResult atr : results) {
            system.debug('enablePoller>>>>>>>1>>>>>>'+ enablePoller);
            System.debug(atr.ApexClass.Name + '>>>>>' + atr.MethodName + '>>>>>>>>>>' + atr.Outcome);
            if (atr.message != null) {
                System.debug(atr.Message + '\n at>>>>>>>>> ' + atr.StackTrace);
            }
            if(atr != null && atr.Outcome == 'Fail'){
                failedResultList.add(atr);
            }
        }
        if(AddOnfailedResultList != null){
            failedResultList.addall(AddOnfailedResultList);
            system.debug('Inside if>>>>>>>>>>');
        }
        system.debug('failedResultList>>>>>>>'+ JSON.serialize(failedResultList));
        system.debug('failedResultList>>NON>>JSON>>>'+failedResultList);

        wrapperObj1.failedResultList1 = failedResultList;
        system.debug('wrapperObj1>>>>>>>'+wrapperObj1);
        return wrapperObj1;
    }
    
    global class MapToSendWrapper{
        public Integer queuedTestClassCount1;
        public Integer completedClassCount1;     
    }
    
    global class FailureSendWrapper{
        public List<ApexTestResult> failedResultList1 {get;set;}
        public List<ApexTestResult> allTestResultList1 {get;set;} 
    }
}