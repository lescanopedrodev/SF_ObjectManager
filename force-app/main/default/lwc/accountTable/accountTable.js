import { LightningElement, api } from 'lwc';

export default class AccountTable extends LightningElement {

    @api tableData;

    get columns() {
        return this.tableData?.columns ?? [];
    }

    get rows() {
        return this.tableData?.rows ?? [];
    }

    handleRowAction({ detail: { action: { name }, row } }) {
        this.dispatchEvent(new CustomEvent(name, { detail: { data: row } }));
    }
}