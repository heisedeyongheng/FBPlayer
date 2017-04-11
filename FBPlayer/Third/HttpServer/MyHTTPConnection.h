
#import "HTTPConnection.h"

#define USER_CUS_TOOL_UPLOAD_PATH

@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {
    MultipartFormDataParser*        parser;
	NSFileHandle*					storeFile;
	
	NSMutableArray*					uploadedFiles;
}

@end
