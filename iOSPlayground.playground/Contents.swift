//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var r = arc4random_uniform(256)

print(r)

arc4random()
let redColor = CGFloat(arc4random_uniform(256)) / 255
let greenColor = CGFloat(arc4random_uniform(256)) / 255
let blueColor = CGFloat(arc4random_uniform(256)) / 255

UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1)

CGFloat(arc4random_uniform(256))

UIColor(red: 65.0, green: 97, blue: 193, alpha: 0)
