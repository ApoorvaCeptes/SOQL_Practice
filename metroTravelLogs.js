import { LightningElement, wire, track } from 'lwc';
import getTravelLogs from '@salesforce/apex/MetroTravelAppController.getTravelLogs';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Customer', fieldName: 'CustomerName', type: 'text' },
    { label: 'Metro Card', fieldName: 'MetroCardName', type: 'text' },
    { label: 'Source Station', fieldName: 'SourceStationName', type: 'text' },
    { label: 'Destination Station', fieldName: 'DestinationStationName', type: 'text' },
    { label: 'Travel Date/Time', fieldName: 'Travel_Date_Time__c', type: 'date' },
    { label: 'Calculated Fare', fieldName: 'Calculated_Fare__c', type: 'currency' },
];

export default class MetroTravelLogs extends LightningElement {
   @track data = [];
    columns = COLUMNS;
    selectedRows = [];
    error;

    @wire(getTravelLogs)
    wiredTravelLogs({ error, data }) {
        if (data) {
            console.log("Data from apex", data)
            this.data = data.map(record => ({
                ...record,
                CustomerName: record.Customer__r ? record.Customer__r.Name : '',
                MetroCardName: record.Metro_Card__r ? record.Metro_Card__r.Name : '',
                SourceStationName: record.Metro_Station__r ? record.Metro_Station__r.Name : '',
                DestinationStationName: record.Destination_Station__r ? record.Destination_Station__r.Name : '',
            }));
            this.error = undefined;
            this.showToast('Travel logs', "Records Fetched successfully", 'success');
        } else if (error) {
            this.error = error;
            this.data = [];
            this.showToast('Error', error.body.message, 'error');
        }
    }

    handleRowSelection(event) {
        console.log("Selected rows" , event.detail.selectedRows)
        const selectedRows = event.detail.selectedRows;
        this.selectedRows = selectedRows.map(row => row.Id);
    }

    // handleDelete() {
    //     if (this.selectedRows.length > 0) {
    //         deleteTravelLogs({ logIds: this.selectedRows })
    //             .then(() => {
    //                 return this.refreshData();
    //             })
    //             .catch(error => {
    //                 this.error = error;
    //                 console.error('Error deleting records:', error);
    //             });
    //     } else {
    //         alert('Please select records to delete.');
    //     }
    // }

    // refreshData() {
    //     return getTravelLogs()
    //         .then(data => {
    //             this.data = data;
    //         })
    //         .catch(error => {
    //             this.error = error;
    //             this.data = [];
    //         });
    // }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title, 
            message: message, 
            variant: variant, 
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }
}