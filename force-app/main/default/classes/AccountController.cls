/**
 * @description Clase controladora para objeto Account
 * @Date 7 June 2025
 * @author Pedro Lescano
 */
public with sharing class AccountController extends SObjectManager {
    
    private static final String OBJECT_NAME = 'Account';
    
    /**
     * @description Crea un objeto Account y lo guarda en base a los datos recibidos.
     * @Date 7 June 2025
     * @param builder ObjectBuilder
     * @return ResponseWrapper
     */
    @AuraEnabled
    public static ResponseWrapper saveAccount(ObjectBuilder builder){
        ResponseWrapper responseWrapper;
        try{
            SObject account = buildSObject(builder);
            AccountRepository.saveRecord(account);
            responseWrapper = new ResponseWrapper(true);
        } catch (CustomException ex) {
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        } catch (Exception ex){
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        }
        return responseWrapper;
    }

    /**
     * @description Crea un objeto Account con una Id especificada del front y la actualiza en la base de datos.
     * @Date 9 June 2025
     * @param builder ObjectBuilder
     * @return ResponseWrapper
     */
    @AuraEnabled
    public static ResponseWrapper updateAccount(ObjectBuilder builder){
        ResponseWrapper responseWrapper;
        try{
            SObject account = buildSObject(builder);
            AccountRepository.updateRecord(account);
            responseWrapper = new ResponseWrapper(true);
        } catch (CustomException ex) {
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        } catch (Exception ex){
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        }
        return responseWrapper;
    }
    
    /**
     * @description Devuelve un objeto de tipo Account en base a un Id especificado
     * @Date: 7 June 2025
     * @param requestWrapper RequestWrapper
     * @return ResponseWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ResponseWrapper getAccountById(RequestWrapper requestWrapper){
        ResponseWrapper responseWrapper;
        Map<String, Object> requestValues = requestWrapper.values;
        Id accountId = String.valueOf(requestValues.get('accountId'));
        try{
            Account account = (Account) AccountRepository.findRecordById(accountId);
            Map<String, Object> responseValues = new Map<String, Object>();
            responseValues.put('account', account);
            
            responseWrapper = new ResponseWrapper(responseValues);
        } catch (Exception ex) {
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        }
        return responseWrapper;
    }
    
    /**
     * @description Devuelve todos los objetos de tipo Account que se encuentren guardados
     * @Date: 7 June 2025
     * @return ResponseWrapper
     */
    @AuraEnabled(cacheable=true)
    public static ResponseWrapper getAccounts(){
        ResponseWrapper responseWrapper;
        try{
            List<Account> accounts = (List<Account>) AccountRepository.findAll();
            Map<String, Object> responseValues = new Map<String, Object>();
            responseValues.put('accounts', tableWrapAccounts(accounts));
            
            responseWrapper = new ResponseWrapper(responseValues);
        } catch (CustomException ex) {
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        } catch (Exception ex) {
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        }
        return responseWrapper;
    }
    
    /**
     * @description Elimina un objeto de tipo Account de la base de datos según el Id recibido
     * @Date 8 June 2025
     * @param requestWrapper RequestWrapper
     * @return ResponseWrapper
     */
    @AuraEnabled
    public static ResponseWrapper deleteAccount(RequestWrapper requestWrapper){
        ResponseWrapper responseWrapper;
        Map<String, Object> requestValues = requestWrapper.values;
        Id accountId = String.valueOf(requestValues.get('accountId'));
        try{
            AccountRepository.deleteRecord(accountId);
            responseWrapper = new ResponseWrapper(true);
        } catch (Exception ex) {
            responseWrapper = new ResponseWrapper(500, ex.getMessage(), ex.getStackTraceString());
        }
        return responseWrapper;
    }
    
    /**
     * @description Encapsula todos los objetos de tipo Account y los devuelve en tipo tabla de Account
     * @Date: 7 June 2025
     * @param accounts List<Account>
     * @return AccountTableWrapper
     */
    public static AccountTableWrapper tableWrapAccounts(List<Account> accounts){
        AccountTableWrapper tableWrapper = new AccountTableWrapper();
        try{
            tableWrapper.setColumns(getAccountTableColumns());
            tableWrapper.setRows(getAccountTableRows(accounts));
        }catch(Exception ex){
            throw new CustomException('Error on wrapping table: ' + ex.getMessage() + ex.getStackTraceString());
        }
        return tableWrapper;
    }
    
    /**
     * @description Encapsula todos los registros encontrados de Account y los devuelve en el formato Row para la tabla de Account
     * @Date: 7 June 2025
     * @param accounts List<Account>
     * @return List<AccountTableRow>
     */
    public static List<AccountTableRow> getAccountTableRows(List<Account> accounts){
        List<AccountTableRow> tableRows = new List<AccountTableRow>();
        for(Account account : accounts){
            tableRows.add(new AccountTableRow(account.Id, account.Name, account.Description));
        }
        return tableRows;
    }
    
    /**
     * @description Devuelve todas las columnas disponibles para la tabla de Account
     * @Date: 7 June 2025
     * @return List<AccountTableColumn>
     */
    public static List<AccountTableColumn> getAccountTableColumns(){
        List<AccountTableColumn> columns = new List<AccountTableColumn>();
        for (TableColumnUtils.TableColumnMetadata mdt : TableColumnUtils.getValuesBySpecifiedObject(OBJECT_NAME)) {
            if(mdt.type == 'action'){
                columns.add(new AccountTableColumn(mdt));
            }else{
                columns.add(new AccountTableColumn(mdt.fieldName, mdt.label, mdt.type));
            }
        }
        return columns;
    }
    
    /**
     * @description Objeto Wrapper para devolver una respuesta en formato de tabla
     * @Date: 7 June 2025
     */
    public class AccountTableWrapper extends TableManager{
        @AuraEnabled public List<AccountTableRow> rows {get; set;}
        @AuraEnabled public List<AccountTableColumn> columns {get; set;}
        
        public AccountTableWrapper(){
            this.rows = new List<AccountTableRow>();
            this.columns = new List<AccountTableColumn>();
        }
        
        public override void setRows(List<Object> rows){
            this.rows = (List<AccountTableRow>) rows;
        }
        
        public override void setColumns(List<Object> columns){
            this.columns = (List<AccountTableColumn>) columns;
        }
        
        public override void addRow(Object row){
            this.rows.add((AccountTableRow) row);
        }
        
        public override void addColumn(Object column){
            this.columns.add((AccountTableColumn) column);
        }
        
        public Integer getTableSize(){
            return this.rows.size();
        }
    }
    
    /**
     * @description Objeto Wrapper para encapsular datos en Row
     * @Date: 7 June 2025
     */
    public class AccountTableRow extends TableManager.TableRow{
        @AuraEnabled public String id {get; set;}
        @AuraEnabled public String name {get; set;}
        @AuraEnabled public String description {get; set;}
        
        public AccountTableRow(String id, String name, String description){
            this.id = id ?? '-';
            this.name = name ?? '-';
            this.description = description ?? '-';
        }
    }
    
    /**
     * @description Objeto Wrapper para encapsular datos en Column
     * @Date: 7 June 2025
     */
    public class AccountTableColumn extends TableManager.TableColumn{
        
        public AccountTableColumn(TableColumnUtils.TableColumnMetadata mdt){
            constructActionColumn(mdt);
        }
        
        public AccountTableColumn(String fieldName, String label){
            this.fieldName = fieldName;
            this.label = label;
        }
        
        public AccountTableColumn(String fieldName, String label, String type){
            this.fieldName = fieldName;
            this.label = label;
            this.type = type;
        }
        
        public void constructActionColumn(TableColumnUtils.TableColumnMetadata mdt){
            List<Map<String, Object>> actions = new List<Map<String, Object>>();
            List<String> actionsNames = mdt.actionsNames.split(',');
            List<String> actionsLabels = mdt.actionsLabels.split(',');
            for (Integer i = 0; i < actionsNames.size(); i++){
                actions.add(new Map<String,Object>{'name' => actionsNames[i], 'label' => actionsLabels[i]});
            }
            
            this.type = mdt.type;
            this.typeAttributes = new Map<String, Object>{ 'rowActions' => actions, 'menuAlignment' => 'right'};
        }
        
    }
}