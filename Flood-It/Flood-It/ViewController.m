//
//  ViewController.m
//  Flood-It
//
//  Created by Jerry Zhao on 4/23/15.
//  Copyright (c) 2015 BAP. All rights reserved.
//

#import "ViewController.h"
#import "FloodItGame.h"

@interface ViewController ()

@property (strong, nonatomic) FloodItGame *game;
@property NSArray *buttons;
@property UILabel *movesLeft;
@property UILabel *gameText;

@property NSArray *boxes;
@property NSArray *colors;
@property NSArray *colorButtons;
@property NSArray *levels;

@property UIButton *replayButton;
@property NSInteger difficulty;
@property UIButton *changeDifficulty;
@property (nonatomic, strong) UITextField *pickerViewTextField;

@end

@implementation ViewController
@synthesize boxes;
@synthesize gameText;
@synthesize pickerViewTextField = _pickerViewTextField;

- (FloodItGame *)game {
    if (!_game) {
        _game = [[FloodItGame alloc] initWithDifficulty:self.difficulty];
    }
    return _game;
}
- (IBAction)touchButton:(UIButton *)sender {
    if (self.game._movesRemaining != 0) {
        NSInteger typeIndex = [sender.titleLabel.text integerValue];
        [self.game selectTypeOfIndex:typeIndex];
        [self updateUI];
    }
}

- (IBAction)touchReplay:(UIButton *)sender {
    [self replayGame];
}

- (IBAction)touchDifficulty:(UIButton *)sender
{
    [self.pickerViewTextField becomeFirstResponder];
}

- (void)cancelTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
    
    // perform some action
    [self replayGame];
}

- (void)replayGame {
    [self.replayButton setHidden:YES];
    
    self.gameText.font = [UIFont systemFontOfSize:15];
    self.gameText.text = @"Change the color of the top left pixels to flood the board!";
    [self.gameText setHidden:NO];
    
    for (UIButton *button in self.buttons) {
        [button setHidden:NO];
    }
    
    for (UIView *colorButton in self.colorButtons) {
        [colorButton setHidden: NO];
    }
    
    for (UIView *box in self.boxes) {
        [box removeFromSuperview];
    }
    
    self.game = nil;
    [self drawBoard];
    self.movesLeft.text = [NSString stringWithFormat:@"Moves Left: %ld", (long)self.game._movesRemaining];
    [self.changeDifficulty setTitle:self.levels[self.difficulty] forState:UIControlStateNormal];
}

- (void)updateUI {
    [self.gameText setHidden:YES];
    self.movesLeft.text = [NSString stringWithFormat:@"Moves Left: %ld", (long)self.game._movesRemaining];

    NSString *pixelTypes = [self.game._gameBoard toString];
    
    for (int i = 0; i < [self.boxes count]; i += 1) {
        NSString *pixelChar = [pixelTypes substringWithRange:NSMakeRange(i, 1)];
        NSInteger pixelType = [pixelChar integerValue];
        NSString *pixelColor = self.colors[pixelType];
        SEL selector = NSSelectorFromString(pixelColor);
        
        UIView *box = self.boxes[i];
        box.backgroundColor = [UIColor performSelector:selector];

    }
    
    if (self.game._gameOver) {
        [self.gameText setHidden:NO];
        self.gameText.font = [UIFont systemFontOfSize:20];
        
        for (UIButton *button in self.buttons) {
            [button setHidden:YES];
        }
        
        for (UIView *colorButton in self.colorButtons) {
            [colorButton setHidden: YES];
        }
        
        self.replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replayButton setFrame:CGRectMake(self.view.bounds.origin.x + 100, 470, self.view.bounds.size.width - 200, 48)];
        [self.replayButton setTitle:@"Play Again" forState:UIControlStateNormal];
        [self.replayButton addTarget:self action:@selector(touchReplay:) forControlEvents:UIControlEventTouchUpInside];
        [self.replayButton setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:self.replayButton];
        
        if (self.game._gameWon) {
            self.gameText.text = @"Congratulations, you won!";
        } else {
            self.gameText.text = @"Flood Failed.";
            

        }
        
    }
    
    
}

