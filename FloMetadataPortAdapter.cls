// adapter class so that we can stub/mock the MetadataPort methods
// Stub API cannot mock inner classes like FloMetadataService.MetadataPort
public with sharing class FloMetadataPortAdapter {
    
    // TODO: make the api version settable
    public List<FloMetadataService.SaveResult> createMetadata(List<FloMetadataService.Metadata> metadata) {
		FloMetadataService.MetadataPort metadataService = FloUtils.createService(UserInfo.getSessionId());
		//need a later api version to support customMetadataRecordType field
		metadataService.endpoint_x = URL.getSalesforceBaseUrl().toExternalForm().toLowerCase() + '/services/Soap/m/46.0';
		return metadataService.createMetadata(metadata);
	}


    // simplifies by returning the records directly
	public List<FloMetadataService.Metadata> readMetadata(String metadataType, List<String> fullNames) {
		FloMetadataService.MetadataPort metadataService = FloUtils.createService(UserInfo.getSessionId());
		return metadataService.readMetadata(metadataType, fullNames).getRecords();
	}

}