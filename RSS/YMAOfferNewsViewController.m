//
//  YMAOfferNewsViewController.m
//  RSS
//
//  Created by Mikhail Yaskou on 20.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <PKRevealController/PKRevealController.h>
#import "YMAOfferNewsViewController.h"

NSString * const termsLinks[] = {@"http://blog.onliner.by/siterules", @"https://news.tut.by/limitation.html", @"https://lenta.ru/info/copyright/"};
static NSString * const YMAOfferNewsTextViewPlaceholderText = @"Максимум 5000 символов.";
static const float YMAOfferNewsTextViewBorderWidth = 1.0f;
static NSString * const YMAOfferNewsSegmentControlFont = @"Times New Roman";
static const int YMAOfferNewsSegmentControlFontSize = 17;
static const int YMAOfferNewsInitialIndexTermsLink = 0;
static NSString * const YMAOfferNewsWordFormTermsLink = @"условиями";
static const int YMAOfferNewsScreenShiftForKeyboard = -125;
static const int YMAOfferNewsInitialScreenPosition = 0;
static const float YMAOfferNewsScreenShiftAnimationDuration = 0.35f;

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

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    //apply design settings
    //border text view block
    self.textBlockView.layer.borderWidth = YMAOfferNewsTextViewBorderWidth;
    self.addAttachment.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addImageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //textView placeHolder
    self.newsTextView.delegate = self;
    [self setTextViewPlaceHolder:self.newsTextView];
    //custom font segment control
    UIFont *font = [UIFont fontWithName:YMAOfferNewsSegmentControlFont size:YMAOfferNewsSegmentControlFontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    [self.newsPortalSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //text terms - set link
    [self setTermsLinkWithIndex:YMAOfferNewsInitialIndexTermsLink];
    //dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Actions

- (IBAction)menuTapped:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (IBAction)segmentControlValueChanged:(UISegmentedControl *)sender {
    [self setTermsLinkWithIndex:sender.selectedSegmentIndex];
}

#pragma mark - Methods

- (void)setTermsLinkWithIndex:(NSInteger)index {
    NSMutableAttributedString *attributedString = self.termsTextView.attributedText.mutableCopy;
    NSRange foundRange = [attributedString.mutableString rangeOfString:YMAOfferNewsWordFormTermsLink];
    NSURL *url = [NSURL URLWithString:termsLinks[index]];
    [attributedString addAttribute:NSLinkAttributeName value:url range:foundRange];
    self.termsTextView.attributedText = attributedString;
}

- (IBAction)textFiledDidBeginEditing:(id)sender {
    [self shiftScreenToOriginY:YMAOfferNewsScreenShiftForKeyboard];
}

- (IBAction)textFieldDidEndEditing:(id)sender {
    [self shiftScreenToOriginY:YMAOfferNewsInitialScreenPosition];
}

- (void)shiftScreenToOriginY:(CGFloat)originY {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:YMAOfferNewsScreenShiftAnimationDuration];
    CGRect frame = self.view.frame;
    frame.origin.y = originY;
    [self.view setFrame:frame];
    [UIView commitAnimations];
}


- (void)dismissKeyboard {
    [self.newsTextView resignFirstResponder];
    [self.cellPhoneTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

-(BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Placeholders Methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self setTextViewPlaceHolder:textView];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self setTextViewPlaceHolder:textView];
    [textView resignFirstResponder];
}

- (void)setTextViewPlaceHolder:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = YMAOfferNewsTextViewPlaceholderText;
        textView.textColor = [UIColor lightGrayColor];
    }
    else if ([textView.text isEqualToString:YMAOfferNewsTextViewPlaceholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

@end
