//Mock MetadataService callouts
@isTest
global class MetadataServiceMock implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {

        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();
            
        if (request instanceof MetadataService.createMetadata_element) {
            MetadataService.createMetadata_element reqElement = (MetadataService.createMetadata_element)request;
            List<MetadataService.Metadata> metadataList = reqElement.metadata;

            for (MetadataService.Metadata meta : metadataList) {
                MetadataService.SaveResult r = new MetadataService.SaveResult();
                r.fullName = meta.fullName;
                r.success = true;
                results.add(r);
            }
        }

        // Wrap the results in a proper response element
        MetadataService.createMetadataResponse_element responseElement = new MetadataService.createMetadataResponse_element();
        responseElement.result = results;

        // Set it in the response map
        response.put('response_x', responseElement);
    }
}