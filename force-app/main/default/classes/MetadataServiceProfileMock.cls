@isTest
public class MetadataServiceProfileMock implements WebServiceMock {
    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
    ) {
        System.Debug('In Invoke');
        if (request instanceof MetadataService.updateMetadata_element) {
            System.Debug('Is updateMetadata Instance');
            MetadataService.updateMetadata_element reqElement = (MetadataService.updateMetadata_element) request;
            System.Debug('Request: ' + reqElement);

            // Access the list of Metadata inside the request
            List<MetadataService.Metadata> metadataList = reqElement.metadata;
            System.Debug('Metadata List: ' + metadataList);
            List<MetadataService.SaveResult> saveResults = new List<MetadataService.SaveResult>();

            for (MetadataService.Metadata meta : metadataList) {
                // Assume all metadata in this request is a Profile
                MetadataService.Profile profile = (MetadataService.Profile) meta;
            
                MetadataService.SaveResult result = new MetadataService.SaveResult();
                result.fullName = profile.fullName;
                result.success = true;
                saveResults.add(result);
            }

            System.Debug('Save Result: ' + saveResults);
            MetadataService.updateMetadataResponse_element updateResponse = 
                new MetadataService.updateMetadataResponse_element();
            updateResponse.result = saveResults;

            response.put('response_x', updateResponse);
        }
    }
}