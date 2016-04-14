//
//  BGMPlayer.swift
//  EggieRun
//
//  Created by CNA_Bld on 4/14/16.
//  Copyright © 2016 Eggieee. All rights reserved.
//

import AVFoundation

class BGMPlayer {
    static let singleton = BGMPlayer()
    
    enum Status {
        case Menu
    }
    
    private static let MUSIC_FILES: [Status: String] = [.Menu: "road-runner"]
    
    private var player: AVAudioPlayer?
    
    func moveToStatus(status: Status?) {
        player?.stop()
        if status != nil {
            let url = NSBundle.mainBundle().URLForResource(BGMPlayer.MUSIC_FILES[status!], withExtension: "mp3")
            do {
                player = try AVAudioPlayer(contentsOfURL: url!)
                player?.numberOfLoops = -1
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("BGMPlayer Failed on " + url.debugDescription)
            }
        }
    }
}
