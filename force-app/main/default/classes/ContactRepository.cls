@SuppressWarnings('PMD')
public with sharing class ContactRepository implements RepositoryCommands {

    public static void saveRecord(SObject contact){
        insert (Contact) contact;
    }
    
    public static List<SObject> findAll(){
        return [SELECT Id, Name FROM Contact];
    }
    
    public static SObject findRecordById(Id contactId){
        return [SELECT Id, Name FROM Contact WHERE Id = :contactId LIMIT 1];
    }
    
    public static void deleteRecord(Id contactId){
        Database.delete(contactId);
    }
}