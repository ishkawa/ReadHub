#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHAccountContext.h"

@class RHAccount, RHRepository;

@interface RHOrganization : NSManagedObject <RHAccountContext>

@property (nonatomic, retain) id avatarURL;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) id url;
@property (nonatomic, retain) RHAccount *account;
@property (nonatomic, retain) NSSet *repositories;

+ (RHOrganization *)organization;
+ (RHOrganization *)organizationWithDictionary:(NSDictionary *)dictionary;
+ (RHOrganization *)organizationForID:(NSNumber *)identifier;
+ (NSArray *)allOrganizations;

@end


@interface RHOrganization (CoreDataGeneratedAccessors)

- (void)addRepositoriesObject:(RHRepository *)value;
- (void)removeRepositoriesObject:(RHRepository *)value;
- (void)addRepositories:(NSSet *)values;
- (void)removeRepositories:(NSSet *)values;

@end
