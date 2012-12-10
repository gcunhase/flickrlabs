//
//  XMLReader.h
//  https://github.com/Insert-Witty-Name/XML-to-NSDictionary

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject <NSXMLParserDelegate> //NSURLConnectionDelegate
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *__autoreleasing *errorPointer;
}

+ (NSDictionary *)dictionaryForPath:(NSString *)path
							  error:(NSError *__autoreleasing *)errorPointer;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data
								 error:(NSError *__autoreleasing *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string
								   error:(NSError *__autoreleasing *)errorPointer;
+ (NSDictionary *)dictionaryForRequest:(NSString *)requestName
							requestURL:(NSString *)requestURL
					  parametersString:(NSString *)paramsString
								 error:(NSError *__autoreleasing *)errorPointer;

@end

@interface NSDictionary (XMLReaderNavigation)

- (id)retrieveForPath:(NSString *)navPath;

@end