//
//  ViewController.h
//  UITest
//
//  Created by punit on 4/10/17.
//  Copyright © 2017 punit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>{
    UIPickerView *addPickerView;
    UIVisualEffectView *blurEffectView;
    UIDatePicker *datePicker;
    NSMutableArray *arrPickerData,*arrServes,*arrRecipeType;
    NSString *strSelectedType;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageRecipe;
@property (weak, nonatomic) IBOutlet UIButton *btnBegineer;
@property (weak, nonatomic) IBOutlet UIButton *btnChef;
@property (weak, nonatomic) IBOutlet UIButton *btnMaster;
@property (weak, nonatomic) IBOutlet UIButton *btnImagePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtRecipeName;
@property (weak, nonatomic) IBOutlet UITextField *txtRecipeType;
@property (weak, nonatomic) IBOutlet UITextField *txtServes;
@property (weak, nonatomic) IBOutlet UITextField *txtCookingTime;
@property (weak, nonatomic) IBOutlet UITextView *txtRecipeNote;


@end

