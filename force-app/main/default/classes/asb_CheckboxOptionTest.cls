@isTest
public class asb_CheckboxOptionTest {
	
    private static testMethod void unitTest(){
        
        asb_CheckboxOption ins = new asb_CheckboxOption('TEST','TEST',false);
         asb_CheckboxOption ins1 = new asb_CheckboxOption('TEST1','TEST1',false);
        system.assertEquals('TEST', ins.getLabel());
        system.assertEquals('TEST', ins.getValue());
        system.assertEquals(false, ins.getChecked());
        ins.setChecked(true);
        ins.setValue('TEST1');
        ins.setLabel('TEST1');
        List<asb_CheckboxOption> l = new List<asb_CheckboxOption>();
        l.add(ins);
        l.sort();
        ins.compareTo(ins1);
        
    }
}