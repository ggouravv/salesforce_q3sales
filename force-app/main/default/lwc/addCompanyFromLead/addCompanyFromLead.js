import { LightningElement, track, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class ModalPopupLWC extends NavigationMixin(LightningElement) {
   
    navigateToNewRecordPage() {
        // Opens the new Company record modal
        // to create an Company.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Company__c',
                actionName: 'new'
            },
            state: {
                navigationLocation: 'RELATED_LIST'
            }
        });
    }
}