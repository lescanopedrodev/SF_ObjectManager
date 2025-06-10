import { LightningElement, api } from 'lwc';

export default class AccountInfo extends LightningElement {
    @api data;

    @api view;

    get name() {
        return this.data?.name ?? '';
    }

    get description() {
        return this.data?.description ?? '';
    }

    handleChange({ detail: { value }, target: { name } }) {
        try {
            const updated_data = {
                ...this.data ?? {},
                [name]: value
            };
            this.dispatchEvent(new CustomEvent('dataupdate', { detail: { value: updated_data } }));
        } catch (ex) {
            console.error(ex.message);
        }
    }
}