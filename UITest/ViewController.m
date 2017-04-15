//
//  ViewController.m
//  UITest
//
//  Created by punit on 4/10/17.
//  Copyright © 2017 punit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self blurrImageView];
    [self addPickerToTextfield];
    [self defaultConfiguration];
    [self addDottedLine];
    arrServes = [[NSMutableArray alloc]init];
    arrRecipeType = [[NSMutableArray alloc] init];
    arrPickerData = [[NSMutableArray alloc] init];
    [self checkWithServer];
    
    for (int i=1; i<=15; i++) {
        [arrServes addObject:[NSString stringWithFormat:@"%d",i]];
    }
    arrRecipeType = [NSMutableArray arrayWithObjects:@"Main Course",@"Salad",@"Soup",@"Desert",@"Breakfast",@"Appetizer",@"Drinks", nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)defaultConfiguration{
    _btnBegineer.selected = YES;
    [_btnBegineer setBackgroundColor:[UIColor colorWithRed:133.0/255.0 green:187.0/255.0 blue:56.0/255.0 alpha:1.0]];
    _btnChef.layer.borderWidth = 1;
    _btnMaster.layer.borderWidth = 1;
}


-(void)blurrImageView{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = _imageRecipe.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_imageRecipe addSubview:blurEffectView];
}

-(void)addPickerToTextfield{
    datePicker = [[UIDatePicker alloc]init];
    [datePicker addTarget:self action:@selector(dateForFirst:) forControlEvents:UIControlEventValueChanged];
    datePicker.datePickerMode=UIDatePickerModeCountDownTimer;
    [_txtCookingTime setInputView:datePicker];
    
    
    addPickerView = [[UIPickerView alloc]init];
    addPickerView.dataSource = self;
    addPickerView.delegate = self;
    addPickerView.showsSelectionIndicator = YES;
    
    _txtRecipeNote.delegate = self;
    
    _txtRecipeType.delegate = self;
    _txtServes.delegate = self;
    _txtCookingTime.delegate = self;
    _txtRecipeType.inputView = addPickerView;
    _txtServes.inputView = addPickerView;
    
}

-(void)addDottedLine{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1].CGColor;
    border.fillColor = nil;
    border.lineDashPattern = @[@4, @2];
    [_txtServes.layer addSublayer:border];
    border.path = [UIBezierPath bezierPathWithRoundedRect:_txtServes.bounds cornerRadius:_txtServes.frame.size.height / 4].CGPath;
    border.frame = _txtServes.bounds;
    
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = [UIColor colorWithRed:210/255.0f green:210/255.0f blue:210/255.0f alpha:1].CGColor;
    border1.fillColor = nil;
    border1.lineDashPattern = @[@4, @2];
    [_txtCookingTime.layer addSublayer:border1];
    border1.path = [UIBezierPath bezierPathWithRoundedRect:_txtCookingTime.bounds cornerRadius:_txtCookingTime.frame.size.height / 4].CGPath;
    border1.frame = _txtCookingTime.bounds;
    
    
}

-(void)dateForFirst:(id)sender {
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // Grab the date components from the datepicker
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:datePicker.date];
    
    // Grab the hours and minutes
    NSInteger hours = [dateComponents hour];
    NSInteger minutes = [dateComponents minute];
    if (hours==0) {
        _txtCookingTime.text = [NSString stringWithFormat:@"%ldmin",(long)minutes];
    }else if (minutes==0){
        _txtCookingTime.text = [NSString stringWithFormat:@"%ldhrs",(long)hours];
    }else {
        _txtCookingTime.text = [NSString stringWithFormat:@"%ldhrs%ldmin",(long)hours,(long)minutes];
    }
}

#pragma mark - Button Click Event

