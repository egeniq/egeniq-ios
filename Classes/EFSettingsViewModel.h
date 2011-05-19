//
//  EFSettingsModel.h
//  Egeniq
//
//  Created by Peter Verhage on 10-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFSettingsView.h"
#import "EFSpecifierCell.h"

@class EFSettingsViewModel;

@protocol EFSettingsViewModelDelegate

@optional
- (void)settingsViewModel:(EFSettingsViewModel *)settingsViewModel didSelectField:(EFSpecifierCell *)field;

@end

@interface EFSettingsViewModel : NSObject <EFSettingsViewDataSource, EFSettingsViewDelegate> {
    NSMutableArray *sections_;
    NSMutableDictionary *sectionTitles_;
    NSMutableDictionary *sectionFooterViews_;    
    NSMutableDictionary *sectionFields_;
    NSMutableDictionary *fields_;    
}

@property(nonatomic, assign) IBOutlet NSObject<EFSettingsViewModelDelegate> *delegate;

- (void)addSection:(NSString *)section withTitle:(NSString *)title;
- (void)setTitle:(NSString *)title forSection:(NSString *)section;
- (void)setFooterView:(UIView *)view forSection:(NSString *)section;
- (void)removeSection:(NSString *)section;

- (NSArray *)allFieldNames;
- (void)addField:(EFSpecifierCell *)field toSection:(NSString *)section;
- (EFSpecifierCell *)fieldWithName:(NSString *)name;
- (void)removeFieldWithName:(NSString *)name;
- (void)removeField:(EFSpecifierCell *)field;

- (void)removeAll;

- (void)loadValues:(NSDictionary *)values;
- (NSDictionary *)allValues;

@end
