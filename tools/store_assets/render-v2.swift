import AppKit
import CoreText

// Editable vector artwork. Every device screen is an unaltered native capture.
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
CTFontManagerRegisterFontsForURL(root.appendingPathComponent("tools/store_assets/Roboto.ttf") as CFURL, .process, nil)
func ink(_ hex: Int, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(srgbRed: CGFloat((hex >> 16) & 255)/255, green: CGFloat((hex >> 8) & 255)/255,
            blue: CGFloat(hex & 255)/255, alpha: alpha)
}
let navy = ink(0x082F48), cream = ink(0xFFF1CB), coral = ink(0xFFAA88)
func font(_ size: CGFloat, bold: Bool = true, italic: Bool = false) -> NSFont {
    let base = NSFont(name: "Roboto", size: size) ?? .systemFont(ofSize: size)
    var traits: NSFontTraitMask = bold ? .boldFontMask : []
    if italic { traits.insert(.italicFontMask) }
    return NSFontManager.shared.convert(base, toHaveTrait: traits)
}
func label(_ value: String, _ point: NSPoint, _ size: CGFloat, _ color: NSColor = navy,
           bold: Bool = true, italic: Bool = false, tracking: CGFloat = 0) {
    (value as NSString).draw(at: point, withAttributes: [
        .font: font(size, bold: bold, italic: italic), .foregroundColor: color, .kern: tracking,
    ])
}
func round(_ rect: NSRect, _ radius: CGFloat, _ fill: NSColor) {
    fill.setFill(); NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}
