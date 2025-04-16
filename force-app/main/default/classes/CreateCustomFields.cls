public class CreateCustomFields {
    //Method that is called by user or automation to kick everything off
    public static List<FieldDeploymentResult> createFieldsFromCsv(String csvFileName, Boolean hasHeader, String permissionsFileName, Boolean permissionsHasHeader) {
        //Parse the field csv file
        
        List<String> csvStrings = CSVReader.findAndParseFile(csvFileName);
        //csvString contains the csv body [0] and the object name [1]
        String objectName = csvStrings[1];
        List<ParsedFieldDefinition> csvFields = CSVReader.parse(csvStrings[0], hasHeader, objectName);
       
        //Send parsed fields to API       
        IFieldDeployer deployer = FieldDeployerFactory.getDeployer();
		
        List<FieldDeploymentResult> results = deployer.deployFields(csvFields);
        
        //Log results using generic result class
        for (FieldDeploymentResult result : results) {
            if (!result.success) {
                System.debug('Error: ' + result.message);
            } else {
                System.debug('Success: Created ' + result.fieldName);
            }
        }
        
        //Parse Permissions       
        List<String> csvPermStrings = CSVReader.findAndParseFile(permissionsFileName);
        List<ParsedFieldPermission> csvPermissions = CSVReader.parse(csvPermStrings[0], permissionsHasHeader);
        
        //Make API Callout for Profile field permissions since this cannot be done via dml
        IFieldPermissionDeployer permDeployer = PermissionDeployerFactory.getDeployer();
        List<FieldDeploymentResult> permResults = permDeployer.deployPermissions(csvPermissions, csvFields, objectName);        
        
        for (FieldDeploymentResult result : permResults) {
            if (!result.success) {
                System.debug('Error: ' + result.message);
            } else {
                System.debug('Success: Created ' + result.fieldName);
            }
        }
        
        //Update Permission Sets via dml
        Map<String, Id> permSetMap = getPermSetIdsFromParsedFile(csvPermissions);
        insertFieldPermissions(csvFields, csvPermissions, permSetMap, objectName);
        
        return results;
    }
    
    public static Map<String, Id> getPermSetIdsFromParsedFile(List<ParsedFieldPermission> parsedPermissions) {
        Map<String, Id> permSetMap = new Map<String, Id>();
        Set<String> permSetNames = new Set<String>();
        
        for (ParsedFieldPermission p : parsedPermissions) {
            //ParsedFieldPermission parsedPerm = new ParsedFieldPermission();
            if (p.permType == 'Permission Set') {
                permSetNames.add(p.name);
            }
        }
        
        for (PermissionSet ps : [SELECT Id, Name FROM PermissionSet WHERE Name IN :permSetNames]) {
            permSetMap.put(ps.Name, ps.Id);
        }
        return permSetMap;
    }
    
    //Loop through each field that was deployed and assign permissions from the parsed csv file
    public static void insertFieldPermissions(List<ParsedFieldDefinition> parsedFields, List<ParsedFieldPermission> parsedPermissions, Map<String, Id> permSetMap, String objectApiName) {
        List<FieldPermissions> fieldPerms = new List<FieldPermissions>();

        for (ParsedFieldDefinition field : parsedFields) {
            //Cannot create FieldPermission for required Custom Fields.
            if (field.required) {
                continue;
            }
            String fieldApiName = field.apiName;
        
            for (ParsedFieldPermission perm : parsedPermissions) {
                Id parentId;
                if (perm.permType == 'Permission Set') {
                    parentId = permSetMap.get(perm.name);
                }
        
                if (parentId == null) continue; // skip if not found
        
                fieldPerms.add(new FieldPermissions(
                    ParentId = parentId,
                    SObjectType = objectApiName,
                    Field = fieldApiName,
                    PermissionsRead = perm.readable,
                    PermissionsEdit = perm.editable
                ));
            }
        }
        
        for (FieldPermissions fp : fieldPerms) {
            System.Debug('Field Permission: ' + fp);
        }
        
        if (Schema.SObjectType.Opportunity.fields.getMap().containsKey('NewPicklistTest__c')) {
    		// Safe to do DML
    		insert fieldPerms;
        } else {
            // Delay DML or notify user that field isn't fully available yet
            System.Debug('Field not yet in Schema');
        }
    }
}