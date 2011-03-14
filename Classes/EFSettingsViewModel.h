//
//  EFSettingsModel.h
//  Egeniq
//
//  Created by Peter Verhage on 10-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFSettingsView.h"
#import "EFSpecifierCell.h"

@interface EFSettingsViewModel : NSObject <EFSettingsViewDataSource> {
    NSMutableArray *sections_;
    NSMutableDictionary *sectionTitles_;
    NSMutableDictionary *sectionFields_;
    NSMutableDictionary *fields_;    
}

- (void)addSection:(NSString *)section withTitle:(NSString *)title;
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
