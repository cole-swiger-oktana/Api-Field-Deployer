//Interface for deplpying Profile field permissions via API
public interface IFieldPermissionDeployer {
	List<FieldDeploymentResult> deployPermissions(List<ParsedFieldPermission> parsedPermissions, List<ParsedFieldDefinition> parsedFields, String objectName);
}