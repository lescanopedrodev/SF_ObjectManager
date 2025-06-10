/**
 * @description Clase para manejo de la metadata TableColumn
 * @Date 7 June 2025
 * @author Pedro Lescano
 */
public with sharing class TableColumnUtils {
    
    /**
     * @description Obtiene los valores de TableColumn según el campo SpecifiedObject
     * @Date 7 June 2025
     * @param specifiedObject String
     * @return List<TableColumnMetadata>
     */
    public static List<TableColumnMetadata> getValuesBySpecifiedObject(String specifiedObject){
        Map<String, TableColumn__mdt> mdtRecords = TableColumn__mdt.getAll();
        List<TableColumnMetadata> wrapperList = new List<TableColumnMetadata>();
        
        for (TableColumn__mdt mdt : mdtRecords.values()) {
            if (mdt.SpecifiedObject__c == specifiedObject) {
                wrapperList.add(new TableColumnMetadata(mdt));
            }
        }

        wrapperList.sort();

        return wrapperList;
    }
    
    /**
     * @description Objeto wrapper para devolver la metadata encontrada
     * @Date 7 June 2025
     */
    @SuppressWarnings('PMD.EmptyStatementBlock, PMD.ExcessiveParameterList')
    public class TableColumnMetadata implements Comparable{
        @AuraEnabled public String fieldName {get; set;}
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String type {get; set;}
        @AuraEnabled public Decimal order {get; set;}
        @AuraEnabled public String actionsLabels {get; set;}
        @AuraEnabled public String actionsNames {get; set;}
        
        
        public TableColumnMetadata(){}
        
        public TableColumnMetadata(TableColumn__mdt mdt){
            this.fieldName = mdt.FieldName__c;
            this.label = mdt.Label__c;
            this.type = mdt.Type__c;
            this.order = mdt.Order__c;
            this.actionsLabels = mdt.ActionsLabels__c;
            this.actionsNames = mdt.ActionsNames__c;
        }
        
        public TableColumnMetadata(String fieldName, String label, String type){
            this.fieldName = fieldName;
            this.label = label;
            this.type = type;
        }
        
        public TableColumnMetadata(String fieldName, String label, String type, Decimal order){
            this.fieldName = fieldName;
            this.label = label;
            this.type = type;
            this.order = order;
        }
        
        public Integer compareTo(Object obj) {
            TableColumnMetadata other = (TableColumnMetadata) obj;
            
            if (this.order == null && other.order == null) {
                return 0;
            }
            if (this.order == null) {
                return -1;
            }
            if (other.order == null) {
                return 1;
            }
            if (this.order < other.order) {
                return -1;
            }
            if (this.order > other.order) {
                return 1;
            }
            return 0;
        }
    }
}