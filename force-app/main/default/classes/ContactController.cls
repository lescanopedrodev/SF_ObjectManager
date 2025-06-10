/**
 * @description Repositorio para objeto Contact
 * @Date 9 June 2025
 * @author Pedro Lescano
 */
public with sharing class ContactController extends SObjectManager {
    
    /**
     * @description Crea un objeto Contact y lo guarda en base a los datos recibidos.
     * @Date 9 June 2025
     * @param builder ObjectBuilder
     * @return ResponseWrapper
     */
    public static ResponseWrapper saveContact(ObjectBuilder builder){
        ResponseWrapper wrapper;
        try{
            SObject contact = buildSObject(builder);
            ContactRepository.saveRecord(contact);
            wrapper = new ResponseWrapper(true);
        } catch (CustomException ex) {
            wrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        }
        return wrapper;
    }
}