import { LightningElement, wire, api } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import AccountDeleteModal from 'c/accountDeleteModal';
import AccountUpdateModal from 'c/accountUpdateModal';
import AccountSaveModal from 'c/accountSaveModal';

const AlertToasts = {
    error: {
        title: 'Operación cancelada',
        message: 'Ha ocurrido un error al procesar la operación.'
    },
    warning: {
        title: 'Operación cancelada',
        message: 'Se ha cancelado la operación.'
    },
    success: {
        title: 'Operación exitosa',
        message: 'Se ha completado correctamente la operación.'
    }
}

export default class AccountManager extends LightningElement {

    @wire(getAccounts)
    accountsData;

    get accountsProcessedError() {
        return this.accountsData?.error;
    }

    get accountsProcessedData() {
        return this.accountsData?.data ?? {};
    }

    get tableData() {
        return this.accountsProcessedData?.values?.accounts ?? {};
    }

    async handleAccountSave() {
        const response = await AccountSaveModal.open();
        if (response == 500) {
            this.showToast('error');
            return;
        }

        if (response == 200) {
            this.showToast('success');
            refreshApex(this.accountsData);
            return;
        }

        this.showToast('warning');
    }

    async handleAccountDelete({ detail: { data } }) {
        const response = await AccountDeleteModal.open({ data });
        if (response == 500) {
            this.showToast('error');
            return;
        }

        if (response == 200) {
            this.showToast('success');
            refreshApex(this.accountsData);
            return;
        }

        this.showToast('warning');
    }

    async handleAccountUpdate({ detail: { data } }) {
        const response = await AccountUpdateModal.open({ data });
        if (response == 500) {
            this.showToast('error');
            return;
        }

        if (response == 200) {
            this.showToast('success');
            refreshApex(this.accountsData);
            return;
        }

        this.showToast('warning');
    }

    showToast(variant) {
        const { title, message } = AlertToasts[variant];
        const toastEvent = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(toastEvent);
    }
}