-(IBAction)selectImageClick:(id)sender{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Capture New" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            UIImagePickerController*picker = [[UIImagePickerController alloc] init];
            picker.delegate= self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Camera not available" preferredStyle:UIAlertControllerStyleAlert];
            [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Select from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.editing = true;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(IBAction)clickBegineer:(id)sender{
    _btnBegineer.selected = YES;
    [_btnBegineer setBackgroundColor:[UIColor colorWithRed:133.0/255.0 green:187.0/255.0 blue:56.0/255.0 alpha:1.0]];
    [_btnChef setBackgroundColor:[UIColor clearColor]];
    [_btnMaster setBackgroundColor:[UIColor clearColor]];
    _btnChef.selected = NO;
    _btnMaster.selected = NO;
    _btnChef.layer.borderWidth = 1;
    _btnMaster.layer.borderWidth = 1;
    _btnBegineer.layer.borderWidth = 0;
}
-(IBAction)clickChef:(id)sender{
    _btnBegineer.selected = NO;
    [_btnChef setBackgroundColor:[UIColor colorWithRed:133.0/255.0 green:187.0/255.0 blue:56.0/255.0 alpha:1.0]];
    [_btnBegineer setBackgroundColor:[UIColor clearColor]];
    [_btnMaster setBackgroundColor:[UIColor clearColor]];
    _btnChef.selected = YES;
    _btnMaster.selected = NO;
    _btnChef.layer.borderWidth = 0;
    _btnMaster.layer.borderWidth = 1;
    _btnBegineer.layer.borderWidth = 1;
}
-(IBAction)clickMaster:(id)sender{
    _btnBegineer.selected = NO;
    [_btnMaster setBackgroundColor:[UIColor colorWithRed:133.0/255.0 green:187.0/255.0 blue:56.0/255.0 alpha:1.0]];
    [_btnBegineer setBackgroundColor:[UIColor clearColor]];
    [_btnChef setBackgroundColor:[UIColor clearColor]];
    _btnChef.selected = NO;
    _btnMaster.selected = YES;
    _btnChef.layer.borderWidth = 1;
    _btnMaster.layer.borderWidth = 0;
    _btnBegineer.layer.borderWidth = 1;
}

#pragma mark - UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _txtRecipeType) {
        strSelectedType = @"Recipe_type";
        arrPickerData = [NSMutableArray new];
        arrPickerData = arrRecipeType;
        [addPickerView reloadAllComponents];
    }
    if (textField == _txtServes) {
        strSelectedType = @"Serves";
        arrPickerData = [NSMutableArray new];
        arrPickerData = arrServes;
        [addPickerView reloadAllComponents];
    }
    
}


#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    if ([strSelectedType isEqualToString:@"Recipe_type"]) {
        [_txtRecipeType setText:[arrPickerData objectAtIndex:row]];
        
    } else if ([strSelectedType isEqualToString:@"Serves"]) {
        [_txtServes setText:[arrPickerData objectAtIndex:row]];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [arrPickerData objectAtIndex:row];
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [arrPickerData count];
}


#pragma mark - uiTextview delegate

-(void)textViewDidChange:(UITextView *)textView {
    CGRect frame = _txtRecipeNote.frame;
    
    frame.size = _txtRecipeNote.contentSize;
    
    _txtRecipeNote.frame = frame;
}

#pragma mark - Photo Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    _imageRecipe.image = chosenImage;
    [blurEffectView removeFromSuperview];
    _btnImagePicker.hidden = true;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)checkWithServer {
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *postURL = [NSURL URLWithString: @"http://www.chefling.me/testapi/getRecipeType.php"];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"0", @"RTid",
                              nil];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:0 error:&error];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: postURL
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 60.0];
    
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json; charset=utf-8" forHTTPHeaderField: @"content-type"];
    [request setHTTPBody: jsonData];
    
    [[NSURLSession sharedSession] dataTaskWithRequest: request
                           completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
                               if (error || !data) {
                                   // Handle the error
                               } else {
                                   // Handle the success
                                   NSDictionary *user = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   
                                       NSString *strCode;
                                       if ([[user valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
                                           NSNumber *num=[user valueForKey:@"code"];
                                           strCode=[num stringValue];
                                       }
                                       else
                                       {
                                           strCode=[user valueForKey:@"code"];
                                       }
                                       
                                       if([strCode isEqualToString:@"1"])
                                       {
                                           
                                       }
                                       else
                                       {
                                        
                                       }
                                   
                               }
                           }
     ];
    
    
    
}




@end
