//
//  RHAppDelegate.h
//  ReadHub
//
//  Created by Yosuke Ishikawa on 2012/08/12.
//  Copyright (c) 2012年 Yosuke Ishikawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
