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
    @AuraEnabled(cacheable = true)
    public static Map<String, Object> getProductData(String recId) {
        Map<String, Object> returnMap = new Map<String, Object>();
        Contact con = DataFactory.getContactDetails(recId);
        if(con != null && con.Product__c != null && con.AccountId != null){
            Boolean relActiveContract = false;
            List<ServiceContract> activeServiceContracts = DataFactory.getContracts(con.Product__c, con.AccountId, con.Home_Country__c);
            if(activeServiceContracts.size()>0){
                Map<String, Object> productInfoMap = new Map<String, Object>();
                for(ServiceContract sCon: activeServiceContracts){
                    System.debug('running');
                    if(sCon.ContractLineItems != null){
                     	ContractLineItem cli = sCon.ContractLineItems;
                    	Decimal atmFee = cli.ATM_Fee_in_other_currencies__c / 100;
                    	productInfoMap.put(Constants.ATM_FEE, atmFee);
                    	productInfoMap.put(Constants.REPLACEMENT_COST, cli.Card_Replacement_Cost__c);
                    	productInfoMap.put(Constants.COST_PER_MONTH, cli.Cost_per_Calendar_Month__c);
                    	productInfoMap.put(Constants.CURRENCY_CODE, cli.CurrencyIsoCode);
                    	productInfoMap.put(Constants.PRODUCT_NAME, cli.Product2.Name);
                    	productInfoMap.put(Constants.CONTRACT_TERM, sCon.Term);
                    	productInfoMap.put(Constants.CONTRACT_LINK, '/'+sCon.Id);
                    	returnMap.put(Constants.CONTRACT_EXISTS, true);
                    	returnMap.put(Constants.PRODUCT_INFO, productInfoMap);   
                        relActiveContract = true;
                    }
                }
            } 
            if(!relActiveContract){
                PriceBookEntry catalogEntry = DataFactory.getCatalogEntry(con.Product__c, con.Home_Country__c);
                
                Map<String, Object> productInfoMap= new Map<String, Object>();
                Decimal atmFee = catalogEntry.ATM_Fee_in_other_countries__c !=null? catalogEntry.ATM_Fee_in_other_countries__c / 100 : 0;
                productInfoMap.put(Constants.ATM_FEE, atmFee);
                productInfoMap.put(Constants.REPLACEMENT_COST, catalogEntry.Card_Replacement_Cost__c);
                productInfoMap.put(Constants.COST_PER_MONTH, catalogEntry.Cost_per_Calendar_Month__c);
                productInfoMap.put(Constants.CURRENCY_CODE, catalogEntry.CurrencyIsoCode);
                productInfoMap.put(Constants.PRODUCT_NAME, catalogEntry.Product2.Name);
                productInfoMap.put(Constants.PRODUCT_LINK, '/'+catalogEntry.Product2Id);
                returnMap.put(Constants.PRODUCT_INFO, productInfoMap);
                returnMap.put(Constants.CONTRACT_EXISTS, false);
            }
        }
        return returnMap;
    }
    
}