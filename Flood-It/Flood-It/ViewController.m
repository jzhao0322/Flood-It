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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (weak, nonatomic) IBOutlet UILabel *movesLeft;
@property (weak, nonatomic) IBOutlet UILabel *board;
@end

@implementation ViewController

- (FloodItGame *)game {
    if (!_game) {
        _game = [[FloodItGame alloc] initWithDifficulty:0];
    }
    return _game;
}
- (IBAction)touchButton:(UIButton *)sender {
    NSInteger typeIndex = [sender.titleLabel.text integerValue];
    [self.game selectTypeOfIndex:typeIndex];
    [self updateUI];
}

- (void)updateUI {
    self.movesLeft.text = [NSString stringWithFormat:@"Moves Left: %ld", (long)self.game._movesRemaining];
    //draw board
    self.board.numberOfLines = 0;
    self.board.text = [self.game._gameBoard toString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
