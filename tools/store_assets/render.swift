import AppKit
import CoreText

// Matches the existing App Store series: mint/teal gradient, white type,
// and a large angled white iPhone. UI comes only from native captures.
let root = URL(fileURLWithPath:FileManager.default.currentDirectoryPath)
CTFontManagerRegisterFontsForURL(root.appendingPathComponent("tools/store_assets/Roboto.ttf") as CFURL,.process,nil)
func font(_ size:CGFloat,_ weight:NSFont.Weight) -> NSFont {
    let base=NSFont(name:"Roboto",size:size) ?? NSFont.systemFont(ofSize:size)
    return NSFontManager.shared.convert(base,toHaveTrait:weight == .bold ? .boldFontMask : [])
}
func color(_ hex:Int) -> NSColor {
    NSColor(srgbRed:CGFloat((hex>>16)&255)/255,green:CGFloat((hex>>8)&255)/255,
            blue:CGFloat(hex&255)/255,alpha:1)
}
func text(_ value:String,_ rect:NSRect,_ size:CGFloat,_ weight:NSFont.Weight = .bold) {
    let style=NSMutableParagraphStyle();style.lineSpacing=size*0.08
    (value as NSString).draw(in:rect,withAttributes:[.font:font(size,weight),
        .foregroundColor:NSColor.white,.paragraphStyle:style])
}
func phone(_ image:NSImage,center:NSPoint,height:CGFloat,angle:CGFloat) {
    let width=height*image.size.width/image.size.height
    NSGraphicsContext.saveGraphicsState()
    let c=NSGraphicsContext.current!.cgContext
    c.translateBy(x:center.x,y:center.y);c.rotate(by:angle * .pi/180)
    let rect=NSRect(x:-width/2,y:-height/2,width:width,height:height)
    NSColor.white.setFill()
    let bezel=NSBezierPath(roundedRect:rect.insetBy(dx:-22,dy:-22),xRadius:72,yRadius:72)
    let shadow=NSShadow();shadow.shadowColor=NSColor.black.withAlphaComponent(0.25)
    shadow.shadowBlurRadius=35;shadow.shadowOffset=NSSize(width:-12,height:-12);shadow.set()
    bezel.fill()
    NSShadow().set()
    NSBezierPath(roundedRect:rect,xRadius:52,yRadius:52).addClip()
    image.draw(in:rect,from:.zero,operation:.sourceOver,fraction:1,respectFlipped:true,
               hints:[.interpolation:NSImageInterpolation.high])
    NSGraphicsContext.restoreGraphicsState()
}
func render(_ width:Int,_ height:Int,_ name:String,_ image:NSImage?) throws {
    let w=CGFloat(width),h=CGFloat(height)
    let cg=CGContext(data:nil,width:width,height:height,bitsPerComponent:8,bytesPerRow:width*4,
        space:CGColorSpace(name:CGColorSpace.sRGB)!,bitmapInfo:CGImageAlphaInfo.noneSkipLast.rawValue)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current=NSGraphicsContext(cgContext:cg,flipped:true)
    cg.translateBy(x:0,y:h);cg.scaleBy(x:1,y:-1)
    let bounds=NSRect(x:0,y:0,width:w,height:h)
    NSGradient(starting:color(0x00D199),ending:color(0x2E78AA))!.draw(in:bounds,angle:90)
    let portrait=h>w
    if name == "duo-outer-categories" {
        text("ALL CATEGORIES\nONE PLACE",NSRect(x:w*0.10,y:h*0.07,width:w*0.82,height:h*0.18),w*0.075)
        text("Who Am I? + Chameleon",NSRect(x:w*0.10,y:h*0.215,width:w*0.82,height:h*0.07),w*0.038,.semibold)
        if let image { phone(image,center:NSPoint(x:w*0.55,y:h*0.62),height:h*0.64,angle:8) }
    } else if portrait {
        text("ALL CATEGORIES\nONE PLACE",NSRect(x:w*0.10,y:h*0.07,width:w*0.75,height:h*0.17),w*0.075)
        text("Animals\nMusic\nMovies\nFood\nElectronics\n& more...",
             NSRect(x:w*0.10,y:h*0.29,width:w*0.49,height:h*0.48),w*0.047,.semibold)
        if let image { phone(image,center:NSPoint(x:w*1.03,y:h*0.61),height:h*1.05,angle:15) }
    } else {
        text("HINT MASTER",NSRect(x:w*0.075,y:h*0.12,width:w*0.54,height:h*0.1),h*0.046,.semibold)
        text("ALL CATEGORIES.\nONE PLACE.",NSRect(x:w*0.075,y:h*0.29,width:w*0.58,height:h*0.4),h*((name == "search" || name.contains("duo-inner")) ? 0.073 : 0.105))
        text("Who Am I? + Chameleon",NSRect(x:w*0.075,y:h*0.79,width:w*0.55,height:h*0.1),h*0.045,.semibold)
        if let image { phone(image,center:NSPoint(x:w*0.79,y:h*0.56),height:h*(image.size.width > image.size.height ? 0.58 : 1.14),angle:15) }
    }
    NSGraphicsContext.restoreGraphicsState()
    let output=root.appendingPathComponent("docs/store-assets/creative/en-US")
    try FileManager.default.createDirectory(at:output,withIntermediateDirectories:true)
    let rep=NSBitmapImageRep(cgImage:cg.makeImage()!)
    try rep.representation(using:.png,properties:[:])!.write(to:output.appendingPathComponent(name+".png"))
}
let source=root.appendingPathComponent("docs/store-assets/raw/en-US/iphone-medium/01-categories.png")
guard let image=NSImage(contentsOf:source) else { fatalError("Capture the English premium iPhone first") }
try render(3840,1646,"header",image)
try render(1920,1280,"search",image)
try render(1206,2622,"iphone-categories",image)
try render(1024,500,"play-feature",nil)

for (device,width,height) in [("duo-outer",1398,2034),("duo-inner",2853,2007),("ipad-13",2064,2752)] {
    let path=root.appendingPathComponent("docs/store-assets/raw/en-US/\(device)/01-categories.png")
    if let captured=NSImage(contentsOf:path) { try render(width,height,"\(device)-categories",captured) }
}
