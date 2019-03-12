//
//  AudioPlotView.swift
//  Rafi-Tone-Test-1
//
//  Created by Harry Liddell on 12/03/2019.
//  Copyright © 2019 harryliddell. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

@IBDesignable class AudioPlotView: UIView {

	var view: UIView!
	let nibName = "AudioPlotView"
	@IBOutlet weak var audioPlot: EZAudioPlot!
	
	override init(frame: CGRect) { // programmer creates our custom View
		super.init(frame: frame)
		setupHud()
	}
	
	required init?(coder aDecoder: NSCoder) {  // Storyboard or UI File
		super.init(coder: aDecoder)
		setupHud()
	}
	
	func setupHud() {
		view = loadHudFromNib()
		addSubview(view)
	}
	
	func loadHudFromNib() -> UIView {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: nibName, bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		
		return view
	}
	
	func setupPlot(microphone: AKMicrophone) {
		let plot = AKNodeOutputPlot(microphone, frame: audioPlot.bounds)
		plot.plotType = .rolling
		plot.shouldFill = true
		plot.shouldMirror = true
		plot.color = .blue
		audioPlot.addSubview(plot)
	}
}


