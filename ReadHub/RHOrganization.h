#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHAccountContext.h"

@class RHAccount;

@interface RHOrganization : NSManagedObject <RHAccountContext>

@property (nonatomic, retain) NSNumber  *identifier;
@property (nonatomic, retain) NSURL     *avatarURL;
@property (nonatomic, retain) NSURL     *url;
@property (nonatomic, retain) NSString  *login;
@property (nonatomic, retain) RHAccount *account;

+ (RHOrganization *)organization;
+ (RHOrganization *)organizationWithDictionary:(NSDictionary *)dictionary;
+ (RHOrganization *)organizationForID:(NSNumber *)identifier;
+ (NSArray *)allOrganizations;

@end
