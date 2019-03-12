//
//  GameScene.swift
//  Rafi-Tone-Test-1
//
//  Created by Harry Liddell on 12/03/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var labelFrequency : SKLabelNode?
	private var labelAmplitude : SKLabelNode?
    private var spinnyNode : SKShapeNode?
	
	let mic = AKMicrophone()
	var tracker : AKFrequencyTracker?
	var silence : AKBooster?
	let mixer = AKMixer()
	let audioPlotView: AudioPlotView? = nil
	
	let audioSession = AVAudioSession.sharedInstance()
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
		self.labelFrequency = self.childNode(withName: "labelFrequency") as? SKLabelNode
		self.labelAmplitude = self.childNode(withName: "labelAmplitude") as? SKLabelNode
		
		setupAudioKit()
		setupAudioSession()
	}
	
	func setupAudioKit() {
		tracker = AKFrequencyTracker(mic)
		silence = AKBooster(tracker!, gain: 0)
		AKSettings.audioInputEnabled = true
		AudioKit.output = silence
	
		do {
			try AudioKit.start()
		} catch {
			print("AudioKit failed to start.")
		}
		
		mic.start()
		tracker?.start()
	}
	
	func setupAudioSession () {
		do {
			try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
		} catch {
			print("AudioSession failed to start.")
		}
	}
	
	func checkFrequencyAmplitude() {
		
		if let tracked = tracker {
			let frequency = tracked.frequency
			let amplitude = tracked.amplitude
			
			if (frequency >= 0 && frequency < 1200 && amplitude > 0 && amplitude < 1) {
				let frequencyRounded = String(format: "%.2f", frequency)
				let amplitudeRounded = String(format: "%.2f", amplitude)
				labelFrequency?.text = "Frequency: \(frequencyRounded)"
				labelAmplitude?.text = "Amplitude: \(amplitudeRounded)"
			}
		}
	}
	
	override func didMove(to view: SKView) {
		showAudioPlot()
	}
	
	func showAudioPlot() {
		let height = (scene?.view?.frame.height)! / 2
		let width = (scene?.view?.frame.width)!
		
		let audioPlotView = AudioPlotView(frame: CGRect(x: 0, y: 0, width: width, height: height))
		self.view?.addSubview(audioPlotView)
		
		audioPlotView.setupPlot(microphone: mic)
	}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		checkFrequencyAmplitude()
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
