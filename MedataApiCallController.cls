global without sharing class MedataApiCallController {

public MedataApiCallController() {
}

@RemoteAction
global static String addValueToGlobalPicklist(){

    String result = '0';
    try {
        MetadataService.MetadataPort service = Utils.createService(UserInfo.getSessionId());
        MetadataService.GlobalPicklist globalPickList = (MetadataService.GlobalPicklist) service.readMetadata('GlobalPicklist',new String[] { 'FLODocs__FLO_Change_Type'}).getRecords()[0];
        Boolean existValue = false;
        String 	itemToVerify = 'Jira';
        system.debug('Picklist FullName: ' + globalPickList.fullname);
        if(globalPickList.globalPicklistValues != null){
            for(MetadataService.PicklistValue itm : globalPickList.globalPicklistValues){
                if(itm.fullname == itemToVerify){
                    existValue = true;
                    result = '-1';
                    break;
                }
            }
            system.debug('Exist Jira Item: ' + existValue);
            
            if(!existValue){
                MetadataService.PicklistValue picklistValue = new MetadataService.PicklistValue();
                picklistValue.fullName = itemToVerify;
                picklistValue.isActive = true;
                picklistValue.default_x = false;
                picklistValue.description = itemToVerify;
                globalPickList.globalPicklistValues.add(picklistValue);
                system.debug('Next Step Add picklistvalue');
                List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalPickList });
                result = '1';
            }
        }
    } catch(Exception e) {

    }
    Utils.AddPicklistValuesLCB();
    Utils.AddPicklistValuesDLUStatus();
	utils.AddPicklistValuesPermissionGroup();
	utils.createPSGPostInstall();
	if(!Test.isRunningTest()){
		Utils.updateEmailTemplateEnvComp();
  }
  //SF-1201
    return result;
}

}
