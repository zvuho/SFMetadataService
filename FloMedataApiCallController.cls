global without sharing class FloMedataApiCallController {

public FloMedataApiCallController() {
}

@RemoteAction
global static String addValueToGlobalPicklist(){

    String result = '0';
    try {
        FloMetadataService.MetadataPort service = FloUtils.createService(UserInfo.getSessionId());
        FloMetadataService.GlobalPicklist globalPickList = (FloMetadataService.GlobalPicklist) service.readMetadata('GlobalPicklist',new String[] { 'FLODocs__FLO_Change_Type'}).getRecords()[0];
        Boolean existValue = false;
        String 	itemToVerify = 'Jira';
        system.debug('Picklist FullName: ' + globalPickList.fullname);
        if(globalPickList.globalPicklistValues != null){
            for(FloMetadataService.PicklistValue itm : globalPickList.globalPicklistValues){
                if(itm.fullname == itemToVerify){
                    existValue = true;
                    result = '-1';
                    break;
                }
            }
            system.debug('Exist Jira Item: ' + existValue);
            
            if(!existValue){
                FloMetadataService.PicklistValue picklistValue = new FloMetadataService.PicklistValue();
                picklistValue.fullName = itemToVerify;
                picklistValue.isActive = true;
                picklistValue.default_x = false;
                picklistValue.description = itemToVerify;
                globalPickList.globalPicklistValues.add(picklistValue);
                system.debug('Next Step Add picklistvalue');
                List<FloMetadataService.SaveResult> results = service.updateMetadata(new FloMetadataService.Metadata[] { globalPickList });
                result = '1';
            }
        }
    } catch(Exception e) {

    }
    FloUtils.AddPicklistValuesLCB();
    FloUtils.AddPicklistValuesDLUStatus();
    //SF-1090
	Floutils.AddPicklistValuesPermissionGroup();
	Floutils.createPSGPostInstall();
    //SF-1090
    //SF-1201
	if(!Test.isRunningTest()){
		FloUtils.updateEmailTemplateEnvComp();
  }
  //SF-1201
    return result;
}

}