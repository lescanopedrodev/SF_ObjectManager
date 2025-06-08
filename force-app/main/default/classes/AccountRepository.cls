/**
 * @description Repositorio para objeto Account
 * @Date 7 June 2025
 * @author Pedro Lescano
 */
@SuppressWarnings('PMD')
public with sharing class AccountRepository implements RepositoryCommands {

    /**
     * @description Guarda un objeto de tipo Account en la base de datos
     * @Date 7 June 2025
     * @param account SObject
     * @return void
     */
    public static void saveRecord(SObject account){
        insert (Account) account;
    }
    
    /**
     * @description Devuelve todos los registros de Account en la base de datos
     * @Date 7 June 2025
     * @return List<SObject>
     */
    public static List<SObject> findAll(){
        return [SELECT Id, Name, Description FROM Account];
    }
    
    /**
     * @description Devuelve un registro de Account en la base de datos en base a un Id especificado
     * @Date 7 June 2025
     * @param accountId Id
     * @return SObject
     */
    public static SObject findRecordById(Id accountId){
        return [SELECT Id, Name, Description FROM Account WHERE Id = :accountId LIMIT 1];
    }
    
    /**
     * @description Elimina un registro de Account de la base de datos según el Id especificado
     * @Date 7 June 2025
     * @param accountId Id
     * @return void
     */
    public static void deleteRecord(Id accountId){
        Database.delete(accountId);
    }
}