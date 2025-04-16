public class CSVReader {
	//public static List<ParsedFieldDefinition> findAndParseFile(String fileName, Boolean hasHeader) {
	public static List<String> findAndParseFile(String fileName) {
        List<String> returnList = new List<String>();
        
        ContentVersion cv = [
            SELECT VersionData, title 
            FROM ContentVersion 
            WHERE Title = :fileName 
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];

        String foundFileName = (String) cv.get('Title');
        String objectName = foundFileName.endsWith('.csv') ? foundFileName.replace('.csv', '') : foundFileName;
        
        String csvText = cv.VersionData.toString();
        returnList.add(csvText);
        returnList.add(objectName);
        System.Debug('File: ' + csvText);
        //return parse(csvText, hasHeader, objectName);
        return returnList;
    }
    
    public static List<ParsedFieldDefinition> parse(String csvContent, Boolean hasHeader, String objectName) {
        List<ParsedFieldDefinition> fields = new List<ParsedFieldDefinition>();
        csvContent = csvContent.replaceAll('\r\n', '\n').replaceAll('\r', '\n'); // Normalize line endings
        List<String> lines = csvContent.split('\n');
        System.Debug('lines: ' + lines);

        Integer startLine = hasHeader ? 1 : 0;

        for (Integer i = startLine; i < lines.size(); i++) {
            String line = lines[i].trim();
            if (String.isBlank(line)) continue;

            List<String> values = parseCsvLine(line);

            ParsedFieldDefinition field = new ParsedFieldDefinition();
            field.apiName       = objectName + '.' + values[0].trim();
            field.fullName      = field.apiName;
            field.label         = values[1].trim();
            field.dataType      = values[2].trim();
            field.helpText      = values[3].trim();
            field.required      = toBoolean(values[4]);
            field.unique        = toBoolean(values[5]);
            field.caseSensitive = toBoolean(values[6]);
            field.externalId    = toBoolean(values[7]);
            field.relatedObject = values.size() > 9 ? values[9].trim() : null;

            // Picklist parsing - check if picklist values are even included
            if (field.dataType.toLowerCase() == 'picklist' && values.size() > 8) {
                //field.picklistValues = new List<String>();
                field.picklistValues = values[8].split('\\|');
            }

            fields.add(field);
        }

        System.Debug('Fields: ' + fields);
        return fields;
	}
    
    public static List<ParsedFieldPermission> parse(String csvContent, Boolean hasHeader) {
        List<ParsedFieldPermission> permissions = new List<ParsedFieldPermission>();
        csvContent = csvContent.replaceAll('\r\n', '\n').replaceAll('\r', '\n'); // Normalize line endings
        List<String> lines = csvContent.split('\n');
        System.Debug('lines: ' + lines);

        Integer startLine = hasHeader ? 1 : 0;

        for (Integer i = startLine; i < lines.size(); i++) {
            String line = lines[i].trim();
            if (String.isBlank(line)) continue;

            List<String> values = parseCsvLine(line);
            
            ParsedFieldPermission perm = new ParsedFieldPermission();
            perm.name = values[0].trim();
            perm.permType = values[1].trim();
            perm.readable = toBoolean(values[2]);
            perm.editable = toBoolean(values[3]);
            
            permissions.add(perm);
        }
        System.Debug('Perms: ' + permissions);
        return permissions;
    }
    
    private static Boolean toBoolean(String input) {
        return input != null && input.trim().toLowerCase() == 'true';
    }

    // Basic CSV line splitter (does not support quoted commas)
    private static List<String> parseCsvLine(String line) {
        return line.split(',');
    }
}