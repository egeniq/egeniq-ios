//
//  LoginViewController.m
//  
//
//  Created by Johan Kool on 21-03-2011.
//  Copyright 2011 Johan Kool. All rights reserved.
//

#import "LoginViewController.h"

#import "EFTextFieldTableViewCell.h"
#import "EFButtonsTableViewCell.h"

@interface LoginViewController () <EFTextFieldTableViewCellDelegate> 

- (IBAction)login:(id)sender;
- (IBAction)register:(id)sender;

@end

@implementation LoginViewController

@synthesize delegate;
@synthesize username;
@synthesize password;
@synthesize rememberMe;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Log In", @"");
     
    // This allows us to have the textField be first responder below 
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = nil;
    if (!self.username || [self.username isEqualToString:@""]) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else if (!self.password || [self.password isEqualToString:@""]) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];     
    }
    EFTextFieldTableViewCell *editCell = (EFTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [editCell.textField becomeFirstResponder];
    
    if (self.username && self.password && self.rememberMe) {
        [self login:nil];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Main
- (IBAction)login:(id)sender {
    [self.delegate loginViewController:self credentialsEnteredForUsername:self.username password:self.password rememberMe:self.rememberMe];
}

- (IBAction)register:(id)sender {
// [self.delegate loginViewController:self credentialsEnteredForUsername:self.username password:self.password rememberMe:self.rememberMe];
}

- (IBAction)toggleRememberMe:(id)sender {
    self.rememberMe = [sender isOn];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TextCellIdentifier = @"TextCell";
    static NSString *SwitchCellIdentifier = @"SwitchCell";
    static NSString *ButtonCellIdentifier = @"ButtonCell";
    
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0: {
            cell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
            
            if (cell == nil) {
                cell = [[EFTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TextCellIdentifier];
            }
            EFTextFieldTableViewCell *editCell = (EFTextFieldTableViewCell *)cell;
            editCell.delegate = self;
            
            switch (indexPath.row) {
                case 0:
                    editCell.label.text = NSLocalizedString(@"Email", @"");
                    editCell.textField.placeholder = NSLocalizedString(@"Required", @"");
                    editCell.textField.secureTextEntry = NO;
                    editCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
                    editCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
                    editCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    editCell.textField.returnKeyType = UIReturnKeyNext;
                    editCell.textField.text = self.username;
                    break;
                case 1:
                    editCell.label.text = NSLocalizedString(@"Password", @"");
                    editCell.textField.placeholder = NSLocalizedString(@"Required", @"");
                    editCell.textField.secureTextEntry = YES;
                    editCell.textField.keyboardType = UIKeyboardTypeDefault;
                    editCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
                    editCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    editCell.textField.returnKeyType = UIReturnKeyGo;
                    editCell.textField.text = self.password;
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"Remember Me", @"");
            UISwitch *rememberSwitch = [[UISwitch alloc] init];
            rememberSwitch.on = self.rememberMe;
            [rememberSwitch addTarget:self action:@selector(toggleRememberMe:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = rememberSwitch;
        }    
            break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
            
            if (cell == nil) {
                cell = [[EFButtonsTableViewCell alloc] initWithStyle:tableView.style reuseIdentifier:ButtonCellIdentifier];
            }
            
            EFButtonsTableViewCell *buttonCell = (EFButtonsTableViewCell *)cell;
            UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [registerButton setTitle:NSLocalizedString(@"Register", @"") forState:UIControlStateNormal];
            buttonCell.button1 = registerButton;
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [loginButton setTitle:NSLocalizedString(@"Log In", @"") forState:UIControlStateNormal];
            [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
            buttonCell.button2 = loginButton;
            
        }    
            break;
        default:
            break;
    }
    return cell;

}

#pragma mark - KVTextFieldTableViewCellDelegate 
- (void)textFieldDidBeginEditingInCell:(EFTextFieldTableViewCell *)textFieldCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldCell];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (BOOL)textFieldShouldReturnInCell:(EFTextFieldTableViewCell *)textFieldCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldCell];
    switch (indexPath.row) {
        case 0:
            [[(EFTextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField] becomeFirstResponder];
            break;
        case 1:
            [self login:nil];
            break;
        default:
            break;
    }
    return NO;
}

- (BOOL)textFieldInCell:(EFTextFieldTableViewCell *)textFieldCell shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldCell];
    switch (indexPath.row) {
        case 0:
            self.username = [(self.username ? self.username : @"") stringByReplacingCharactersInRange:range withString:string];
            break;
        case 1:
            self.password = [(self.password ? self.password : @"") stringByReplacingCharactersInRange:range withString:string];
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldClearInCell:(EFTextFieldTableViewCell *)textFieldCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldCell];
    switch (indexPath.row) {
        case 0:
            self.username = @"";
            break;
        case 1:
            self.password = @"";
            break;
        default:
            break;
    }
    return YES;  
}

@end
