#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RHOrganization;

@interface RHRepository : NSManagedObject

@property (nonatomic, retain) NSURL    *url;
@property (nonatomic, retain) NSURL    *cloneURL;
@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSNumber *isPrivate;
@property (nonatomic, retain) NSNumber *forksCount;
@property (nonatomic, retain) NSNumber *watchersCount;
@property (nonatomic, retain) NSDate   *pushedAt;
@property (nonatomic, retain) NSDate   *createdAt;
@property (nonatomic, retain) NSDate   *updatedAt;
@property (nonatomic, retain) NSString *masterBranchName;
@property (nonatomic, retain) NSNumber *openIssuesCount;
@property (nonatomic, retain) NSString *descriptor;
@property (nonatomic, retain) RHOrganization *organization;

+ (RHRepository *)repository;
+ (RHRepository *)repositoryWithDictionary:(NSDictionary *)dictionary;

@end
