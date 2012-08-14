#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHUser.h"
#import "RHOrganization.h"

@interface RHAccount : NSManagedObject

@property (nonatomic, retain) NSString       *accessToken;
@property (nonatomic, retain) NSString       *tokenType;
@property (nonatomic, retain) RHOrganization *organization;
@property (nonatomic, retain) RHUser         *user;

+ (RHAccount *)account;
+ (RHAccount *)accountWithDictionary:(NSDictionary *)dictionary;
+ (RHAccount *)currentAccount;
+ (void)setCurrentAccount:(RHAccount *)account;

@end
