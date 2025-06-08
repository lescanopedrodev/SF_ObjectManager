public with sharing class ContactController extends SObjectManager {
    
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