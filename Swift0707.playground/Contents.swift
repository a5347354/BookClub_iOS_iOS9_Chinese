//: Playground - noun: a place where people can play

import UIKit

var str1 = "Hello"
var str2 = "Swift"

str1.uppercaseString
str2.lowercaseString + " is egg"

if str1 == str2{
    print("same str")
}else{
    print("Not the same message")
}

let messageLabel = UILabel(frame: CGRectMake(0,0,300,50))
messageLabel.text = str1
messageLabel.backgroundColor = UIColor.whiteColor()
messageLabel.textAlignment = .Center


