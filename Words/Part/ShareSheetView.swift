//
//  ShareSheetView.swift
//  Words
//
//  Created by Ivan Lvov on 29.12.2022.
//

import SwiftUI

struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let headline: String
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let title = headline
        let text = """
                    🟨🟩⬜⬜⬜
                    🟨🟩⬜⬜⬜
                    🟨🟩⬜⬜⬜
                    🟨🟩⬜⬜⬜
                    🟨🟩⬜⬜⬜
                    🟨🟩⬜⬜⬜
                    #\(appName)
                    Отгадай слово дня
                    """
        // set up activity view controller
        let textToShare: [Any] = [
            MyActivityItemSource(title: title, text: text)
        ]
        
        let controller = UIActivityViewController(
            activityItems: textToShare,
            applicationActivities: nil)
        controller.excludedActivityTypes = nil
        controller.completionWithItemsHandler = callback

        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
    
}

//struct ShareSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareSheetView(activityItems: ["Hello"])
//    }
//}



import LinkPresentation

class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.iconProvider = NSItemProvider(object: UIImage(systemName: "text.bubble")!)
        //This is a bit ugly, though I could not find other ways to show text content below title.
        //https://stackoverflow.com/questions/60563773/ios-13-share-sheet-changing-subtitle-item-description
        //You may need to escape some special characters like "/".
        metadata.originalURL = URL(fileURLWithPath: text)
        return metadata
    }
}

