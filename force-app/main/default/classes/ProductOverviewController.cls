/*
* ClassName : ProductOverviewController
* Author    : Agraj Mishra
* LastModified : 1-Sept-2024
*/
public class ProductOverviewController {
    /*
    * Method Name		   : getProductData
    * Method Prams        : String - Contact Id
    * Funtion Description : Method is used to fetch the Product data either from an Active Contract or from product Catalog.
    */
    @AuraEnabled(cacheable =true)
    public static Map<String,Object> getProductData(String recId){
        Map<String,Object> returnMap = new Map<String,Object>();
        Contact con = [Select Id,AccountId,Product__c,Home_Country__c from Contact where Id=:recId];
        if(con !=null && con.Product__c!=null && con.AccountId!=null){
            List<ServiceContract> activeServiceContracts = [Select Id,Term,Service_Country__c,(Select Id,Product2.Name,ATM_Fee_in_other_currencies__c,Card_Replacement_Cost__c,Cost_per_Calendar_Month__c,
                                                                                               CurrencyIsoCode from ContractLineItems where Product2Id=:con.Product__c) from ServiceContract 
                                                            where AccountId =: con.AccountId AND Service_Country__c=: con.Home_Country__c];
            if(activeServiceContracts.size()>0){
                Map<String,Object> productInfoMap= new Map<String,Object>();
                for(ServiceContract sCon: activeServiceContracts){
                    ContractLineItem cli = sCon.ContractLineItems;
                    Decimal atmFee = cli.ATM_Fee_in_other_currencies__c / 100;
                    productInfoMap.put('ATMFee',atmFee);
                    productInfoMap.put('ReplacementCost',cli.Card_Replacement_Cost__c);
                    productInfoMap.put('CostPerMonth',cli.Cost_per_Calendar_Month__c);
                    productInfoMap.put('CurrCode',cli.CurrencyIsoCode);
                    productInfoMap.put('ProdName',cli.Product2.Name);
                    productInfoMap.put('ContractTerm',sCon.Term);
                    productInfoMap.put('ContractLink','/'+sCon.Id);
                    returnMap.put('ContractExist',true);
                    returnMap.put('ProductInfo',productInfoMap);
                }
            }else{
                PriceBookEntry catalogEntry = [select Id,Product2Id,Product2.Name,ATM_Fee_in_other_countries__c, Card_Replacement_Cost__c, 
                                               Cost_Per_Calendar_Month__c, Pricebook2.Name,CurrencyIsoCode from PricebookEntry where Product2Id =: con.Product__c 
                                               AND Pricebook2.Name =: con.Home_Country__c ][0];
                
                returnMap.put('ContractExist',false);
                Map<String,Object> productInfoMap= new Map<String,Object>();
                Decimal atmFee = catalogEntry.ATM_Fee_in_other_countries__c / 100;
                productInfoMap.put('ATMFee',atmFee);
                productInfoMap.put('ReplacementCost',catalogEntry.Card_Replacement_Cost__c);
                productInfoMap.put('CostPerMonth',catalogEntry.Cost_per_Calendar_Month__c);
                productInfoMap.put('CurrCode',catalogEntry.CurrencyIsoCode);
                productInfoMap.put('ProdName',catalogEntry.Product2.Name);
                productInfoMap.put('ProductLink','/'+catalogEntry.Product2Id);
                returnMap.put('ProductInfo',productInfoMap);
            }
        }
        return returnMap;
    }
    
}