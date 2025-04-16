public class MetadataConnectionUtil {
	public static MetadataService.MetadataPort createMetadataConnection() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.timeout_x = 120000;
        return service;
    }
}