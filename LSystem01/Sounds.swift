//
//  Sounds.swift
//  LSystem01
//
//  Created by Jeff Holtzkener on 5/22/16.
//  Copyright © 2016 Jeff Holtzkener. All rights reserved.
//


import AVFoundation

class Sounds : NSObject{
    static let sharedInstance = Sounds()
    var setSound: AVAudioPlayer?
    var audioURL: NSURL?
    
    private override init() {
        super.init()
        setSound = initAudio("button-8_short", level: 0.1)

    }
    
    func initAudio(filename: String, level: Float = 0.5) -> AVAudioPlayer? {
        var audioplayer: AVAudioPlayer?
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "wav") {
            audioURL = NSURL(fileURLWithPath: path)
            do {
                audioplayer =  try AVAudioPlayer(contentsOfURL: audioURL!)
                audioplayer?.prepareToPlay()
                audioplayer?.volume = level
                print("CREATED SOUND")
            } catch let err as NSError {
                print(err.debugDescription)
                print("failed with \(filename)")
            }
        }
        return audioplayer
    }
    
    func playSetSound() {
        // async b/c sounds might overlap
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            self.setSound?.play()
            print("played sounds")
        })
    }
    
    
    }