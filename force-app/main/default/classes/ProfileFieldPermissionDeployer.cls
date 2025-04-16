public class ProfileFieldPermissionDeployer implements IFieldPermissionDeployer {
    public List<FieldDeploymentResult> deployPermissions(List<ParsedFieldPermission> profileList, List<ParsedFieldDefinition> parsedFields, String objectName) {
        MetadataService.MetadataPort service = MetadataConnectionUtil.createMetadataConnection();
        
        List<MetadataService.Profile> profilesToUpdate = new List<MetadataService.Profile>();
        //List<MetadataService.Metadata> profilesToUpdate = new List<MetadataService.Metadata>();

        // Group ParsedFieldPermission records by profile name
        for (ParsedFieldPermission parsedProfile : profileList) {
            if (parsedProfile.permType != 'Profile') {
                continue;
            }
            MetadataService.Profile profileMeta = new MetadataService.Profile();
            profileMeta.fullName = parsedProfile.name;

            List<MetadataService.ProfileFieldLevelSecurity> permissionsList = new List<MetadataService.ProfileFieldLevelSecurity>();

            for (ParsedFieldDefinition parsedField : parsedFields) {
                if (parsedField.required) {
                    continue;
                }
                // Assume all rows for a profile have the same read/edit values
                //ParsedFieldPermission parsedPerms = parsedPorifle;

                MetadataService.ProfileFieldLevelSecurity permEntry = new MetadataService.ProfileFieldLevelSecurity();
                //permEntry.field = objectName + '.' + parsedField.apiName;
                permEntry.field = parsedField.apiName;
                permEntry.readable = parsedProfile.readable;
                permEntry.editable = parsedProfile.editable;

                permissionsList.add(permEntry);
            }

            profileMeta.fieldPermissions = permissionsList;
            profilesToUpdate.add(profileMeta);
        }

        // Deploy the permissions via Metadata API
        List<MetadataService.SaveResult> metadataResults = service.updateMetadata(profilesToUpdate);
        List<FieldDeploymentResult> results = new List<FieldDeploymentResult>();
        
        for (Integer i = 0; i < metadataResults.size(); i++) {
            //MetadataService.SaveResult res = saveResults[i];
            //ParsedFieldDefinition field = fields[i];

            results.add(new FieldDeploymentResult(
                //field.apiName,
                metadataResults[i].fullName,
                metadataResults[i].success,
                metadataResults[i].success ? 'Deployed successfully' : metadataResults[i].errors != null ? metadataResults[i].errors[0].message : 'Unknown error'
            ));
        }
        
        return results; 
    }
}