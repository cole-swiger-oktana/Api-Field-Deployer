public class FieldDeploymentResult {
    public String fieldName;
    public Boolean success;
    public String message;

    public FieldDeploymentResult(String fieldName, Boolean success, String message) {
        this.fieldName = fieldName;
        this.success = success;
        this.message = message;
    }
}