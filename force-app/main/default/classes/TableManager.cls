/**
 * @description Clase abstracta para manejo de tablas 
 * @Date 7 June 2025
 */
public abstract with sharing class TableManager{
    
    public abstract void setRows(List<Object> rows);
    
    public abstract void setColumns(List<Object> columns);
    
    public abstract void addRow(Object row);
    
    public abstract void addColumn(Object row);

    public abstract class TableRow {}
    
    public abstract class TableColumn{
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String fieldName {get; set;}
        @AuraEnabled public String label {get; set;}
        @AuraEnabled public String type {get; set;}
        @AuraEnabled public Map<String, Object> typeAttributes {get; set;}
        @AuraEnabled public Map<String, Object> cellAttributes {get; set;}
    }
}