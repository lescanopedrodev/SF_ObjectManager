/**
 * @description Clase manager para crear objetos, wrappers y errores
 * @Date 7 June 2025
 * @author Pedro Lescano
 */
@SuppressWarnings('PMD')
public virtual with sharing class SObjectManager {
    
    private static Integer SUCCESS_CODE = 200;
    private static Integer ERROR_CODE = 500;
    
    /**
     * @description Método genérico para generar un nuevo SObject a partir de los datos recibidos 
     * @Date 7 June 2025
     * @param builder ObjectBuilder
     * @return SObject
     */
    public static SObject buildSObject(ObjectBuilder builder) {
        if (builder == null || builder.objectType == null) {
            throw new CustomException('El builder o el tipo de objeto especificado son nulos.');
        }
        
        Map<String, Object> objectFields = builder.objectFields;
        Schema.SObjectType objectType = builder.objectType;
        
        SObject sObjectInstance = objectType.newSObject();
        Map<String, Schema.SObjectField> validFields = objectType.getDescribe().fields.getMap();
        
        for (String fieldName : objectFields.keySet()) {
            if (!validFields.containsKey(fieldName)) {
                throw new CustomException('Campo inválido: ' + fieldName);
            }
            
            Object value = objectFields.get(fieldName);
            
            if (!validateField(fieldName, value, validFields)) {
                throw new CustomException('Valor inválido para el campo: ' + fieldName);
            }
            
            try {
                sObjectInstance.put(fieldName, value);
            } catch (Exception ex) {
                throw new CustomException('Error al colocar el campo: ' + fieldName + ' - ' + ex.getMessage());
            }
        }
        
        return sObjectInstance;
    }
    
    /**
     * @description Valida si el dato a guardar en un campo es válido
     * @Date 7 June 2025
     * @param fieldName String
     * @param value Object
     * @param fieldsMap Map<String, Schema.SObjectField>
     * @return Boolean
     */
    private static Boolean validateField(String fieldName, Object value, Map<String, Schema.SObjectField> fieldsMap) {
        if (value == null) {
            return false;
        }
        
        if (!fieldsMap.containsKey(fieldName)) {
            return false;
        }
        
        Schema.DescribeFieldResult describe = fieldsMap.get(fieldName).getDescribe();
        
        if (describe.getType() == Schema.DisplayType.String || describe.getType() == Schema.DisplayType.TextArea) {
            String valueStr = String.valueOf(value);
            Integer maxLength = describe.getLength();
            return valueStr.length() <= maxLength;
        }
        
        return true;
    }
    
    /**
     * @description Devuelve un mensaje de error en base a la excepción recibida
     * @Date 7 June 2025
     * @param ex Exception
     * @return String
     */
    public static String initializeErrorMessage(Exception ex){
        return 'The following error ocurred: ' + ex.getMessage() + ' | ' + ex.getStackTraceString();
    }
    
    /**
     * @description Objeto wrapper para generar un SObject en base al tipo de objeto y los campos recibidos
     * @Date 7 June 2025
     */
    public class ObjectBuilder{
        @AuraEnabled public Map<String, Object> objectFields {get; set;}
        @AuraEnabled public Schema.SObjectType objectType {get; set;}
        
        public ObjectBuilder(){
            this.objectFields = new Map<String, Object>();
        }
        
        public ObjectBuilder(Schema.SObjectType objectType, Map<String, Object> objectFields){
            this.objectType = objectType;
            this.objectFields = objectFields;
        }
    }
    
    /**
     * @description Objeto wrapper para obtener los datos recibidos desde el invocador
     * @Date 7 June 2025
     */
    public class RequestWrapper{
        @AuraEnabled public Map<String, Object> values { get; set; }
        
        public RequestWrapper(){}
        
        public RequestWrapper(Map<String, Object> values){
            this.values = values;
        }
    }
    
    /**
     * @description Objeto wrapper para devolver los datos procesados al invocador
     * @Date 7 June 2025
     */
    public class ResponseWrapper{
        @AuraEnabled public Integer status { get; set; }
        @AuraEnabled public Map<String, Object> values { get; set; }
        @AuraEnabled public String message { get; set; }
        @AuraEnabled public String stacktrace { get; set; }
        
        public ResponseWrapper(Map<String, Object> values){
            this.values = values;
            this.initializeSuccessResponse();
        }
        
        public ResponseWrapper(Boolean success){
            if(success){
                initializeSuccessResponse();
            }else{
                initializeErrorResponse();
            }
        }
        
        public ResponseWrapper(Integer status, String message){
            this.status = status;
            this.message = message;
        }
        
        public ResponseWrapper(Integer status, String message, String stacktrace){
            this.status = status;
            this.message = message;
            this.stacktrace = stacktrace;
        }
        
        public ResponseWrapper(Integer status, String message, String stacktrace, Map<String, Object> values){
            this.status = status;
            this.message = message;
            this.stacktrace = stacktrace;
            this.values = values;
        }
        
        public void initializeSuccessResponse(){
            this.status = SUCCESS_CODE;
            this.message = 'The operation has completed successfully!';
        }
        
        public void initializeErrorResponse(){
            this.status = ERROR_CODE;
            this.message = 'An error has occurred!';
        }
    }

    /**
     * @description Objeto wrapper para manejar excepciones especiales
     * @Date 7 June 2025
     */
    public class CustomException extends Exception{
        @AuraEnabled public String message {get; set;}
        @AuraEnabled public String stacktrace {get; set;}
        
        public CustomException(String message, String stacktrace){
            this.message = message;
            this.stacktrace = stacktrace;
        }
    }
}