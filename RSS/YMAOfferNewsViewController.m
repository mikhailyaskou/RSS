//
//  YMAOfferNewsViewController.m
//  RSS
//
//  Created by Mikhail Yaskou on 20.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOfferNewsViewController.h"
#import "PKRevealController.h"

NSString * const termsLinks[] = {@"http://blog.onliner.by/siterules",@"https://news.tut.by/limitation.html",@"https://lenta.ru/info/copyright/"};

@interface YMAOfferNewsViewController () <PKRevealing, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *textBlockView;
@property (weak, nonatomic) IBOutlet UIButton *addAttachment;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *newsPortalSegmentControl;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;
@property (weak, nonatomic) IBOutlet UITextField *cellPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;

@end

@implementation YMAOfferNewsViewController

-(void)viewDidLoad {
    //apply design settings
    //border text view block
    self.textBlockView.layer.borderWidth = 1.0f;
    self.addAttachment.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //textView placeHolder
    self.newsTextView.delegate = self;
    [self setTextViewPlaceHolder:self.newsTextView];
    //segmentControl heght
    CGRect frame = self.newsPortalSegmentControl.frame;
    frame.size.height = 80;
    self.newsPortalSegmentControl.frame = frame;
    //custom font segment controll
    UIFont *font = [UIFont fontWithName:@"Times New Roman" size:17];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.newsPortalSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //text terms - set link
    [self setTermslinkWithIndex:0];
    
    //dissmiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.newsTextView resignFirstResponder];
    [self.cellPhoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

- (IBAction)segmentControlVelueChanged:(UISegmentedControl *)sender {
    [self setTermslinkWithIndex:sender.selectedSegmentIndex];
}

-(void)setTermslinkWithIndex:(NSInteger )index {
    NSMutableAttributedString *attributedString = self.termsTextView.attributedText.mutableCopy;
    NSRange foundRange = [attributedString.mutableString rangeOfString:@"условиями"];
    NSURL *url = [NSURL URLWithString:termsLinks[index]];
    [attributedString addAttribute:NSLinkAttributeName value:url range:foundRange];
    self.termsTextView.attributedText = attributedString;
}

- (IBAction)menyTapped:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self setTextViewPlaceHolder:textView];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self setTextViewPlaceHolder:textView];
    [textView resignFirstResponder];
}

- (void)setTextViewPlaceHolder:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Максимум 5000 символов.";
        textView.textColor = [UIColor lightGrayColor];
    } else if ([textView.text isEqualToString:@"Максимум 5000 символов."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (IBAction)textFiledDidBeginEditing:(id)sender {
    [self moveViewToOriginY:-125];
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    [self moveViewToOriginY:0];
}

- (void)moveViewToOriginY:(CGFloat)originY {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    CGRect frame = self.view.frame;
    frame.origin.y = originY;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

@end
