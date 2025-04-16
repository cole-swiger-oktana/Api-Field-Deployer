@isTest
public class CSVReaderTest {

    @isTest
    public static void testFindAndParseFile() {
        // Arrange
        String fileName = 'TestFieldDefinition.csv'; // Example file name

        // Mock ContentVersion record
        ContentVersion mockContent = new ContentVersion(
            Title = fileName,
            PathOnClient = fileName,
            VersionData = Blob.valueOf('Api1,Label1,Type1,HelpText1,true,false,false,false,,Account,\n' +
                                      'Field2,Label2,Picklist,HelpText2,true,true,false,false,Value1|Value2,')
        );
        insert mockContent;

        // Act
        Test.startTest();
        List<String> result = CSVReader.findAndParseFile(fileName);
        Test.stopTest();

        // Assert
        System.assertNotEquals(0, result.size(), 'Result should not be empty');
        System.assertEquals('Api1,Label1,Type1,HelpText1,true,false,false,false,,Account,\nField2,Label2,Picklist,HelpText2,true,true,false,false,Value1|Value2,', result[0], 'CSV content should match');
        System.assertEquals('TestFieldDefinition', result[1], 'Object name should match');
    }

    @isTest
    public static void testParseFieldDefinitions() {
        // Arrange
        String csvContent = 'Api1,Label1,Type1,HelpText1,true,false,false,false,,Account,\n' +
            				'Field2,Label2,Picklist,HelpText2,true,true,false,false,Value1|Value2,';
        Boolean hasHeader = false;
        String objectName = 'Account';

        // Act
        Test.startTest();
        List<ParsedFieldDefinition> fields = CSVReader.parse(csvContent, hasHeader, objectName);
        Test.stopTest();

        // Assert
        System.assertEquals(2, fields.size(), 'There should be 2 field definitions');
        System.assertEquals('Account.Api1', fields[0].apiName, 'First field API name should be correct');
        System.assertEquals(2, fields[1].picklistValues.size(), 'Second field should have 2 picklist values');
        System.assertEquals('Value1', fields[1].picklistValues[0], 'Picklist value should be correct');
    }

    @isTest
    public static void testParseFieldPermissions() {
        // Arrange
        String csvContent = 'Name,type,read,edit\n' +
                            'TestPermissionSet,PermissionSet,true,true';
        Boolean hasHeader = true;

        // Act
        Test.startTest();
        List<ParsedFieldPermission> permissions = CSVReader.parse(csvContent, hasHeader);
        Test.stopTest();

        // Assert
        System.assertEquals(1, permissions.size(), 'There should be 1 permissions');			//Header is ignored, so only 1 row should be returned
        System.assertEquals('TestPermissionSet', permissions[0].name, 'Profile name should be correct');
        System.assertEquals('PermissionSet', permissions[0].permType, 'Permission set type should be correct');
    }
}