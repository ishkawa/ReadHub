#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RHAccount : NSManagedObject

@property (nonatomic, retain) NSString *tokenType;
@property (nonatomic, retain) NSString *accessToken;

+ (RHAccount *)accountWithDictionary:(NSDictionary *)dictionary;
+ (RHAccount *)currentAccount;

@end
