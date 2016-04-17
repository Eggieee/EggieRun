//
//  MultilineLabelNode.swift
//  EggieRun
//
//  Created by Tang Jiahui on 16/4/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import SpriteKit

class MultilineLabelNode: SKNode {

    var labelWidth:Int {didSet {update()}}
    var labelHeight:Int = 0
    var text:String {didSet {update()}}
    var fontName:String {didSet {update()}}
    var fontSize:CGFloat {didSet {update()}}
    var pos:CGPoint {didSet {update()}}
    var fontColor:UIColor {didSet {update()}}
    var leading:Int {didSet {update()}}
    var alignment:SKLabelHorizontalAlignmentMode {didSet {update()}}

    //display objects
    var rect:SKShapeNode?
    var labels:[SKLabelNode] = []
    
    init(text:String, labelWidth:Int, pos:CGPoint, fontName:String, fontSize:CGFloat, fontColor: UIColor, leading: Int, alignment:SKLabelHorizontalAlignmentMode) {
        
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = leading
        self.alignment = alignment
        
        super.init()
        
        self.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func update() {

        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        
        let separators = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let words = text.componentsSeparatedByCharactersInSet(separators)
        
        var finalLine = false
        var wordCount = -1
        var lineCount = 0
        
        while (!finalLine) {
            lineCount += 1
            var lineLength = CGFloat(0)
            var lineString = ""
            var lineStringBeforeAddingWord = ""
            
            let label = SKLabelNode(fontNamed: fontName)
            
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = fontColor
            
            while lineLength < CGFloat(labelWidth) {
                wordCount += 1
                if wordCount > words.count-1 {
                    finalLine = true
                    break
                }
                else {
                    lineStringBeforeAddingWord = lineString
                    lineString = "\(lineString) \(words[wordCount])"
                    label.text = lineString
                    lineLength = label.frame.width
                }
            }
            
            if lineLength > 0 {
                wordCount -= 1
                if (!finalLine) {
                    lineString = lineStringBeforeAddingWord
                }
                label.text = lineString
                var linePos = pos
                if (alignment == .Left) {
                    linePos.x -= CGFloat(labelWidth / 2)
                } else if (alignment == .Right) {
                    linePos.x += CGFloat(labelWidth / 2)
                }
                linePos.y += CGFloat(-leading * lineCount)
                label.position = CGPointMake( linePos.x , linePos.y )
                self.addChild(label)
                labels.append(label)
            }
        }
        labelHeight = lineCount * leading
    }
 
}