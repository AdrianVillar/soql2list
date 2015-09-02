@isTest
private class oraTest {
	
	static testMethod void testCRUD() {
		String accName = 'Test1';
		String accNumber = '1234';

		// String field values
		Id id = testCreate(accName, accNumber, '"AnnualRevenue" : 1000000,' +
		                '"NumberOfEmployees" : 1000,' +
		                '"Phone" : "(111) 222-3333"');
		testQuery(accName, accNumber);
    }
    
	@isTest static void testDescribe() {
		// Assume we have accounts
		String jsonResult = ora.describe('Account');

		System.assertNotEquals(null, jsonResult,
		                       'ora.describe returned null');

		Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(jsonResult);

		System.assertNotEquals(null, result.get('fields'),
		                       'fields property missing from ora.describe result');

		// TODO - more assertions on describe results

		// Invalid object type
		// Hope there isn't a QXZXQZXZQXZQ object type!
		jsonResult = ora.describe('QXZXQZXZQXZQ');
		assertError(jsonResult, 'NOT_FOUND', 'ora.describe');
	}
    
    	static private void assertError(String jsonResult, String expectedError, String method) {
		system.debug('##################' + jsonResult);
		List<Object> errorArray = (List<Object>)JSON.deserializeUntyped(jsonResult);

		System.assertNotEquals(null, errorArray,
		                       'error array missing from ' + method + ' result');
		System.assertNotEquals(0, errorArray.size(),
		                       'error array is empty in ' + method + ' result');

		Map<String, Object> error = (Map<String, Object>)errorArray[0];
		String errorCode = (String)error.get('errorCode');
		System.assertNotEquals(null, errorCode,
		                       'errorCode property missing from ' + method + ' result');
		System.assertEquals(expectedError, errorCode,
		                    'errorCode should be ' + expectedError + ' in ' + method + ' result');
	}
    
    	static private void testQuery(String accName, String accNumber) {
		String jsonResult = ora.query('SELECT Id, Name, AccountNumber FROM Account WHERE Name = \'' + accName + '\'');

		System.assertNotEquals(null, jsonResult,
		                       'ora.query returned null');

		Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(jsonResult);

		List<Object> records = (List<Object>)result.get('records');
		System.assertNotEquals(null, records,
		                       'records property missing from ora.query result');
		System.assertEquals(1, records.size(),
		                    'records array should have single record in ora.query result');

		Map<String, Object> record = (Map<String, Object>)records[0];

		assertRecord(record, accName, accNumber, 'ora.query');

		Integer totalSize = (Integer)result.get('totalSize');
		System.assertNotEquals(null, totalSize,
		                       'totalSize property missing from ora.query result');
		System.assertEquals(1, totalSize,
		                    'totalSize should be 1 in ora.query result');

		Boolean done = (Boolean)result.get('done');
		System.assertNotEquals(null, done,
		                       'done property missing from ora.query result');
		System.assertEquals(true, done,
		                    'done should be true in ora.query result');

		jsonResult = ora.query('SSSSSS Id, Name FROM Account WHERE Name = \'' + accName + '\'');
		assertError(jsonResult, 'INVALID_QUERY', 'ora.query');
	}
    
    static private Id testCreate(String accName, String accNumber, String fields) {
		// Assume we can create an account

		// Try with data in correct types
		String jsonResult = ora.create('Account',
		                    '{"Name": "' + accName + '", ' +
		                    '"AccountNumber" : "' + accNumber + '",' +
		                    fields + '}');

		System.assertNotEquals(null, jsonResult,
		                       'ora.create returned null');

		Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(jsonResult);

		Boolean success = (Boolean)result.get('success');
		System.assertNotEquals(null, success,
		                       'success property missing from ora.create result');
		System.assertNotEquals(false, success,
		                       'success is false in ora.create result');

		List<Object> errors = (List<Object>)result.get('errors');
		System.assertNotEquals(null, errors,
		                       'errors property missing from ora.create result');
		System.assertEquals(0, errors.size(),
		                    'errors array is not empty in ora.create result');

		Id id = (Id)result.get('id');
		System.assertNotEquals(null, id,
		                       'id property missing from ora.create result');
		Account account = [SELECT Id, Name, AccountNumber FROM Account LIMIT 1];
		System.assertNotEquals(null, account,
		                       'Couldn\'t find account record created by ora.create result');
		System.assertEquals(accName, account.Name,
		                    'Account name doesn\'t match in ora.create result');
		System.assertEquals(accNumber, account.AccountNumber,
		                    'Account number doesn\'t match in ora.create result');

		jsonResult = ora.create('QXZXQZXZQXZQ', '{"Name": "' + accName + '"}');
		assertError(jsonResult, 'NOT_FOUND', 'ora.create');

		jsonResult = ora.create('Account', '{"Name" "' + accName + '"}');
		assertError(jsonResult, 'JSON_PARSER_ERROR', 'ora.create');

		jsonResult = ora.create('Account', '{"XQZXQZXQZXQZ" : "' + accName + '"}');
		assertError(jsonResult, 'INVALID_FIELD', 'ora.create');

		jsonResult = ora.create('Account', '{"Name" : "' + tooLongAccName + '"}');
		assertError(jsonResult, 'STRING_TOO_LONG', 'ora.create');

		return id;
	}
    
    private static String tooLongAccName = 'LOTS OF ' +
	                                       'CHARACTERS XXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' +
	                                       'XXXXXXXXXXXXXXXX';
	static private void assertRecord(Map<String, Object> record, String accName, String accNumber, String method) {
		Map<String, Object> attributes = (Map<String, Object>)record.get('attributes');
		System.assertNotEquals(null, attributes,
		                       'attributes property missing from ' + method + ' result');
		System.assertNotEquals(0, attributes.keySet().size(),
		                       'empty attributes object in ' + method + ' result');

		String type = (String)attributes.get('type');
		System.assertNotEquals(null, type,
		                       'type property missing from ' + method + ' result');
		System.assertEquals('Account', type,
		                    'Wrong type in ' + method + ' result');

		String url = (String)attributes.get('url');
		System.assertNotEquals(null, url,
		                       'url property missing from ' + method + ' result');

		Id id = (Id)record.get('Id');
		System.assertNotEquals(null, id,
		                       'Id property missing from ' + method + ' result');
		Account account = [SELECT Id, Name FROM Account WHERE Id = :id LIMIT 1];
		System.assertNotEquals(null, account,
		                       'Couldn\'t find account record identified by ' + method + ' result');
		System.assertEquals(accName, account.Name,
		                    'Account name doesn\'t match in ' + method + ' result');

		String name = (String)record.get('Name');
		System.assertNotEquals(null, name,
		                       'Name property missing from ' + method + ' result');
		System.assertEquals(accName, name,
		                    'Wrong account name in ' + method + ' result');

		String accountNumber = (String)record.get('AccountNumber');
		System.assertNotEquals(null, name,
		                       'AccountNumber property missing from ' + method + ' result');
		System.assertEquals(accNumber, accountNumber,
		                    'Wrong account number in ' + method + ' result');
	}
}