func transformed(_ center: NSPoint, _ degrees: CGFloat, _ draw: () -> Void) {
    NSGraphicsContext.saveGraphicsState()
    let cg = NSGraphicsContext.current!.cgContext
    cg.translateBy(x: center.x, y: center.y); cg.rotate(by: degrees * .pi/180)
    draw(); NSGraphicsContext.restoreGraphicsState()
}
func sticker(_ title: String, _ rect: NSRect, _ degrees: CGFloat, _ size: CGFloat,
             _ fill: NSColor, italic: Bool = false) {
    transformed(NSPoint(x: rect.midX, y: rect.midY), degrees) {
        let local = NSRect(x: -rect.width/2, y: -rect.height/2, width: rect.width, height: rect.height)
        round(local, rect.height*0.16, fill)
        let attrs: [NSAttributedString.Key: Any] = [.font: font(size, italic: italic), .foregroundColor: navy]
        let text = NSAttributedString(string: title, attributes: attrs)
        let measured = text.size()
        text.draw(at: NSPoint(x: -measured.width/2, y: -measured.height/2))
    }
}
func device(_ screenshot: NSImage, center: NSPoint, height: CGFloat, angle: CGFloat, tablet: Bool) {
    transformed(center, angle) {
        let width = height*screenshot.size.width/screenshot.size.height
        let screen = NSRect(x: -width/2, y: -height/2, width: width, height: height)
        let radius: CGFloat = tablet ? 32 : 42
        let shadow = NSShadow(); shadow.shadowColor = ink(0x05324E, 0.35)
        shadow.shadowBlurRadius = 48; shadow.shadowOffset = NSSize(width: 4, height: -26); shadow.set()
        round(screen.insetBy(dx: -16, dy: -16), radius+16, ink(0xFAF8EE))
        NSShadow().set()
        NSBezierPath(roundedRect: screen, xRadius: radius, yRadius: radius).addClip()
        screenshot.draw(in: screen, from: .zero, operation: .sourceOver, fraction: 1,
                        respectFlipped: true, hints: [.interpolation: NSImageInterpolation.high])
    }
}
func background(_ w: CGFloat, _ h: CGFloat) {
    NSGradient(starting: ink(0x28D8AA), ending: ink(0x3189B9))!
        .draw(in: NSRect(x: 0, y: 0, width: w, height: h), angle: 90)
    ink(0xFFFFFF, 0.09).setFill()
    NSBezierPath(ovalIn: NSRect(x: w*0.46, y: -h*0.25, width: w*0.65, height: w*0.65)).fill()
    ink(0xFFFFFF, 0.18).setStroke()
    let ring = NSBezierPath(ovalIn: NSRect(x: w*0.43, y: -h*0.38, width: w*0.72, height: w*0.72))
    ring.lineWidth = 3; ring.stroke()
    // Sparse paper-like accents around the composition, never over the app UI.
    for (x,y,angle) in [(0.46,0.13,-18.0),(0.94,0.18,25.0),(0.51,0.89,20.0),(0.08,0.88,-25.0)] {
        transformed(NSPoint(x:w*x,y:h*y), angle) {
            round(NSRect(x:-7,y:-24,width:14,height:48),7,cream.withAlphaComponent(0.65))
        }
    }
}
let ipadPath = root.appendingPathComponent("docs/store-assets/raw/en-US/ipad-13/02-categories-landscape.png")
let iphonePath = root.appendingPathComponent("docs/store-assets/raw/en-US/iphone-medium/01-categories.png")
guard let ipad = NSImage(contentsOf: ipadPath), let iphone = NSImage(contentsOf: iphonePath) else {
    fatalError("Capture the English premium landscape iPad and ordinary iPhone first")
}
func render(_ name: String, width: Int, height: Int) throws {
    let cg = CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,
                       space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(cgContext:cg,flipped:true)
    cg.translateBy(x:0,y:CGFloat(height)); cg.scaleBy(x:1,y:-1)
    background(CGFloat(width), CGFloat(height))
    if name == "header" {
        label("HINT MASTER",NSPoint(x:250,y:150),62,navy,tracking:3)
        label("CHARADES + CHAMELEON",NSPoint(x:255,y:290),34,navy,bold:false,tracking:2)
        sticker("BIG",NSRect(x:245,y:445,width:650,height:295),-4,285,cream)
        label("LAUGHS.",NSPoint(x:250,y:745),180,.white,tracking:-3)
        sticker("tiny clues.",NSRect(x:480,y:1040,width:650,height:150),-4,100,coral,italic:true)
        label("Your next game night starts here.",NSPoint(x:255,y:1390),45,navy,bold:false)
        device(ipad,center:NSPoint(x:2480,y:790),height:1100,angle:-6,tablet:true)
        device(iphone,center:NSPoint(x:3500,y:970),height:1040,angle:8,tablet:false)
        sticker("16 CATEGORIES",NSRect(x:2150,y:1495,width:570,height:95),3,39,cream)
    } else {
        label("HINT MASTER",NSPoint(x:110,y:80),44,navy,tracking:2)
        label("CHARADES + CHAMELEON",NSPoint(x:115,y:155),24,navy,bold:false,tracking:1)
        sticker("BIG",NSRect(x:110,y:255,width:480,height:225),-4,210,cream)
        label("LAUGHS.",NSPoint(x:105,y:485),124,.white,tracking:-2)
        sticker("tiny clues.",NSRect(x:175,y:655,width:450,height:105),-4,66,coral,italic:true)
        device(ipad,center:NSPoint(x:1320,y:830),height:700,angle:-6,tablet:true)
        device(iphone,center:NSPoint(x:410,y:1020),height:400,angle:8,tablet:false)
        sticker("YOUR NEXT GAME NIGHT",NSRect(x:1010,y:315,width:740,height:88),3,35,cream)
    }
    NSGraphicsContext.restoreGraphicsState()
    let out = root.appendingPathComponent("docs/store-assets/creative/en-US/v2/\(name).png")
    try NSBitmapImageRep(cgImage:cg.makeImage()!).representation(using:.png,properties:[:])!.write(to:out)
}
try render("header",width:3840,height:1646)
try render("search",width:1920,height:1280)
