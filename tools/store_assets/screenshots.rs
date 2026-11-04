use desigma_doc::*;
use desigma_render::{render_page, register_font, tiny_skia::Pixmap, Viewport};
use std::fs;
fn col(h:&str)->Color { Color::from_hex(h).unwrap() }
fn add(d:&mut Document,p:NodeId,mut n:Node,name:&str)->NodeId { n.name=name.into();d.insert(p,n).unwrap() }
fn rect(d:&mut Document,p:NodeId,r:Rect,fill:Color,radius:f32,name:&str)->NodeId {let id=d.alloc_id();let mut n=Node::rectangle(id,r);n.fills=vec![Paint::solid(fill)];n.corner_radii=[radius;4];add(d,p,n,name)}
fn text(d:&mut Document,p:NodeId,r:Rect,t:&str,size:f32,c:Color,weight:u16,name:&str)->NodeId {let id=d.alloc_id();let style=TextStyle {font_family:"Roboto".into(),font_size:size,font_weight:weight,fills:vec![Paint::solid(c)],..Default::default()};add(d,p,Node::text(id,r,t,style),name)}
fn device(d:&mut Document,p:NodeId,cx:f32,cy:f32,w:f32,h:f32,angle:f32,img:&str,name:&str){
 let id=d.alloc_id();let mut n=Node::frame(id,Rect::new(0.,0.,w+28.,h+28.));n.transform=Affine::translate(cx,cy)*Affine::rotate(angle.to_radians())*Affine::translate(-(w+28.)/2.,-(h+28.)/2.);n.corner_radii=[42.;4];n.fills=vec![Paint::solid(col("FAF8EE"))];n.effects=vec![Effect::DropShadow{color:col("083049").with_alpha(0.28),offset:Vec2::new(0.,22.),radius:32.,spread:0.,visible:true,show_behind:true}];let g=add(d,p,n,name);
 let id=d.alloc_id();let mut n=Node::rectangle(id,Rect::new(14.,14.,w,h));n.corner_radii=[30.;4];n.fills=vec![Paint{kind:PaintKind::Image{image_ref:img.into(),scale_mode:ImageScaleMode::Fit},opacity:1.,visible:true,blend:BlendMode::Normal}];n.locked=true;add(d,g,n,"Real premium screenshot • replace image fill to update");
}
fn sticker(d:&mut Document,p:NodeId,r:Rect,t:&str,size:f32,color:Color,angle:f32){
 let id=d.alloc_id();let mut n=Node::frame(id,Rect::new(0.,0.,r.w,r.h));n.transform=Affine::translate(r.x,r.y)*Affine::rotate(angle.to_radians());n.fills=vec![Paint::solid(color)];n.corner_radii=[20.;4];let g=add(d,p,n,&format!("Sticker • {t}"));
 let id=text(d,g,Rect::new(10.,0.,r.w-20.,r.h),t,size,col("082F48"),800,&format!("COPY/en-US/{t}"));if let NodeKind::Text(t)=&mut d.get_mut(id).unwrap().kind{t.style.align_h=TextAlignH::Center;t.style.align_v=TextAlignV::Center;}
}

