public class RevenueWrapper {
    @AuraEnabled
    public List<Date> validDates;
    @AuraEnabled
    public List<Decimal> dailyRevenue;
    
    public RevenueWrapper(){
        this.validDates = validDates;
        this.dailyRevenue = dailyRevenue;
    }
}