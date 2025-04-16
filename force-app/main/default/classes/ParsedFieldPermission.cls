public class ParsedFieldPermission {
	//API name of profile or permission set    
    public String name { get; set; }
    //Profile or Permission Set
    public String permType { get; set; }
    public Boolean readable { get; set; }
    public Boolean editable { get; set; }
}