public class MetadataFieldDeployer implements IFieldDeployer {
    public List<FieldDeploymentResult> deployFields(List<ParsedFieldDefinition> parsedFields){
        List<FieldDeploymentResult> results = new List<FieldDeploymentResult>();
        
        //Set Up Metadata Connection
        MetadataService.MetadataPort service = MetadataConnectionUtil.createMetadataConnection();
        List<MetadataService.Metadata> fieldsToCreate = new List<MetadataService.Metadata>();

        //Create Custom Field for each row in parsed csv
        for (ParsedFieldDefinition parsed : parsedFields) {
            MetadataService.CustomField field = new MetadataService.CustomField();
            field.fullName = parsed.apiName;
            field.label = parsed.label;
            field.type_x = parsed.dataType;
            if (parsed.dataType != 'MasterDetail') {
                field.required = parsed.required;
			}
            field.unique = parsed.unique;
            field.externalId = parsed.externalId;
            field.caseSensitive = parsed.caseSensitive;

            //Text fields
            if (parsed.dataType == 'Text') {
                field.length = 30;
            } else if (parsed.dataType == 'TextArea') {
                field.length = 255;
            } else if (parsed.dataType == 'LongTextArea') {
                field.length = 32000;
                field.visibleLines = 3;
            } else if (parsed.dataType == 'Html') {
                field.length = 32000;
                field.visibleLines = 10;
            } 
            //Number fields
            else if (parsed.dataType == 'Number' || parsed.dataType == 'Percent' || parsed.dataType == 'Currency') {
                field.precision = 18;
                field.scale = 2;
            }
            //Relationship Fields
            else if (parsed.dataType == 'Lookup' || parsed.dataType == 'MasterDetail') {
                System.Debug('Relationship Field');
                System.Debug('Relationship type: ' + parsed.dataType);
                field.referenceTo = parsed.relatedObject;
                field.relationshipName = parsed.relatedObject + '_' + parsed.fullName.split('\\.')[0].replace('__c', '_') + 'Ref';
                field.type_x = parsed.dataType;
                System.Debug('Type_x: ' + field.type_x);
                System.Debug('Relationship Name: ' + field.relationshipName);
                
                if (parsed.dataType == 'MasterDetail') {
                    //field.required = null;
                    field.writeRequiresMasterRead = false;
                    field.relationshipLabel = 'Test Children';
                    field.relationshipOrder = 0;
                }
            }
            else if (parsed.dataType == 'Picklist' && parsed.picklistValues != null) {
    			MetadataService.ValueSet valueSet = new MetadataService.ValueSet();
   			 	valueSet.valueSetDefinition = new MetadataService.ValueSetValuesDefinition();
    			valueSet.valueSetDefinition.value = new List<MetadataService.CustomValue>();
                
                for (String val : parsed.picklistValues) {
                    MetadataService.CustomValue cv = new MetadataService.CustomValue();
                    cv.fullName = val;
                    cv.default_x = false;
                    cv.label = val;
                    valueSet.valueSetDefinition.value.add(cv);
                }

                valueSet.valueSetDefinition.sorted = false;
                valueSet.restricted = false;
            
                field.valueSet = valueSet;
			}
            System.Debug('Full Field: ' + field);
            fieldsToCreate.add(field);
        }
        
        MetadataService.SaveResult[] metadataResults = service.createMetadata(fieldsToCreate);
        
        for (Integer i = 0; i < metadataResults.size(); i++) {
            results.add(new FieldDeploymentResult(
                metadataResults[i].fullName,
                metadataResults[i].success,
                metadataResults[i].success ? 'Deployed successfully' : metadataResults[i].errors != null ? metadataResults[i].errors[0].message : 'Unknown error'
            ));
        }
        
        return results;
    }
}