fn main(){
 let root=std::env::current_dir().unwrap();let out=root.join("docs/store-assets/creative/en-US/screenshots");fs::create_dir_all(&out).unwrap();
 register_font(fs::read(root.join("tools/store_assets/Roboto.ttf")).unwrap());
 let mut d=Document::new("Hint Master • App Store Screenshots • English");
 let sets=[("iphone",1206u32,2622u32),("duo-outer",1398,2034),("duo-inner",2853,2007),("ipad",2064,2752)];
 let copies=[("Your next", "game night.", "Two party games. One shared device.", "Choose from 16 categories.","01-categories"),
 ("Phone up.","Game on.","Hold it to your forehead. Friends give clues.","Guess as many words as you can before time runs out.","02-guess-word"),
 ("Friends in.","Secrets out.","Add your players and choose your Chameleons.","Shuffle the starting player or keep your order.","03-chameleon-setup"),
 ("Pass the phone.","Keep a secret.","Everyone gets a word except the Chameleon.","Peek in private. Pass the phone.","04-secret-role"),
 ("Give a clue.","Find the bluff.","Prove you know the word without giving it away.","Can you spot the Chameleon?", "05-reveal")];
 let mut manifest=String::new();
 for (set,w,h) in sets {let page=d.add_page(&format!("{} • English",set)); let wf=w as f32;let hf=h as f32;let landscape=w>h;
 for (i,(line1,line2,body,body2,file)) in copies.iter().enumerate(){
 let raw=root.join(format!("docs/store-assets/raw/en-US/screenshot-series/{set}/{file}.png"));
 let ready=raw.exists();let embedded=root.join(format!("docs/store-assets/creative/en-US/screenshots/embedded/{set}/{file}.png"));let bytes=if ready{fs::read(if embedded.exists(){embedded}else{raw}).unwrap()}else{vec![]};let iw=if ready{u32::from_be_bytes(bytes[16..20].try_into().unwrap()) as f32}else{wf};let ih=if ready{u32::from_be_bytes(bytes[20..24].try_into().unwrap()) as f32}else{hf};
 let img=format!("{set}-{file}");if ready{d.images.insert(img.clone(),bytes);}
 let id=d.alloc_id();let mut f=Node::frame(id,Rect::new(i as f32*(wf+160.),0.,wf,hf));f.fills=vec![Paint{kind:PaintKind::LinearGradient{handles:[Vec2::new(0.,0.),Vec2::new(0.8,1.),Vec2::new(1.,0.)],stops:vec![GradientStop{pos:0.,color:col("28D8AA")},GradientStop{pos:1.,color:col("3189B9")}]},opacity:1.,visible:true,blend:BlendMode::Normal}];f.kind.frame_props_mut().unwrap().clips_content=true;
 let frame=add(&mut d,page,f,&format!("{:02} • {} • {} × {}",i+1,line1,w,h));
 let margin=wf*0.065;let copyw=if landscape{wf*0.43}else{wf*0.87};let fs=if landscape{wf*0.052}else{(wf*0.092).min(hf*0.063)};
 let top=hf*0.085;
 text(&mut d,frame,Rect::new(margin,hf*0.035,copyw,65.),"Hint Master",if landscape{48.}else{wf*0.034},col("082F48"),700,"COPY/en-US/brand");
 sticker(&mut d,frame,Rect::new(margin,top,copyw,fs*1.4),line1,fs,col("FFF1CB"),-2.);
 sticker(&mut d,frame,Rect::new(margin,top+fs*1.65,copyw,fs*1.4),line2,fs,col("FFAA88"),-2.);
 let bodyfs=if landscape{wf*0.021}else{wf*0.035};let bodyy=top+fs*3.5;
 text(&mut d,frame,Rect::new(margin,bodyy,copyw,bodyfs*2.6),body,bodyfs,col("082F48"),600,"COPY/en-US/how-to-play");
 text(&mut d,frame,Rect::new(margin,bodyy+bodyfs*2.8,copyw,bodyfs*2.6),body2,bodyfs,col("082F48"),400,"COPY/en-US/supporting-detail");
 let (cx,mut cy,mut maxw,mut maxh)=if landscape{(wf*0.745,hf*0.53,wf*0.47,hf*0.80)}else{(wf*0.50,hf*0.685,wf*0.84,hf*0.58)};
 if set=="duo-outer" {cy+=hf*0.02;maxw*=0.9;maxh*=0.9;}
 let dh=maxh.min(maxw*ih/iw);let dw=dh*iw/ih;
 if ready{device(&mut d,frame,cx,cy,dw,dh,if i%2==0{-3.}else{3.},&img,"DEVICE • native full-version screenshot");}else{
 rect(&mut d,frame,Rect::new(cx-dw/2.,cy-dh/2.,dw,dh),col("082F48"),38.,"PENDING • not for upload");
 text(&mut d,frame,Rect::new(cx-dw*0.42,cy-70.,dw*0.84,140.),"Native capture pending",wf*0.042,col("FFF1CB"),700,"PENDING • RocketSim daily allowance exhausted");
 }
 if i==1 && !landscape {
 sticker(&mut d,frame,Rect::new(margin,hf*0.86,wf*0.84,hf*0.065),"Clues. Guesses. Big laughs.",wf*0.047,col("FFF1CB"),-2.);
 }
 manifest+=&format!("{set}\t{}\t{file}\t{w}\t{h}\t{}\n",frame.0,if ready{"ready"}else{"pending"});
 }
 }
 fs::write(out.join("app-store-screenshots-en-US.desigma"),d.to_json().unwrap()).unwrap();fs::write(out.join("frames.tsv"),manifest).unwrap();
 if std::env::var_os("HINT_SKIP_REVIEW").is_some(){println!("Created editable document");return;}
 for (set,w,h) in sets {let page=d.pages[sets.iter().position(|x|x.0==set).unwrap()];let zoom=240./w as f32;let mut pm=Pixmap::new(5*272,(h as f32*zoom) as u32).unwrap();render_page(&d,page,&Viewport{zoom,..Default::default()},&mut pm);pm.save_png(out.join(format!("{set}-review.png"))).unwrap();}
 println!("Created editable document with {} frames",d.pages.iter().map(|id|d.get(*id).unwrap().children.len()).sum::<usize>());
}
