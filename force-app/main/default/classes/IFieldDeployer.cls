public interface IFieldDeployer {
    /*
    * Interface for deploying custom fields.
    * Allows different implementations based on deployment strategy.
    */
	List<FieldDeploymentResult> deployFields(List<ParsedFieldDefinition> parsedFields);
}