@isTest
public class ProfileFieldPermissionDeployerTest {
	
    static {
        Test.setMock(WebServiceMock.class, new MetadataServiceProfileMock());
    }

    @isTest
    static void testDeployPermissions() {
        // Create mock ParsedFieldPermission and ParsedFieldDefinition data
        List<ParsedFieldPermission> profilePermissions = new List<ParsedFieldPermission>();
        ParsedFieldPermission pf1 = new ParsedFieldPermission();
        pf1.name = 'Profile1';
        pf1.permType = 'Profile';
        pf1.readable = true;
        pf1.editable = true;
        profilePermissions.add(pf1);
        ParsedFieldPermission pf2 = new ParsedFieldPermission();
        pf2.name = 'Profile2';
        pf2.permType = 'Profile';
        pf2.readable = true;
        pf2.editable = false;
        profilePermissions.add(pf2);
        
        List<ParsedFieldDefinition> fieldDefinitions = new List<ParsedFieldDefinition>();
        ParsedFieldDefinition pfd = new ParsedFieldDefinition();
        pfd.apiName = 'Field1__c';
        pfd.label = 'Test Field';
        pfd.dataType = 'Text';
        pfd.fullName = 'Field1';
        pfd.helpText = '';
        pfd.caseSensitive = false;
        pfd.required = false;
        pfd.unique = false;
        pfd.externalId = false;
        fieldDefinitions.add(pfd);
        
        IFieldPermissionDeployer deployer = new ProfileFieldPermissionDeployer();
        List<FieldDeploymentResult> results = deployer.deployPermissions(profilePermissions, fieldDefinitions, 'TestObject');
        System.Debug('Results: ' + results);
        
        // Assertions to check that deployment was successful
        System.assertEquals(2, results.size(), 'Should have 2 deployment results');
        System.assert(results[0].success, 'First deployment should be successful');
        System.assert(results[1].success, 'Second deployment should be successful');
    }
}