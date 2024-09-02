@isTest
public class ProductOverviewControllerTest {
    @testSetup
    static void setupTestData() {
        
        // Create a test Product
        Product2 serviceProduct = TestDataFactory.createProduct('TestPlatinum', true);
        // Create a test Pricebook
        Pricebook2 testPricebook = TestDataFactory.createPricebook('DE', true);
        
        // Create PricebookEntry for the service product
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        PricebookEntry testPBE1 = TestDataFactory.createPricebookEntry(
            serviceProduct, Test.getStandardPricebookId(), null, null, null, false
        );
        
        PricebookEntry testPBE2 = TestDataFactory.createPricebookEntry(
            serviceProduct, testPricebook.Id, 500, 200, 300, false
        );
        pbeList.add(testPBE1);
        pbeList.add(testPBE2);
        insert pbeList;

        // Create a test Account
        List<Account> accList = new List<Account>();
        Account testServiceAcc = TestDataFactory.createAccount('Test Service Account', false);
        Account testNonServiceAcc = TestDataFactory.createAccount('Test Non Service Account', false);
		accList.add(testServiceAcc);
        accList.add(testNonServiceAcc);
        insert accList;
        
        // Create a test Contact
        List<Contact> conList = new List<Contact>();
        Contact serviceContact = TestDataFactory.createContact(
            'Test', 'Service Contact', 'test@test.com', testServiceAcc, serviceProduct, 'DE', null, false
        );

        Contact nonServiceContact = TestDataFactory.createContact(
            'Test', 'Non Service Contact', 'test@test.com', testNonServiceAcc, serviceProduct, 'DE', null, false
        );
        conList.add(serviceContact);
        conList.add(nonServiceContact);
        insert conList;

        // Create a test ServiceContract
        ServiceContract testContract = TestDataFactory.createServiceContract(
            testServiceAcc, serviceContact, testPricebook, 'Activated', 12
        );

        // Create a test ContractLineItem
        TestDataFactory.createContractLineItem(
            testContract, testPBE2, 500, 200, 300
        );
    }

    @isTest
    static void testGetProductDataWithActiveContracts() {
        Contact con = [SELECT Id FROM Contact WHERE NAME = 'Test Service Contact' LIMIT 1];

        Map<String, Object> result = ProductOverviewController.getProductData(con.Id);

        System.assertEquals(true, (Boolean)result.get(Constants.CONTRACT_EXISTS), 'Contract with applicable service product should exist for the service contact.');
    }
    
    @isTest
    static void testGetProductDataWithOutActiveContracts() {
        Contact con = [SELECT Id FROM Contact WHERE NAME = 'Test Non Service Contact' LIMIT 1];

        Map<String, Object> result = ProductOverviewController.getProductData(con.Id);

        System.assertEquals(false, (Boolean)result.get(Constants.CONTRACT_EXISTS), 'Contract with applicable service product should not exist for the non-service contact.');
    }
}