/**
 * @description Repositorio para objeto Contact
 * @Date 9 June 2025
 * @author Pedro Lescano
 */
@SuppressWarnings('PMD')
public with sharing class ContactRepository implements RepositoryCommands {

    /**
     * @description Guarda un objeto de tipo Contact en la base de datos
     * @Date 9 June 2025
     * @param account SObject
     * @return void
     */
    public static void saveRecord(SObject contact){
        insert (Contact) contact;
    }

    /**
     * @description Actualiza un objeto de tipo Contact en la base de datos
     * @Date 9 June 2025
     * @param account SObject
     * @return void
     */
    public static void updateRecord(SObject contact){
        update contact;
    }
    
    /**
     * @description Devuelve todos los registros de Contact en la base de datos
     * @Date 9 June 2025
     * @return List<SObject>
     */
    public static List<SObject> findAll(){
        return [SELECT Id, Name FROM Contact];
    }
    
    /**
     * @description Devuelve un registro de Contact en la base de datos en base a un Id especificado
     * @Date 9 June 2025
     * @param accountId Id
     * @return SObject
     */
    public static SObject findRecordById(Id contactId){
        return [SELECT Id, Name FROM Contact WHERE Id = :contactId LIMIT 1];
    }
    
    /**
     * @description Elimina un registro de Contact de la base de datos según el Id especificado
     * @Date 9 June 2025
     * @param accountId Id
     * @return void
     */
    public static void deleteRecord(Id contactId){
        Database.delete(contactId);
    }
}