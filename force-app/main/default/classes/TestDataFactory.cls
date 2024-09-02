@isTest
public class TestDataFactory {
    public static Product2 createProduct(String name, Boolean isActive) {
        Product2 product = new Product2(Name = name, IsActive = isActive);
        insert product;
        return product;
    }

    public static Pricebook2 createPricebook(String name, Boolean isActive) {
        Pricebook2 pricebook = new Pricebook2(Name = name, IsActive = isActive);
        insert pricebook;
        return pricebook;
    }

    public static PricebookEntry createPricebookEntry(Product2 product, Id pricebookId, Decimal atmFee, Decimal cardReplacementCost, Decimal costPerMonth, Boolean isInsert) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 1,
            IsActive = true,
            ATM_Fee_in_other_countries__c = atmFee,
            Card_Replacement_Cost__c = cardReplacementCost,
            Cost_per_Calendar_Month__c = costPerMonth
        );
        if(isInsert){
          insert pbe;  
        }
        return pbe;
    }

    public static Account createAccount(String name, Boolean isInsert) {
        Account acc = new Account(Name = name);
        if(isInsert){
          insert acc;  
        }
        return acc;
    }

    public static Contact createContact(String firstName, String lastName, String email, Account account, Product2 product, String homeCountry, String uuid, Boolean isInsert) {
        Contact contact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            AccountId = account.Id,
            Product__c = product.Id,
            Home_Country__c = homeCountry,
            UUID__c = uuid
        );
        if(isInsert){
           insert contact; 
        }
        return contact;
    }

    public static ServiceContract createServiceContract(Account account, Contact contact, Pricebook2 pricebook, String status, Integer term) {
        ServiceContract contract = new ServiceContract(
            AccountId = account.Id,
            ContactId = contact.Id,
            Name = 'TestContract',
            Contract_Status__c = status,
            Service_Country__c = 'DE',
            Term = term,
            Pricebook2Id = pricebook.Id
        );
        insert contract;
        return contract;
    }

    public static ContractLineItem createContractLineItem(ServiceContract contract, PricebookEntry pbe, Decimal atmFee, Decimal cardReplacementCost, Decimal costPerMonth) {
        ContractLineItem cli = new ContractLineItem(
            ServiceContractId = contract.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 1,
            UnitPrice = 1,
            ATM_Fee_in_other_currencies__c = atmFee,
            Card_Replacement_Cost__c = cardReplacementCost,
            Cost_per_Calendar_Month__c = costPerMonth
        );
        insert cli;
        return cli;
    }
}