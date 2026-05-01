import UIKit
import Social
import MobileCoreServices
import Photos
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {

    private var appGroupId    = "group.com.zoz.nosavechat"   // ← change this
    private var appScheme     = "ShareMedia-com.zoz.nosavechat" // ← change this

    override func isContentValid() -> Bool { return true }
    override func didSelectPost() { self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil) }
    override func configurationItems() -> [Any]! { return [] }

    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedData()
    }

    private func handleSharedData() {
        let groupFileDir = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupId)!
            .appendingPathComponent("ShareMedia", isDirectory: true)

        if !FileManager.default.fileExists(atPath: groupFileDir.path) {
            try? FileManager.default.createDirectory(at: groupFileDir, withIntermediateDirectories: true)
        }

        // Clear old data
        try? FileManager.default.contentsOfDirectory(atPath: groupFileDir.path)
            .forEach { try? FileManager.default.removeItem(atPath: groupFileDir.appendingPathComponent($0).path) }

        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else { return }

        let dispatchGroup = DispatchGroup()
        var sharedItems: [[String: String]] = []

        for item in inputItems {
            for attachment in (item.attachments ?? []) {
                dispatchGroup.enter()

                if attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { data, _ in
                        defer { dispatchGroup.leave() }
                        var imageData: Data?
                        if let url = data as? URL { imageData = try? Data(contentsOf: url) }
                        else if let image = data as? UIImage { imageData = image.jpegData(compressionQuality: 0.8) }
                        else if let data = data as? Data { imageData = data }

                        if let imageData = imageData {
                            let fileName = UUID().uuidString + ".jpg"
                            let fileURL  = groupFileDir.appendingPathComponent(fileName)
                            if (try? imageData.write(to: fileURL)) != nil {
                                sharedItems.append(["value": fileURL.absoluteString, "type": "image"])
                            }
                        }
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            let userDefaults = UserDefaults(suiteName: self.appGroupId)!
            userDefaults.set(sharedItems, forKey: "sharedMedia")
            userDefaults.synchronize()

            self.openHostApp()
        }
    }

    private func openHostApp() {
        let url = URL(string: "\(appScheme)://dataUrl=\(appGroupId)#")!
        var responder = self as UIResponder?
        while responder != nil {
            if let app = responder as? UIApplication {
                app.open(url)
                break
            }
            responder = responder?.next
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}