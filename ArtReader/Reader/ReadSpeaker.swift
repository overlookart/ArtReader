//
//  ReadSpeaker.swift
//  ArtReader
//
//  Created by CaiGou on 2023/8/3.
//

import Foundation
import AVFoundation
class ReadSpeaker: NSObject {
    let speaker: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    func speak(str: String){
        
        let utterance = AVSpeechUtterance(string: str)
        
        // 设置声音
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")

        // 设置语速（0.0 - 1.0）
        utterance.rate = 0.5
        
        // 设置音调（0.5 - 2.0）
        utterance.pitchMultiplier = 1.2
        
        startSpeaking(utterance: utterance)
    }
    
    /// 开始朗读
    func startSpeaking(utterance: AVSpeechUtterance){
        speaker.speak(utterance)
    }
    
    /// 暂停朗读
    func pauseSpeaking(){
        speaker.pauseSpeaking(at: .word)
    }
    
    /// 继续朗读
    func continueSpeaking(){
        speaker.continueSpeaking()
    }
    
    /// 停止朗读
    func stopSpeaking(){
        speaker.stopSpeaking(at: .word)
    }
    
    func allSpeakVoices(){
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for item in voices {
            debugPrint(item.name, item.language)
        }
    }
}

extension ReadSpeaker: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        //开始朗读
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        //暂停朗读
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        //继续朗读
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        //取消朗读
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        //完成朗读
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
    }
}
