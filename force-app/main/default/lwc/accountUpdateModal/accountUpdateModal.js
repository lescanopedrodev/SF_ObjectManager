import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import updateAccount from '@salesforce/apex/AccountController.updateAccount';

export default class AccountUpdateModal extends LightningModal {
    @api data;

    get accountId() {
        return this.data?.id;
    }

    get isEdited() {
        return this.data !== this.update_data;
    }

    closeModal() {
        this.close(501);
    }

    update_data;

    connectedCallback() {
        this.update_data = this.data;
    }

    handleDataUpdate({ detail: { value } }) {
        this.update_data = value;
    }

    async handleUpdate() {
        const build = { objectFields: { ...this.update_data }, objectType: 'Account' };
        const response = await updateAccount({ builder: build });
        this.close(response?.status);
    }
}