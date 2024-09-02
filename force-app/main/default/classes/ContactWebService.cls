@RestResource(urlMapping='/ContactService/*')
global class ContactWebService {
    @HttpGet
    global static ResponseWrapper getContact(){
        RestRequest req = RestContext.request;
        String contactUUID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        ResponseWrapper returnMap = generateResponse(contactUUID);
        return returnMap;
    }
    
    private static ResponseWrapper generateResponse(String uId){
        ResponseWrapper returnMap = new ResponseWrapper();
        Contact con = DataFactory.getContactDetailsByUUID(uId);
        if(con != null && con.Product__c != null && con.AccountId != null){
            List<ServiceContract> activeServiceContracts = DataFactory.getContracts(con.Product__c, con.AccountId, con.Home_Country__c);
            if(activeServiceContracts.size()>0){
                for(ServiceContract sCon: activeServiceContracts){
                    ContractLineItem cli = sCon.ContractLineItems;
                    returnMap.ATMFee = cli.ATM_Fee_in_other_currencies__c;
                    returnMap.ReplacementCost = cli.Card_Replacement_Cost__c;
                    returnMap.CostPerMonth = cli.Cost_per_Calendar_Month__c;
                    returnMap.CurrencyCode = cli.CurrencyIsoCode;
                    returnMap.ProductName = cli.Product2.Name;
                    returnMap.ProductId = cli.Product2Id;
                    returnMap.ContractTerm = sCon.Term;
                    returnMap.ContractId = sCon.Id;
                    returnMap.ContractExist = true;
                    returnMap.Home_Country = con.Home_Country__c;
                }
            } else {
                PriceBookEntry catalogEntry = DataFactory.getCatalogEntry(con.Product__c, con.Home_Country__c);
                
                returnMap.ATMFee = catalogEntry.ATM_Fee_in_other_countries__c;
                returnMap.ReplacementCost = catalogEntry.Card_Replacement_Cost__c;
                returnMap.CostPerMonth = catalogEntry.Cost_per_Calendar_Month__c;
                returnMap.CurrencyCode = catalogEntry.CurrencyIsoCode;
                returnMap.ProductName = catalogEntry.Product2.Name;
                returnMap.ProductId = catalogEntry.Product2Id;
                returnMap.ContractExist = false;
                returnMap.Home_Country = con.Home_Country__c;
            }
        }
        return returnMap;
    }

}