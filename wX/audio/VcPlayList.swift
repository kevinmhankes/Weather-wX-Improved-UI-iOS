// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class VcPlayList: UIwXViewController, AVSpeechSynthesizerDelegate {

    private var playlistItems = [String]()
    private var addNationalProductButton = ToolbarIcon()
    private var wfoTextButton = ToolbarIcon()
    private let textPreviewLength = 400
    private var synthesizer = AVSpeechSynthesizer()
    private var fab: ObjectFab!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        synthesizer.delegate = self
        addNationalProductButton = ToolbarIcon(self, .plus, #selector(addNationalProductClicked))
        wfoTextButton = ToolbarIcon(self, .wfo, #selector(wfoTextClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, wfoTextButton, addNationalProductButton]).items
        objScrollStackView = ScrollStackView(self)
        deSerializeSettings()
        fab = ObjectFab(self, #selector(playClicked), iconType: .play)
        display()
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        resetAudio()
        serializeSettings()
        super.doneClicked()
    }

    @objc override func getContent() {
        serializeSettings()
        playlistItems.forEach { item in
            _ = FutureVoid({ UtilityPlayList.download(item) }, display)
        }
    }

    func display() {
        stackView.removeViews()
        playlistItems.enumerated().forEach { index, item in
            let productText = Utility.readPref("PLAYLIST_" + item, "")
            let topLine = " " + Utility.readPref("PLAYLIST_" + item + "_TIME", "") + " (size: " + to.String(productText.count) + ")"
            _ = ObjectCardPlayListItem(
                self,
                item,
                topLine,
                productText.truncate(textPreviewLength),
                GestureData(index, self, #selector(buttonPressed))
            )
        }
    }

    @objc func buttonPressed(sender: GestureData) {
        let alert = ObjectPopUp(self, playlistItems[sender.data], addNationalProductButton)
        alert.addAction(UIAlertAction("Play") { _ in self.playProduct(selection: sender.data) })
        alert.addAction(UIAlertAction("View Text") { _ in self.viewProduct(selection: sender.data) })
        if sender.data != 0 {
            alert.addAction(UIAlertAction("Move Up") { _ in self.move(sender.data, .up) })
        }
        if sender.data != (playlistItems.count - 1) {
            alert.addAction(UIAlertAction("Move Down") { _ in self.move(sender.data, .down) })
        }
        alert.addAction(UIAlertAction("Delete") { _ in self.delete(selection: sender.data) })
        alert.finish()
    }

    func playProduct(selection: Int) {
        resetAudio()
        playlistItems.enumerated().forEach { index, item in
            if index >= selection {
                UtilityAudio.playClickedNewItem(Utility.readPref("PLAYLIST_" + item, ""), synthesizer, fab)
            }
        }
    }

    func viewProduct(selection: Int) {
        Route.wpcText(self, playlistItems[selection])
    }

    func move(_ from: Int, _ to: MotionType) {
        var delta = 1
        if to == .up {
            delta = -1
        }
        let tmp = playlistItems[from + delta]
        playlistItems[from + delta] = playlistItems[from]
        playlistItems[from] = tmp
        display()
    }

    func delete(selection: Int) {
        GlobalVariables.editor.removeObject("PLAYLIST_" + playlistItems[selection])
        GlobalVariables.editor.removeObject("PLAYLIST_" + playlistItems[selection] + "_TIME")
        playlistItems.remove(at: selection)
        display()
    }

    func serializeSettings() {
        playlistItems = playlistItems.filter { $0 != "" }
        let token = TextUtils.join(":", playlistItems)
        UIPreferences.playlistStr = token
        Utility.writePref("PLAYLIST", token)
    }

    func deSerializeSettings() {
        playlistItems = TextUtils.split(Utility.readPref("PLAYLIST", "") + ":", ":")
        playlistItems = playlistItems.filter { $0 != "" }
    }

    @objc func playClicked() {
        var textToSpeak = ""
        playlistItems.forEach {
            textToSpeak += Utility.readPref("PLAYLIST_" + $0, "")
        }
        UtilityAudio.playClicked(textToSpeak, synthesizer, fab)
    }

    @objc func addNationalProductClicked() {
        _ = ObjectPopUp(self, addNationalProductButton, UtilityWpcText.labels, addNationalProduct)
    }

    func addNationalProduct(_ index: Int) {
        let product = UtilityWpcText.labelsWithCodes[index].split(":")[0].uppercased()
        downloadAndAddProduct(product, addNationalProductButton)
    }

    @objc func wfoTextClicked() {
        _ = ObjectPopUp(self, wfoTextButton, GlobalArrays.wfos, addWfoProduct)
    }

    func addWfoProduct(_ office: String) {
        downloadAndAddProduct("AFD" + office.uppercased(), wfoTextButton)
    }

    func downloadAndAddProduct(_ product: String, _ button: ToolbarIcon) {
        _ = FutureText(product) { s in self.displayAndAddProduct(s, product, button) }
    }

    private func displayAndAddProduct(_ s: String, _ product: String, _ button: ToolbarIcon) {
        let productAdded = UtilityPlayList.add(product, s, self, button, showStatus: false)
        if productAdded {
            playlistItems.append(product)
            display()
            serializeSettings()
        }
    }

    func resetAudio() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        synthesizer = AVSpeechSynthesizer()
        fab.setImage(.play)
    }
}
