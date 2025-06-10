import LightningModal from 'lightning/modal';
import saveAccount from '@salesforce/apex/AccountController.saveAccount';

export default class AccountSaveModal extends LightningModal {

    create_data = {};

    handleDataUpdate({ detail: { value } }) {
        this.create_data = value;
    }

    async handleSave() {
        const build = { objectFields: { ...this.create_data }, objectType: 'Account' };
        const response = await saveAccount({ builder: build });
        this.close(response?.status);
    }
}