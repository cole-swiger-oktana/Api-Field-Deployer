public class FieldDeployerFactory {
	public static IFieldDeployer getDeployer() {    
        API_Type__mdt apiType= [
            SELECT ApiType__c 
            FROM API_Type__mdt
    		WHERE DeveloperName = 'Default'
    		LIMIT 1
        ];
        
        if (apiType.ApiType__c == 'Metadata') {
            return new MetadataFieldDeployer();
        } else {
            System.Debug('API Type not currently supported');
            return null;
        }
    }
}