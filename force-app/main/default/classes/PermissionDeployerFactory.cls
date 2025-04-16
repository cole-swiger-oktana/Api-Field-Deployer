public class PermissionDeployerFactory {
	public static IFieldPermissionDeployer getDeployer() {    
        API_Type__mdt apiType= [
            SELECT ApiType__c 
            FROM API_Type__mdt
    		WHERE DeveloperName = 'Default'
    		LIMIT 1
        ];
        
        if (apiType.ApiType__c == 'Metadata') {
            return new ProfileFieldPermissionDeployer();
        } else {
            System.Debug('API Type not currently supported');
            return null;
        }
    }
}