global class ReportSelector1 extends VisualEditor.DynamicPickList{
    
    global  override VisualEditor.DataRow getDefaultValue(){
        list<Report> summaryReports=[Select Id,Name,DeveloperName from report where format='Summary'];
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('First Report','First Report');
        system.debug('default val is:- '+defaultValue);
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        list<Report> summaryReports=[Select Id,Name,DeveloperName from report where format='Summary'];
       // VisualEditor.DataRow value1 = new VisualEditor.DataRow('red', 'RED');
        //VisualEditor.DataRow value2 = new VisualEditor.DataRow('yellow', 'YELLOW');
       
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();
        for(Report rep:summaryReports)
        {
            VisualEditor.DataRow value = new VisualEditor.DataRow(rep.DeveloperName, rep.DeveloperName);
        myValues.addRow(value);
        }
        system.debug('whole datarow data is:- '+myValues);
        return myValues;
    }
}