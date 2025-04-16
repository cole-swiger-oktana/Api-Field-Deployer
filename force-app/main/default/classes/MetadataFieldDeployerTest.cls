@isTest
public class MetadataFieldDeployerTest {
    static {
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
    }

    @isTest
    static void testTextFieldDeployment() {
        testSingleFieldDeployment('Text', null);
    }

    @isTest
    static void testTextAreaFieldDeployment() {
        testSingleFieldDeployment('TextArea', null);
    }

    @isTest
    static void testLongTextAreaFieldDeployment() {
        testSingleFieldDeployment('LongTextArea', null);
    }

    @isTest
    static void testHtmlFieldDeployment() {
        testSingleFieldDeployment('Html', null);
    }

    @isTest
    static void testNumberFieldDeployment() {
        testSingleFieldDeployment('Number', null);
    }

    @isTest
    static void testPercentFieldDeployment() {
        testSingleFieldDeployment('Percent', null);
    }

    @isTest
    static void testCurrencyFieldDeployment() {
        testSingleFieldDeployment('Currency', null);
    }

    @isTest
    static void testPicklistFieldDeployment() {
        testSingleFieldDeployment('Picklist', new List<String>{'Option1', 'Option2'});
    }

    @isTest
    static void testLookupFieldDeployment() {
        ParsedFieldDefinition field = createBaseField('Lookup', null);
        field.relatedObject = 'Account';
        IFieldDeployer deployer = new MetadataFieldDeployer();
        List<FieldDeploymentResult> results = deployer.deployFields(new List<ParsedFieldDefinition>{ field });

        System.assertEquals(1, results.size());
        System.assertEquals(true, results[0].success);
    }

    @isTest
    static void testMasterDetailFieldDeployment() {
        ParsedFieldDefinition field = createBaseField('MasterDetail', null);
        field.required = true; // required is skipped in deployer for MasterDetail
        field.relatedObject = 'Contact';
        IFieldDeployer deployer = new MetadataFieldDeployer();
        List<FieldDeploymentResult> results = deployer.deployFields(new List<ParsedFieldDefinition>{ field });

        System.assertEquals(1, results.size());
        System.assertEquals(true, results[0].success);
    }

    private static void testSingleFieldDeployment(String dataType, List<String> picklistValues) {
        ParsedFieldDefinition field = createBaseField(dataType, picklistValues);
        IFieldDeployer deployer = new MetadataFieldDeployer();
        List<FieldDeploymentResult> results = deployer.deployFields(new List<ParsedFieldDefinition>{ field });

        System.assertEquals(1, results.size(), 'There should be exactly one deployment result');
        System.assertEquals(true, results[0].success, 'The deployment should succeed');
    }

    private static ParsedFieldDefinition createBaseField(String dataType, List<String> picklistValues) {
        ParsedFieldDefinition field = new ParsedFieldDefinition();
        field.apiName = 'TestObject__c.TestField__c';
        field.fullName = field.apiName;
        field.label = 'Test Field';
        field.dataType = dataType;
        field.helpText = 'Helpful info';
        field.required = false;
        field.unique = false;
        field.caseSensitive = false;
        field.externalId = false;
        field.picklistValues = picklistValues;
        return field;
    }
}