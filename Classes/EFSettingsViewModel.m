//
//  EFSettingsModel.m
//  Egeniq
//
//  Created by Peter Verhage on 10-03-11.
//  Copyright 2011 Egeniq. All rights reserved.
//

#import "EFSettingsViewModel.h"

@implementation EFSettingsViewModel

@synthesize delegate=delegate_;

- (id)init {
    self = [super init];
    if (self != nil) {
        sections_ = [[NSMutableArray alloc] init];
        visibleSections_ = [[NSMutableArray alloc] init];        
        sectionTitles_ = [[NSMutableDictionary alloc] init];
        sectionFields_ = [[NSMutableDictionary alloc] init];
        sectionFooterViews_ = [[NSMutableDictionary alloc] init];
        fields_ = [[NSMutableDictionary alloc] init];        
    }
    
    return self;
}

- (void)addSection:(NSString *)section withTitle:(NSString *)title {
    [self removeSection:section];
    [sections_ addObject:section];
    [sectionTitles_ setValue:title forKey:section];
    [sectionFields_ setObject:[NSMutableArray array] forKey:section];
    [self setHidden:NO forSection:section];
}

- (void)setTitle:(NSString *)title forSection:(NSString *)section {
    [sectionTitles_ setValue:title forKey:section];    
}

- (void)setHidden:(BOOL)hidden forSection:(NSString *)section {
    [visibleSections_ removeObject:section];
    if (!hidden) {
        [visibleSections_ addObject:section];
    }
    
    visibleSections_ = [[NSMutableArray arrayWithArray:[sections_ filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self IN (%@)", visibleSections_]]] retain];
}

- (void)setFooterView:(UITableView *)view forSection:(NSString *)section {
    [sectionFooterViews_ setValue:view forKey:section];
}

- (void)removeSection:(NSString *)section {
    if (![sections_ containsObject:section]) {
        return;
    }
    
    [sections_ removeObject:section];
    [visibleSections_ removeObject:section];
    [sectionTitles_ removeObjectForKey:section];
    [sectionFooterViews_ removeObjectForKey:section];
    
    NSMutableArray *fieldNames = [sectionFields_ objectForKey:section];
    for (NSString *fieldName in fieldNames) {
       [fields_ removeObjectForKey:fieldName];
    }
        
    [sectionFields_ removeObjectForKey:section];
}

- (NSArray *)allFieldNames {
	return [fields_ allKeys];
}

- (void)addField:(EFSpecifierCell *)field toSection:(NSString *)section {
    [self removeFieldWithName:field.name];
    [fields_ setObject:field forKey:field.name];
    NSMutableArray *fieldNames = [sectionFields_ objectForKey:section];
    [fieldNames addObject:field.name];
}

- (EFSpecifierCell *)fieldWithName:(NSString *)name {
    return [fields_ objectForKey:name];
}

- (void)removeFieldWithName:(NSString *)name {
    if ([fields_ objectForKey:name] == nil) {
        return;
    }
    
    [fields_ removeObjectForKey:name];
    for (NSString *section in sections_) {
        NSMutableArray *fieldNames = [sectionFields_ objectForKey:section];
        [fieldNames removeObject:name];
    }
}

- (void)removeField:(EFSpecifierCell *)field {
    [self removeFieldWithName:field.name];
}

- (void)removeAll {
    [sections_ removeAllObjects];
    [visibleSections_ removeAllObjects];
    [sectionTitles_ removeAllObjects];
    [sectionFields_ removeAllObjects];
    [fields_ removeAllObjects];
}
     
- (void)loadValues:(NSDictionary *)values {
    for (NSString *fieldName in [fields_ keyEnumerator]) {
        EFSpecifierCell *field = [self fieldWithName:fieldName];
        if ([field shouldLoadValue] && [[values allKeys] containsObject:fieldName]) {
            id value = [values valueForKey:fieldName];
            field.value = value != [NSNull null] ? value : nil;
        }
    }
}

- (NSDictionary *)allValues {
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:[fields_ count]];
    for (NSString *fieldName in [fields_ keyEnumerator]) {
        EFSpecifierCell *field = [self fieldWithName:fieldName];
        if ([field shouldLoadValue]) {
            id value = field.value == nil ? [NSNull null] : field.value;
            [values setValue:value forKey:fieldName];
        }
    }    
    
    return values;
}

- (NSUInteger)numberOfSectionsInSettingsView:(EFSettingsView *)settingsView {
    return [visibleSections_ count];
}

- (NSString *)settingsView:(EFSettingsView *)settingsView titleForSection:(NSInteger)section {
    return [sectionTitles_ objectForKey:[visibleSections_ objectAtIndex:section]];
}

- (NSInteger)settingsView:(EFSettingsView *)settingsView numberOfFieldsInSection:(NSInteger)section {
    NSArray *fieldNames = [sectionFields_ objectForKey:[visibleSections_ objectAtIndex:section]];
    return [fieldNames count];
}

- (EFSpecifierCell *)settingsView:(EFSettingsView *)settingsView fieldAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *fieldNames = [sectionFields_ objectForKey:[visibleSections_ objectAtIndex:indexPath.section]];
    NSString *fieldName = [fieldNames objectAtIndex:indexPath.row];
    return [self fieldWithName:fieldName];
}

- (void)settingsView:(EFSettingsView *)settingsView didSelectField:(EFSpecifierCell *)field {
    if ([self.delegate respondsToSelector:@selector(settingsViewModel:didSelectField:)]) {
        [self.delegate settingsViewModel:self didSelectField:field];
    }
}

- (UIView *)settingsView:(EFSettingsView *)settingsView viewForFooterInSection:(NSInteger)section {
    return [sectionFooterViews_ objectForKey:[visibleSections_ objectAtIndex:section]];
}

- (void)dealloc {
    [sections_  release];
    [visibleSections_ release];
    [sectionTitles_ release];
    [sectionFields_ release];
    [sectionFooterViews_ release];
    [fields_ release];
    [super dealloc];
}

@end