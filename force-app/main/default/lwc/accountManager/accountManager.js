import { LightningElement, wire, api } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import saveAccount from '@salesforce/apex/AccountController.saveAccount';
import getAccountById from '@salesforce/apex/AccountController.getAccountById';

export default class AccountManager extends LightningElement {

    @wire(getAccounts)
    getAccountsData({ data, error }) {
        if (data == undefined && error == undefined) {
            console.log('Cargando conexión con Apex');
            return;
        }

        if (error) {
            console.error(error);
            this.error = error;
            return;
        }

        if (data?.status != 200) {
            console.error(data?.message);
            console.error(data?.stacktrace);
            this.error = data?.message;
            return;
        }

        this.accountsData = data;
    }

    accountsData;

    handleButton() {
        console.log(this.accountsData);
    }
}