- (void)drawBoard {
    //draw board
    NSInteger sideLength = self.game._gameBoard._sideLength;
    NSMutableArray *gameBoard = self.game._gameBoard._board;
    NSMutableArray *colorBoxes = [NSMutableArray array];
    
    self.colors = [[NSArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"colors" ofType: @"plist"]];
    
    NSInteger startX = self.view.center.x - (sideLength * 10);
    NSInteger startY = 240 - (sideLength * 10);
    
    for (int i = 0; i < sideLength; i += 1) {
        NSMutableArray *row = gameBoard[i];
        for (int j = 0; j < sideLength; j += 1) {
            Pixel *pixel = row[j];
            NSString *pixelColor = self.colors[pixel._typeIndex];
            
            SEL selector = NSSelectorFromString(pixelColor);
            UIView *pixelBox = [[UIView alloc] initWithFrame:CGRectMake(startX + 20 * i, startY + 20 * j, 20, 20)];
            pixelBox.backgroundColor = [UIColor performSelector:selector];
            [self.view addSubview:pixelBox];
            [colorBoxes addObject:pixelBox];
            
        }
        
    }
    
    self.boxes = colorBoxes;
    
}

- (void)setupGame {
    self.difficulty = 0;
    // set up moves text
    self.movesLeft = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 40, 25, self.view.bounds.size.width - 80, 80)];
    self.movesLeft.text = [NSString stringWithFormat:@"Moves Left: %ld", (long)self.game._movesRemaining];
    self.movesLeft.textAlignment = NSTextAlignmentRight;
    self.movesLeft.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [self.view addSubview:self.movesLeft];
    
    // set up level text
    self.levels = [[NSArray alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"levels" ofType: @"plist"]];
    self.changeDifficulty = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeDifficulty setFrame:CGRectMake(self.view.bounds.origin.x + 35, 45, 80, 40)];
    NSString *level = self.levels[self.difficulty];
    [self.changeDifficulty setTitle:level forState:UIControlStateNormal];
    [self.changeDifficulty addTarget:self action:@selector(touchDifficulty:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.changeDifficulty setBackgroundColor:[[UIColor alloc] initWithRed:0.0 / 255 green:195.0 / 255 blue:255.0 / 255 alpha:1.0]];
    [self.view addSubview:self.changeDifficulty];
    
    // set up bottom text
    self.gameText = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x + 40, 390, self.view.bounds.size.width - 80, 80)];
    self.gameText.text = @"Change the color of the top left pixels to flood the board!";
    self.gameText.lineBreakMode = NSLineBreakByWordWrapping;
    self.gameText.numberOfLines = 2;
    self.gameText.textAlignment = NSTextAlignmentCenter;
    self.gameText.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.gameText];
    
    //draw board
    [self drawBoard];
    
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *colorButtons = [NSMutableArray array];
    
    // top row of buttons
    for (int i = 0; i < 3; i += 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(96 + 65 * i, 470, 48, 48)];
        [button setTitle:[NSString stringWithFormat: @"%ld", (long)i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        
        NSString *pixelColor = self.colors[i];
        SEL selector = NSSelectorFromString(pixelColor);
        UIView *pixelBox = [[UIView alloc] initWithFrame:CGRectMake(96 + 65 * i, 470, 48, 48)];
        pixelBox.backgroundColor = [UIColor performSelector:selector];
        pixelBox.userInteractionEnabled = NO;
        [self.view addSubview:pixelBox];
        [colorButtons addObject:pixelBox];
    }
    
    // bottom row of buttons
    for (int i = 3; i < 6; i += 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(96 + 65 * (i - 3), 535, 48, 48)];
        [button setTitle:[NSString stringWithFormat: @"%ld", (long)i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];

        NSString *pixelColor = self.colors[i];
        SEL selector = NSSelectorFromString(pixelColor);
        UIView *pixelBox = [[UIView alloc] initWithFrame:CGRectMake(96 + 65 * (i - 3), 535, 48, 48)];
        pixelBox.backgroundColor = [UIColor performSelector:selector];
        pixelBox.userInteractionEnabled = NO;
        [self.view addSubview:pixelBox];
        [colorButtons addObject:pixelBox];
        
    }
    
    self.buttons = buttons;
    self.colorButtons = colorButtons;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // set the frame to zero
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView setBackgroundColor:[[UIColor alloc] initWithRed:255.0 / 255 green:255.0 / 255 blue:255.0 / 255 alpha:0.005]];
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = pickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;
    
    [self setupGame];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *item = [self.levels objectAtIndex:row];
    
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.difficulty = row;
    
}


@end
