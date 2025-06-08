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
                wrapperList.add(new TableColumnMetadata(mdt.FieldName__c, mdt.Label__c, mdt.Type__c));
            }
        }

        return wrapperList;
    }

    /**
     * @description Objeto wrapper para devolver la metadata encontrada
     * @Date 7 June 2025
     */
    public class TableColumnMetadata{
        @AuraEnabled public String fieldName {get; set;}
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String type {get; set;}

        public TableColumnMetadata(String fieldName, String label, String type){
            this.fieldName = fieldName;
            this.label = label;
            this.type = type;
        }
    }
}