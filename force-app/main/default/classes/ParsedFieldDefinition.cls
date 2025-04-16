public class ParsedFieldDefinition {
	public String apiName { get; set; }
    public String fullName { get; set; }
    public String label { get; set; }
    public String dataType { get; set; }
    public String helpText { get; set; }
    public Boolean required { get; set; }
    public Boolean unique { get; set; }
    public Boolean caseSensitive { get; set; }
    public Boolean externalId { get; set; }
    public List<String> picklistValues { get; set; }
    public String relatedObject { get; set; }
}