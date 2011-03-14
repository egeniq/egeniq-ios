//
//  EFSettingsView.h
//  Egeniq
//
//  Created by Peter Verhage on 10-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EFSpecifierCell.h"

@class EFSettingsView;

@protocol EFSettingsViewDataSource

@required
- (NSInteger)settingsView:(EFSettingsView *)settingsView numberOfFieldsInSection:(NSInteger)section;
- (EFSpecifierCell *)settingsView:(EFSettingsView *)settingsView fieldAtIndexPath:(NSIndexPath *)indexPath;
    
@optional
- (NSUInteger)numberOfSectionsInSettingsView:(EFSettingsView *)settingsView;
- (NSString *)settingsView:(EFSettingsView *)settingsView titleForSection:(NSInteger)section;

@end

@protocol EFSettingsViewDelegate

@optional
- (void)settingsView:(EFSettingsView *)settingsView didSelectField:(EFSpecifierCell *)field;

@end

@interface EFSettingsView : UIView {
    UITableView *tableView_;
}

@property(nonatomic, assign) NSObject<EFSettingsViewDelegate> *delegate;
@property(nonatomic, assign) NSObject<EFSettingsViewDataSource> *dataSource;

- (void)reloadFields;

@end