@isTest
private class FloMedataApiCallControllerTest {
    
    static List<FLO_Customization__c> createCusts(Map<String,String>maptypes) {
        //Create Default FLO Policy
        //Create Configuration And Stats records. 
        // SF-1448 use test data generator
        FLO_Change_Approval_Policy__c defaultPolicy = FloTestObjcetsGenerator.createBasicPolicy();

        insert defaultPolicy;

        List<FLO_Customization__c> l = new List<FLO_Customization__c>();

        for (String sftype : maptypes.keySet()) {
            String scId = maptypes.get(sftype);
            FLO_Customization__c c  = new FLO_Customization__c();
            c.Name = 'test'+sftype;
            c.ScriptId__c = scId;
            c.Salesforce_Types__c = sftype;
            c.Data_Type__c = 'test(Formula)test';
            c.Extended_Types_Fields_Raw__c = 'test(Formula)test';
            c.Namespace_Prefix__c = 'FLODocs';
            c.ScriptId__c = 'test';
            l.add(c);
        }
        insert l;
        return l;
    }

    @isTest static void test_Calls() {
        
        System.Test.setMock(WebServiceMock.class, new FloSpiderBatchMocks.WebServiceMockImpl());
        Test.startTest();
        FloMedataApiCallController testMAC = new FloMedataApiCallController();
        
        FloMedataApiCallController.addValueToGlobalPicklist();
        Test.stopTest();
    }

}