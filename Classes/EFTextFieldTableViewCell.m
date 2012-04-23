//
//  EFTextFieldTableViewCell.m
//  Koolistov
//
//  Created by Johan Kool on 28-02-11.
//  Copyright 2011 Koolistov. All rights reserved.
//

#import "EFTextFieldTableViewCell.h"

@interface EFTextFieldTableViewCell () 

@property (readwrite) UITableViewCellStyle style;
@property (nonatomic, retain, readwrite) UILabel *label;
@property (nonatomic, retain, readwrite) UITextField *textField;

@end

@implementation EFTextFieldTableViewCell

@synthesize delegate = _delegate;
@synthesize textField = _textField;
@synthesize label = _label;
@synthesize style = _style;
@synthesize textFieldOffset = _textFieldOffset_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        self.style = style;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textFieldOffset = 100.0f;
    
        self.label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.label];
 
        self.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textField.delegate = self;
        [self.contentView addSubview:self.textField];
   
        switch (self.style) {
            case UITableViewCellStyleValue2:
                self.label.font = [UIFont boldSystemFontOfSize:12.0f];
                self.label.textColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.00f]; // 0.22 0.33 0.53 1
                self.label.textAlignment = UITextAlignmentRight;
             
                self.textField.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
                self.textField.textColor = [UIColor darkTextColor];

                break;
            default:
                self.label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
                self.label.textColor = [UIColor darkTextColor];

                self.textField.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
                self.textField.textColor = [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.00f];
                
                break;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    switch (self.style) {
        case UITableViewCellStyleValue2: {
            self.label.frame = CGRectMake(self.contentView.bounds.origin.x + 10.0f, 
                                          self.contentView.bounds.origin.y + 4.0f, 
                                          self.textFieldOffset, 
                                          self.contentView.bounds.size.height - 8.0f);
            self.textField.frame = CGRectMake(self.contentView.bounds.origin.x + 10.0f + 8.0f + self.textFieldOffset, 
                                              self.contentView.bounds.origin.y, 
                                              self.contentView.bounds.size.width - 10.0f - self.contentView.bounds.origin.x - 10.0f - 8.0f - self.textFieldOffset, 
                                              self.contentView.bounds.size.height);
        }
            break;
        case UITableViewCellStyleDefault: {
            NSUInteger y = self.contentView.bounds.origin.y + 0.5f * (self.contentView.bounds.size.height - self.label.frame.size.height);
            self.label.frame = CGRectMake(self.contentView.bounds.origin.x + 10.0f, 
                                          y, 
                                          self.label.frame.size.width, 
                                          self.label.frame.size.height);
            NSUInteger offset = self.contentView.bounds.origin.x + 10.0f + self.label.frame.size.width + 8.0f;
            self.textField.frame = CGRectMake(offset, 
                                              self.contentView.bounds.origin.y, 
                                              self.contentView.bounds.size.width - 10.0f - offset, 
                                              self.contentView.bounds.size.height);
        }
            break;
        default: {
            self.label.frame = CGRectMake(self.contentView.bounds.origin.x + 10.0f, 
                                          self.contentView.bounds.origin.y + 4.0f, 
                                          self.textFieldOffset, 
                                          self.contentView.bounds.size.height - 8.0f);
            self.textField.frame = CGRectMake(self.contentView.bounds.origin.x + 10.0f + 8.0f + self.textFieldOffset, 
                                              self.contentView.bounds.origin.y, 
                                              self.contentView.bounds.size.width - 10.0f - self.contentView.bounds.origin.x - 10.0f - 8.0f - self.textFieldOffset, 
                                              self.contentView.bounds.size.height);
        }
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    self.label.text = @"";
    self.textField.text = @"";
    self.textField.delegate = self;
    [super prepareForReuse];
}

- (void)dealloc {
    self.label = nil;
    self.textField = nil;
    [super dealloc];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldBeginEditingInCell:)]) {
        return [self.delegate textFieldShouldBeginEditingInCell:self];
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldDidBeginEditingInCell:)]) {
        [self.delegate textFieldDidBeginEditingInCell:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldReturnInCell:)]) {
        return [self.delegate textFieldShouldReturnInCell:self];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldClearInCell:)]) {
        return [self.delegate textFieldShouldClearInCell:self];
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldShouldEndEditingInCell:)]) {
        return [self.delegate textFieldShouldEndEditingInCell:self];
    } else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(textFieldDidEndEditingInCell:)]) {
        [self.delegate textFieldDidEndEditingInCell:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.delegate respondsToSelector:@selector(textFieldInCell:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textFieldInCell:self shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}

@end

