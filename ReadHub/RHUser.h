#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHAccountContext.h"

@class RHAccount, RHRepository;

@interface RHUser : NSManagedObject <RHAccountContext>

@property (nonatomic, retain) NSURL     *avatarURL;
@property (nonatomic, retain) NSString  *bio;
@property (nonatomic, retain) NSURL     *blogURL;
@property (nonatomic, retain) NSNumber  *followersCount;
@property (nonatomic, retain) NSNumber  *followingCount;
@property (nonatomic, retain) NSNumber  *identifier;
@property (nonatomic, retain) NSString  *location;
@property (nonatomic, retain) NSString  *login;
@property (nonatomic, retain) NSString  *name;
@property (nonatomic, retain) NSNumber  *publicRepositoriesCount;
@property (nonatomic, retain) RHAccount *account;
@property (nonatomic, retain) NSSet     *repositories;

+ (RHUser *)user;
+ (RHUser *)userWithDictionary:(NSDictionary *)dictionary;

@end

@interface RHUser (CoreDataGeneratedAccessors)

- (void)addRepositoriesObject:(RHRepository *)value;
- (void)removeRepositoriesObject:(RHRepository *)value;
- (void)addRepositories:(NSSet *)values;
- (void)removeRepositories:(NSSet *)values;

@end
