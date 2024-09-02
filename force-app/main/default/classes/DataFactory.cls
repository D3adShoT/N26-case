public class DataFactory {
    public static List<ServiceContract> getContracts(String ProductId, String AccountId, String Country){
        return [Select Id,Term,Service_Country__c,(Select Id,Product2Id,Product2.Name,ATM_Fee_in_other_currencies__c,Card_Replacement_Cost__c,Cost_per_Calendar_Month__c,
                                                                                               CurrencyIsoCode from ContractLineItems where Product2Id =: ProductId) from ServiceContract 
                                                            where AccountId =: AccountId AND Service_Country__c =: Country];
    }
    
    public static Contact getContactDetails(String ContactId){
        return [Select Id, AccountId, Product__c, Home_Country__c from Contact where Id= : ContactId];
    }
    
    public static PriceBookEntry getCatalogEntry(String ProductId, String Country){
        System.debug(ProductId);
        System.debug(Country);
        System.debug([select Id, Product2Id, Product2.Name, ATM_Fee_in_other_countries__c,  Card_Replacement_Cost__c,  
                                               Cost_Per_Calendar_Month__c,  Pricebook2.Name, CurrencyIsoCode from PricebookEntry where Product2Id =: ProductId 
                                               AND Pricebook2.Name =: Country]);
        return [select Id, Product2Id, Product2.Name, ATM_Fee_in_other_countries__c,  Card_Replacement_Cost__c,  
                                               Cost_Per_Calendar_Month__c,  Pricebook2.Name, CurrencyIsoCode from PricebookEntry where Product2Id =: ProductId 
                                               AND Pricebook2.Name =: Country];
    }
    
    public static Contact getContactDetailsByUUID(String UUID){
        return [Select Id, AccountId, Product__c, Home_Country__c from Contact where UUID__c =: UUID];
    }

}