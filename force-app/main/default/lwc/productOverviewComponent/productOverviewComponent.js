import { LightningElement,api,wire} from 'lwc';
import getProductData from '@salesforce/apex/ProductOverviewController.getProductData';
import { getRecord } from 'lightning/uiRecordApi';
import CONTACT_ID from '@salesforce/schema/Case.ContactId';

export default class ProductOverviewComponent extends LightningElement {
    @api recordId;
    contactId;
    productData;
    contractExist;
    @wire(getRecord, { recordId: '$recordId',fields: CONTACT_ID } )
        wiredRecord({ error, data }) {
            if (error) {
                console.error(error);
            } else if (data) {
                this.contactId = data.fields.ContactId.value;
            }
    }
    @wire(getProductData,{recId: '$contactId'})
        productData({error,data}){
            if(data){
                this.contractExist = data.ContractExist;
                this.productData = data.ProductInfo;
            }else if(error){
                console.error('Error Occured',error);
            }
    }
}