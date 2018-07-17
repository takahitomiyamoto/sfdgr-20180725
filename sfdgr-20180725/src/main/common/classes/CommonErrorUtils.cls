/***********************************
 * Name: CommonErrorUtils.cls
 * Description: Utilities for Error
 ***********************************/
public without sharing class CommonErrorUtils {

  // Constants
  private static final String SYMBOL_NEWLINE = CommonConstants.SYMBOL_NEWLINE;

  // Class Fields
  private static String methodName;

  /************************************************************
   * Name: createErrorMessage
   * Description: create Error Message from Database.Error
   *
   * @param  Database.Error error
   * @return String
   ************************************************************/
  public static String createErrorMessage(Database.Error error) {
    methodName = 'createErrorMessage';

    String errorMessage = '' +
      'Fields: ' +
      error.getFields() +
      SYMBOL_NEWLINE +
      'StatusCode: ' +
      error.getStatusCode() +
      SYMBOL_NEWLINE +
      'Message: ' +
      error.getMessage() +
      SYMBOL_NEWLINE;

    return errorMessage;
  }

  /*******************************************************
   * Name: createErrorMessage
   * Description: create Error Message from Exception
   *
   * @param  Exception e
   * @return String
   *******************************************************/
  public static String createErrorMessage(Exception e) {
    methodName = 'createErrorMessage';

    String errorMessage = '' +
      SYMBOL_NEWLINE +
      'Type: ' +
      e.getTypeName() +
      SYMBOL_NEWLINE +
      'Message: ' +
      e.getMessage();

    return errorMessage;
  }

}