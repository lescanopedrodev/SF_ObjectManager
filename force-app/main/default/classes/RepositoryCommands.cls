/**
 * @description Interfaz que contiene todos los comandos esenciales para un repositorio
 * @Date 7 June 2025
 * @author Pedro Lescano
 */
public interface RepositoryCommands {
    List<SObject> findAll();
    SObject findRecordById(Id id);
    void saveRecord(SObject entity);
    void deleteRecord(Id id);
    void updateRecord(SObject entity);
}