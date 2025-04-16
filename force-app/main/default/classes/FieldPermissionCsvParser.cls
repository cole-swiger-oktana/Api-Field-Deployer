//Deprecated Class
public class FieldPermissionCsvParser {
    /*public static List<ParsedFieldPermission> parse(String fileName, Boolean hasHeader) {
        List<ParsedFieldPermission> permissions = new List<ParsedFieldPermission>();

        // Query the latest version of the file by title
        ContentVersion version = [
            SELECT VersionData 
            FROM ContentVersion 
            WHERE Title = :fileName 
            ORDER BY CreatedDate DESC 
            LIMIT 1
        ];

        String csvText = version.VersionData.toString();
        List<String> lines = version.split('\n');

        /*Integer startIndex = hasHeader ? 1 : 0;
        for (Integer i = startIndex; i < lines.size(); i++) {
            String line = lines[i].trim();
            if (String.isBlank(line)) continue;

            List<String> columns = line.split(',');

            // Safety check: needs at least 3 columns
            if (columns.size() < 3) continue;

            ParsedFieldPermission p = new ParsedFieldPermission();
            p.name = columns[0].trim();
            p.isProfile = columns[1].trim().equalsIgnoreCase('Profile');
            p.read = columns[2].trim().equalsIgnoreCase('true');

            // Edit column is optional
            p.edit = columns.size() > 3 && columns[3].trim().equalsIgnoreCase('true');

            permissions.add(p);
        }

        return permissions;
    }

    private static Boolean parseBool(String val) {
        String lower = val.toLowerCase().trim();
        return lower == 'true' || lower == 'yes' || lower == '1';
    }*/
}