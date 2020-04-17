public class COE_PrintPreviewParser {
    public cls_detailLayoutSections[] detailLayoutSections;
    public class cls_detailLayoutSections {
        public boolean collapsed;
        public Integer columns;	//2
        public String heading;	//Account Information
        public cls_layoutRows[] layoutRows;
        public String layoutSectionId;	//01B460000078XiQEAU
        public String parentLayoutId;	//00h46000002HLyrAAG
        public Integer rows;	//9
        public String tabOrder;	//TopToBottom
        public boolean useCollapsibleSection;
        public boolean useHeading;
    }
    public class cls_layoutRows {
        public cls_layoutItems[] layoutItems;
        public Integer numItems;	//2
    }
    public class cls_layoutItems {
        public boolean editableForNew;
        public boolean editableForUpdate;
        public String label;	//Account Owner
        public cls_layoutComponents[] layoutComponents;
        public boolean placeholder;
        public boolean required;
    }
    public class cls_layoutComponents {
        public cls_details details;
        public Integer displayLines;	//1
        public Integer tabOrder;	//1
        public String type;	//Field
        public String value;	//OwnerId
    }
    public class cls_details {
        public boolean aggregatable;
        public boolean autoNumber;
        public Integer byteLength;	//18
        public boolean calculated;
        public boolean cascadeDelete;
        public boolean caseSensitive;
        public cls_controllerName controllerName;
        public boolean createable;
        public boolean custom;
        public boolean defaultedOnCreate;
        public boolean dependentPicklist;
        public boolean deprecatedAndHidden;
        public Integer digits;	//0
        public boolean displayLocationInDecimal;
        public boolean encrypted;
        public boolean externalId;
        public boolean filterable;
        public cls_filteredLookupInfo filteredLookupInfo;
        public boolean groupable;
        public boolean highScaleNumber;
        public boolean htmlFormatted;
        public boolean idLookup;
        public String label;	//Owner ID
        public Integer length;	//18
        public cls_mask mask;
        public cls_maskType maskType;
        public String name;	//OwnerId
        public boolean nameField;
        public boolean namePointing;
        public boolean nillable;
        public boolean permissionable;
        public cls_picklistValues[] picklistValues;
        public Integer precision;	//0
        public boolean queryByDistance;
        public cls_referenceTargetField referenceTargetField;
        public String relationshipName;	//Owner
        public boolean restrictedDelete;
        public boolean restrictedPicklist;
        public Integer scale;	//0
        public String soapType;	//tns:ID
        public boolean sortable;
        public String type;	//reference
        public boolean unique;
        public boolean updateable;
        public boolean writeRequiresMasterRead;
    }
    public class cls_controllerName {
    }
    public class cls_filteredLookupInfo {
    }
    public class cls_mask {
    }
    public class cls_maskType {
    }
    public class cls_picklistValues {
    }
    public class cls_referenceTargetField {
    }
    public static COE_PrintPreviewParser parse(String json){
        return (COE_PrintPreviewParser) System.JSON.deserialize(json, COE_PrintPreviewParser.class);
    }
}