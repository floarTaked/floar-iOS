MVTextInputScroller
===================

Class to keep any selected input fields visible on screen when the keyboard is shown.

Scope
-------------------------------------------------------

When a UITextField or UITextView input is active, the default iOS keyboard appears, reducing the visible screen area above it.
If the input was originally positioned below the keyboard in the view layout, it will be hidden when the keyboard appears, making it hard to see what text is entered.<br/>
A common solution to this problem is to embed all content in the input form inside a UIScrollView that can scroll vertically as necessary so that the active input field is visible.

This project provides a MVTextInputScroller class that implements a robust solution to this problem.

Features
-------------------------------------------------------
- Automatically aligns the currently selected input field to the center of the visible screen area not covered by the keyboard.
- Support for interface rotation. If an input field is active when the interface orientation changes, it is automatically adjusted.
- Support for non-fullscreen presented view controllers such as UIModalPresentationPageSheet and UIModalPresentationFormSheet.
- Supports keyboards with input accessory views.
- Simple to use API.
- Requires Auto-Layout

Usage
-------------------------------------------------------
MVTextInputsScroller aims to provide the simplest possible API, only requiring the input UIScrollView to be passed upon initialization. All input fields part of the UIScrollView sub-hierarchy are automatically registered.

<pre>
@interface ViewController()<UITextFieldDelegate, UITextViewDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) MVTextInputsScroller *inputsScroller;
@end
@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Register inputs scroller
    self.inputsScroller = [[MVTextInputsScroller alloc] initWithScrollView:self.scrollView];
}
- (void)dealloc {
    [self.inputsScroller unregister];
}
</pre>

A sample application demonstrating the usage MVTextInputsScroller is included.

Notes
-------------------------------------------------------
MVTextInputsScroller is designed to work with UIScrollViews whose subviews are laid out using Auto-Layout. Specifically, all the subviews constraints need to be defined top to bottom so that the UIScrollView can infer its contentSize.<br/>
MVTextInputsScroller won't work if this is not the case as it uses the contentSize to determine the correct contentOffset.

Installation
-------------------------------------------------------
To include MVTextInputsScroller in your own project, simply drag the MVTextInputsScroller folder in XCode and you're ready to go.<br/>
The demo app included in this project uses [Masonry](https://github.com/cloudkite/Masonry) for auto-layout and [JVFloatLabeledTextField](https://github.com/jverdi/JVFloatLabeledTextField) for nice-looking input fields, however these are not required by the MVTextInputsScroller class.<br/>

Before running the demo app, please run:
<pre>
pod install
</pre>

In order to use MVModalTransitions in a new project, add the following line to the project *-Prefix.pch file:

<pre>
#define MAS_SHORTHAND
</pre>


Preview
-------------------------------------------------------

![MVTextInputScroller preview](https://github.com/bizz84/MVTextInputScroller/raw/master/Screenshots/iPhonePortrait.png "MVTextInputScroller preview")
<br/><br/>
![MVTextInputScroller preview](https://github.com/bizz84/MVTextInputScroller/raw/master/Screenshots/iPhoneLandscape.png "MVTextInputScroller preview")
<br/>
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Z2jliMEIIOU
" target="_blank"><img src="http://img.youtube.com/vi/Z2jliMEIIOU/0.jpg" 
alt="MVTextInputScroller Demo iOS" width="320" height="240" border="10" /></a><br/>
[See on Youtube](https://www.youtube.com/watch?v=Z2jliMEIIOU)

License
-------------------------------------------------------
Copyright (c) 2014 Andrea Bizzotto bizz84@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
