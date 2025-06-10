import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import deleteAccount from '@salesforce/apex/AccountController.deleteAccount';

export default class AccountDeleteModal extends LightningModal {
    @api data;

    get accountId() {
        return this.data?.id;
    }

    closeModal() {
        this.close(501);
    }

    async handleDelete() {
        const wrapper = { values: { accountId: this.accountId } };
        const response = await deleteAccount({ requestWrapper: wrapper });
        this.close(response?.status);
    }
}