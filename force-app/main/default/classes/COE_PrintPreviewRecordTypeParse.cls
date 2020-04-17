public class COE_PrintPreviewRecordTypeParse {
	public cls_layouts layouts;
	public cls_recordTypeMappings[] recordTypeMappings;
	public class cls_layouts {
	}
	public class cls_recordTypeMappings {
		public boolean available;
		public boolean defaultRecordTypeMapping;
		public String layoutId;	
		public boolean master;
		public String name;	
		public cls_picklistsForRecordType[] picklistsForRecordType;
		public String recordTypeId;	
		public cls_urls urls;
	}
	public class cls_picklistsForRecordType {
	}
	public class cls_urls {
		public String layout;
	}
	public static COE_PrintPreviewRecordTypeParse parse(String json){
		return (COE_PrintPreviewRecordTypeParse) System.JSON.deserialize(json, COE_PrintPreviewRecordTypeParse.class);
	}
}