import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // 固定为 iPhone 375×812 尺寸，模拟 iOS 开发体验
    let fixedSize = NSSize(width: 375, height: 812)
    self.setContentSize(fixedSize)
    self.minSize = fixedSize
    self.maxSize = fixedSize
    self.styleMask.remove(.resizable)
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
