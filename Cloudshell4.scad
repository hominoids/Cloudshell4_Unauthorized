/*
    CloudShell4 Unauthorized Copyright 2020,2021,2022 Edward A. Kisiel
    hominoid @ www.forum.odroid.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Code released under GPLv3: http://www.gnu.org/licenses/gpl.html

    20201103 Version 1.0.0  Cloudshell2 case conversion for the Odroid-HC4
    20201114 Version 1.0.1  fixed io plate alignment in dxf file
                            increased segment count for circles in stl files
    20201118 Version 1.1.0  rewrite to add multi-sbc support. added Odroid-N1, N2 and N2+
    20201201 Version 1.2.0  added Cloudshell4, MiniXL and  Mini 3d printable cases
                            switched to sbccfw_library.scad
                            added oled mount for HC4
                            added ir window for HC4 (experimental)
                            fixed hc4 sdcard opening
    20210128 Version 1.2.1  added Vu5 bracket front attachment option
                            strengthened oled holder
                            changed width of 2.5" hdd tray from 100mm to 101.6mm
                            fixed topfan option selection
                            code cleanup
    20210226 Version 1.2.2  added 173mm bottom tray for Cloudshell4 and MiniXL
                            changed ir window to a square shouldered inset, HK logo or custom dxf
                            fixed ir window placement for Cloudshell2 and Cloudshell4
                            added additional hd holes for Cloudshell4
    20220420 Version 1.3.0  added Odroid-M1 Cloudshell4, MiniXL, Mini, MiniXS, Cloudshell4-XL Cloudshell4-XXL
                            fixed dxf MTEXT error, changed to sbc_case_builder_library.scad
                            included sbc_model_framework library, other maintenance and fixes
                            
*/

use <./lib/sbc_models.scad>;
use <./lib/sbc_case_builder_library.scad>;

mode = "model";                     // "platter", "model", "accessories", "debug"
cs4_model = "hc4";                  // "hc4","m1","n2+","n2","n1","xu4"
cs4_style = "Cloudshell4";          // "Cloudshell4", "Cloudshell4-Mini", "Cloudshell4-MiniXL", "Cloudshell2"
                                    // Odroid-M1 Only "Cloudshell4-MiniXS", "Cloudshell4-XL", "Cloudshell4-XXL"
cs4_oled = true;                    // oled mount and cutout for hc4 true or flase
cs4_irwindow = 2;                   // 0=none, 1=rectangular(typical 10mmx8mm), 
                                    // 2=HK logo(irscale=.6, size 12mmx12mm, 3=custom(irscale=.5 size 28mmx6.2mm)
cs4_irscale = .6;                   // scale of HK logo or custom
cs4_irxsize = 12;                   // x axis size of ir window 12mm or custom
cs4_irysize = 12;                   // y axis size of ir window 12mm or custom
cs4_topfan = 1;                     // 0=none, 1=top mount fan for hc4
cs4_backfan = 0;                    // 0=92mm 1=dual 80mm fans for Cloudshell4-XL
cs4_vu5front = 0;                   // 0=none, 1=top mount point for front vu5 bracket
sidethick = 3;                      // 5mm for Cloudshell2, 3mm for Cloudshell4, MiniXL and Mini
wallthick = 3;                      // 3mm for Cloudshell2, Cloudshell4, MiniXL and Mini

adjust = .01;
$fn=90;

// platter view
if (mode == "platter") {
    if(cs4_style == "Cloudshell2") {
        if(cs4_model == "n2+"  || cs4_model == "n2") {
            translate([0,0,0]) cs4_top(cs4_model,cs4_style);
        }
        else {      
            translate([0,110,0]) rotate([180,0,0]) cs4_top(cs4_model,cs4_style);
        }
        translate([120,0,0]) cs4_io(cs4_model,cs4_style);
        translate([120,55,0]) cs4_deck(cs4_model,cs4_style);
        translate([100.95,150,0]) rotate([0,180,0]) cs4_front(cs4_model,cs4_style);
    }
    if(cs4_style == "Cloudshell4-MiniXS" && cs4_model == "m1") {
        translate([0,0,0]) cs4_top(cs4_model,cs4_style);
        translate([120,0,0]) cs4_io(cs4_model,cs4_style);
        translate([120,55,0]) cs4_deck(cs4_model,cs4_style);
        translate([0,145,0]) rotate([0,0,0]) cs4_front(cs4_model,cs4_style);    
        translate([240,100,sidethick]) rotate([180,0,0])
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_MiniXS.dxf");
        translate([240,110,0]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXS.dxf");   
        translate([120,110,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
        translate([130,180,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([0,240,0]) hdd35_25holder(128);
    }
    if(cs4_style == "Cloudshell4-Mini") {
        if(cs4_model == "n2+"  || cs4_model == "n2" || cs4_model == "m1") {
            translate([0,0,0]) cs4_top(cs4_model,cs4_style);
            translate([0,140,0]) cs4_front(cs4_model,cs4_style);    
        }
        else {         
            translate([0,110,0]) rotate([180,0,0]) cs4_top(cs4_model,cs4_style);
            translate([100.95,130,0]) rotate([0,180,0]) cs4_front(cs4_model,cs4_style);    
        }
        translate([120,0,0]) cs4_io(cs4_model,cs4_style);
        translate([120,55,0]) cs4_deck(cs4_model,cs4_style);
        translate([240,100,sidethick]) rotate([180,0,0])
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_Mini.dxf");
        translate([240,110,0]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_Mini.dxf");   
        translate([120,110,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
        translate([130,180,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([150,240,0]) hdd35_25holder(100);
        translate([0,240,0]) hdd35_25holder(128);
    }
    if(cs4_style == "Cloudshell4-MiniXL") {
        if(cs4_model == "n2+"  || cs4_model == "n2" || cs4_model == "m1") {
            translate([0,0,0]) cs4_top(cs4_model,cs4_style);
            translate([0,145,0]) cs4_front(cs4_model,cs4_style);
        }
        else {           
            translate([0,110,0]) rotate([180,0,0]) cs4_top(cs4_model,cs4_style);
            translate([100.95,130,0]) rotate([0,180,0]) cs4_front(cs4_model,cs4_style);
        }
        translate([120,0,0]) cs4_io(cs4_model,cs4_style);
        translate([120,55,0]) cs4_deck(cs4_model,cs4_style);
        translate([240,100,sidethick]) rotate([180,0,0])
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_MiniXL.dxf");
        translate([240,110,0]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_MiniXL.dxf");   
        translate([120,160,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
        translate([130,225,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([190,250,0]) hdd35_25holder(100);
        translate([0,250,0]) hdd35_25holder(173);
    }
    if(cs4_style == "Cloudshell4") {
        if(cs4_model == "n2+"  || cs4_model == "n2" || cs4_model == "m1") {
            translate([0,0,0]) cs4_top(cs4_model,cs4_style);
            translate([0,135,0]) cs4_front(cs4_model,cs4_style);
        }
        else {          
            translate([0,110,0]) rotate([180,0,0]) cs4_top(cs4_model,cs4_style);
            translate([100.95,130,0]) rotate([0,180,0]) cs4_front(cs4_model,cs4_style);
        }
        translate([120,0,0]) cs4_io(cs4_model,cs4_style);
        translate([120,50,0]) cs4_deck(cs4_model,cs4_style);
        translate([240,140,sidethick]) rotate([180,0,0])
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide.dxf");
        translate([240,160,0]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide.dxf");  
        translate([120,150,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan.dxf");
        translate([200,260,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([0,270,0]) hdd35_25holder(173);
        }
    if((cs4_style == "Cloudshell4-XL" || cs4_style == "Cloudshell4-XXL") && cs4_model == "m1") {
        if(cs4_style == "Cloudshell4-XL") {
            translate([240,195,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XL.dxf");
            translate([240,205,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XL.dxf");  
            translate([120,150,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XL.dxf");       
        }
        if(cs4_style == "Cloudshell4-XXL") {
            translate([240,250,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XXL.dxf");
            translate([240,260,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XXL.dxf");  
            translate([120,150,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XXL.dxf");
        }
        translate([0,0,0]) cs4_top(cs4_model,cs4_style);
        translate([0,140,0]) cs4_front(cs4_model,cs4_style);
        translate([120,0,0]) cs4_io(cs4_model,cs4_style);
        translate([120,50,0]) cs4_deck(cs4_model,cs4_style);
        translate([-25,130,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([-190,0,0]) hdd35_25holder(173);
        }
    }
// model view
if (mode == "model") {
    // cloudshell2
    if(cs4_style == "Cloudshell2") {
        translate([sidethick+5,139,124]) rotate([180,0,0]) sbc(cs4_model);   
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell2_RightSide.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell2_LeftSide.dxf");   
        color("white",.6) translate([sidethick-.5,208.5,10]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearFan.dxf");
        color("white",.6) translate([sidethick-.5,130,104]) cs4_deck(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,5,132]) cs4_top(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
        color("white",.6) translate([100+(sidethick+.5),140,98]) rotate([90,0,180]) 
            cs4_io(cs4_model,cs4_style);
        // upper 3.5 hdd
        translate([sidethick+100,33,65.5]) rotate([0,0,90]) hd35();
        // lower 3.5 hdd
        translate([sidethick+100,33,29]) rotate([0,0,90]) hd35();
        if(cs4_oled == true) {
            translate([67.225,10,83]) rotate([0,0,180]) hc4_oled();
        }            
    }
    // cloudshell4-miniXS
    if(cs4_style == "Cloudshell4-MiniXS" && cs4_model == "m1") {
        translate([sidethick+5,130.5,40]) rotate([180,0,0]) sbc(cs4_model);       
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_MiniXS.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXS.dxf");
        color("white",.6) translate([sidethick-.5,143.5,7]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_m1_MiniXS.dxf");
        color("white",.6) translate([sidethick-.5,126,17.5]) cs4_deck(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,4.5,45]) cs4_top(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
        color("white",.6) translate([100+(sidethick+.5),131,12]) rotate([90,0,180]) 
            cs4_io(cs4_model,cs4_style);
        // lower 2.5 hdd
        color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
        translate([sidethick+84,12,5]) rotate([0,0,90]) hd25(15);
        }
    // cloudshell4-mini
    if(cs4_style == "Cloudshell4-Mini") {
        if(cs4_model == "m1") {
            translate([sidethick+5,131,86]) rotate([180,0,0]) sbc(cs4_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_Mini.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_Mini.dxf");
            color("white",.6) translate([sidethick-.5,143.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,126,63.5]) cs4_deck(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,4.5,92]) cs4_top(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
            color("white",.6) translate([100+(sidethick+.5),131,58]) rotate([90,0,180]) 
                cs4_io(cs4_model,cs4_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,21.5]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
        }
        else {
            translate([sidethick+4.5,114,84]) rotate([180,0,0]) sbc(cs4_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_Mini.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_Mini.dxf");
            color("white",.6) translate([sidethick-.5,143.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,110,63]) cs4_deck(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,5,92]) cs4_top(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
            color("white",.6) translate([100+(sidethick+.5),115,58]) rotate([90,0,180]) 
                cs4_io(cs4_model,cs4_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,21.5]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
            // oled
            if(cs4_oled == true) {
                translate([67.225,10,43]) rotate([0,0,180]) hc4_oled();
            }
      
        }     
    }
    // cloudshell4-minixl
    if(cs4_style == "Cloudshell4-MiniXL") {
        if(cs4_model == "m1") {
            translate([sidethick+5,131,86]) rotate([180,0,0]) sbc(cs4_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) 
                    import(file = "./dxf/CloudShell4_RightSide_m1_MiniXL.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXL.dxf");
            color("white",.6) translate([sidethick-.5,188.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,127,63.25]) cs4_deck(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,5,92]) cs4_top(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
            color("white",.6) translate([100+(sidethick+.5),132,58]) rotate([90,0,180]) 
                cs4_io(cs4_model,cs4_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,32]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,3]) rotate([0,0,90]) hdd35_25holder(173);
        }
        else {
            translate([sidethick+4.5,114,84]) rotate([180,0,0]) sbc(cs4_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_MiniXL.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_MiniXL.dxf");
            color("white",.6) translate([sidethick-.5,188.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,111,63.25]) cs4_deck(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,5,92]) cs4_top(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
            color("white",.6) translate([100+(sidethick+.5),115,58]) rotate([90,0,180]) 
                cs4_io(cs4_model,cs4_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,21.5]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(173);
            // oled
            if(cs4_oled == true) {
                translate([67.225,10,43]) rotate([0,0,180]) hc4_oled();
            }
        }
    }
    // cloudshell4    
    if(cs4_style == "Cloudshell4") {
        if(cs4_model == "m1") {
            translate([sidethick+5,131,126]) rotate([180,0,0]) sbc(cs4_model);
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1.dxf");
            color("white",.6) translate([100+(sidethick+.5),132,98]) rotate([90,0,180]) 
                cs4_io(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,127,103.25]) cs4_deck(cs4_model,cs4_style);
        }   
        else {
            translate([sidethick+4.5,114,124]) rotate([180,0,0]) sbc(cs4_model);
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide.dxf");
            color("white",.6) translate([100+(sidethick+.5),115,98]) rotate([90,0,180]) 
                cs4_io(cs4_model,cs4_style);
            color("white",.6) translate([sidethick-.5,111,103.25]) cs4_deck(cs4_model,cs4_style);
        } 
        color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan.dxf");
        color("white",.6) translate([sidethick-.5,5,132]) cs4_top(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
        // bottom
        color("white",1) translate([sidethick+100,10,3]) rotate([0,0,90]) hdd35_25holder(173);
        // upper 3.5 hdd
        translate([sidethick+100,10,60.5]) rotate([0,0,90]) hd35();
        // lower 3.5 hdd
        translate([sidethick+100,10,17.5]) rotate([0,0,90]) hd35();
        // oled
        if(cs4_oled == true) {
            translate([67.225,10,83]) rotate([0,0,180]) hc4_oled();
        }            
    }
    // Cloudshell4-XL
    if(cs4_style == "Cloudshell4-XL" && cs4_model == "m1") {
        translate([sidethick+5,131,180.75]) rotate([180,0,0]) sbc(cs4_model);
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XL.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XL.dxf");
        color("white",.6) translate([100+(sidethick+.5),131.5,153]) rotate([90,0,180]) 
            cs4_io(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,127,158.25]) cs4_deck(cs4_model,cs4_style);   
        if(cs4_backfan == 0) {
        color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XL.dxf");
        }
        if(cs4_backfan == 1) {
            color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            difference() {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan80_m1_XL.dxf");
            translate([10,-9,0]) fan_mask(80,3,2);
            translate([10,70,0]) fan_mask(80,3,2);
            }
        }            
        color("white",.6) translate([sidethick-.5,5,187]) cs4_top(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
        // bottom
        color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(173);
        // 3.5 hdd
        translate([sidethick+100,9,114]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,81.75]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,49.75]) rotate([0,0,90]) hd35();
            translate([sidethick+100,9,17.75]) rotate([0,0,90]) hd35();
    }
    // Cloudshell4-XXL  
    if(cs4_style == "Cloudshell4-XXL" && cs4_model == "m1") {
        translate([sidethick+5,131,236]) rotate([180,0,0]) sbc(cs4_model);
        color("white",.6) translate([sidethick-.5,5,242]) cs4_top(cs4_model,cs4_style);
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XXL.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XXL.dxf");
        color("white",.6) translate([100+(sidethick+.5),131.5,208]) rotate([90,0,180]) 
            cs4_io(cs4_model,cs4_style);
        color("white",.6) translate([sidethick-.5,127,213.25]) cs4_deck(cs4_model,cs4_style);   
        if(cs4_backfan == 0) {
        color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XXL.dxf");
        }
        if(cs4_backfan == 1) {
            color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            difference() {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan80_m1_XXL.dxf");
            translate([10,-9,0]) fan_mask(80,3,2);
            translate([10,70,0]) fan_mask(80,3,2);
            }
        }            
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(cs4_model,cs4_style);
        // bottom
        color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(173);
        // 3.5 hdd
        translate([sidethick+100,9,178]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,146]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,114]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,81.75]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,49.75]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,17.75]) rotate([0,0,90]) hd35();
    }
}
// accessory platter
if (mode == "accessories") {
    // full size 2.5" tray
    color("white",.6) translate([0,0,0]) rotate([0,0,0]) hdd35_25holder(173);
    // minixl size 2.5" tray
    color("white",.6) translate([0,110,0]) rotate([0,0,0]) hdd35_25holder(145);
    // mini bottom
    color("white",.6) translate([0,220,0]) rotate([0,0,0]) hdd35_25holder(128);
    // short 2.5" tray
    color("white",.6) translate([0,330,0]) rotate([0,0,0]) hdd35_25holder(105);
}
// debug
if (mode == "debug") {
//    translate([100.95,0,0]) rotate([0,0,0]) cs4_front(cs4_model,cs4_style);
    translate([0,0,0]) rotate([0,0,0]) cs4_top(cs4_model,cs4_style);
//    translate([120,0,0]) cs4_io(cs4_model,cs4_style);
//    translate([120,55,0]) cs4_deck(cs4_model,cs4_style);
//    translate([0,145,0]) rotate([0,0,0]) cs4_front(cs4_model,cs4_style);    
//    translate([240,100,sidethick]) rotate([180,0,0])
//        linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_MiniXS.dxf");
//    translate([240,110,0]) 
//        linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXS.dxf");   
//    translate([120,110,0])
//        linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_m1_MiniXS.dxf");
//      color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
 
}

module cs4_top(model, mini) {
    if(model == "hc4") {
        difference() {
            union() {
                if(mini == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_hc4.dxf");
                }
                if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_hc4_Mini.dxf");
                }
                if(mini == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_hc4.dxf");
                }
                if(cs4_oled == true) {
                    translate([(100.95/2-(32.75/2)),wallthick,-wallthick-adjust]) cube([32.75,5,4]);
                    translate([(100.95/2-(32.75/2)),wallthick+3.5,0]) 
                        rotate([-45,0,0]) cube([32.75,2,2]);
                    translate([(100.95/2-(32.75/2))-1.5,wallthick,0]) rotate([0,45,0]) cube([2,5,2]);
                    translate([(100.95/2+(32.75/2))-1.5,wallthick,0]) rotate([0,45,0]) cube([2,5,2]);
                }
            }
            if(cs4_oled == true) {
                translate([(100.95/2-(32.75/2))+1.35,wallthick+1.75,wallthick-8]) cube([30,1.6,5]);
                translate([(100.95/2-(15/2)),wallthick-adjust,-wallthick-(adjust*2)]) 
                    cube([15,6+(adjust*2),2]);
            }
            if(cs4_topfan == 1) {
                translate([47.5,34,0]) rotate([0,0,45]) {
                    translate([0,0,-adjust]) cylinder(d=2.7, h=wallthick+(adjust*2));
                    translate([32,32,-adjust]) cylinder(d=2.7, h=wallthick+(adjust*2));
                    }
            // wire access
            translate([35,40,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));                        
            }
            if(cs4_vu5front == 1) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }
    }
    if(model == "m1") {        
        difference() {
            union() {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_m1.dxf");
                translate([0,4,wallthick-adjust]) cube([2.25,122.5,3.5]);
                translate([5.25,4,wallthick-adjust]) cube([2,122.5,3.5]);
                translate([0,4,6.5-adjust]) cube([7.25,122.5,2]);
                translate([7.375,4,-2.125+wallthick-adjust]) rotate([0,-45,0]) cube([2.8,122.5,3]);
                
                translate([93.5,4,wallthick-adjust]) cube([2.25,122.5,3.5]);
                translate([98.75,4,wallthick-adjust]) cube([2.25,122.5,3.5]);
                translate([93.5,4,6.5-adjust]) cube([7.5,122.5,2]);
                translate([93.125,4,-2.5+wallthick-adjust]) rotate([0,-45,0]) cube([3.575,122.5,3]);
            }
        }
        if(cs4_vu5front == 1) {
            translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
        }
    }        
    if(model == "n2+") {        
        difference() {
            union() {
                if(mini == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_n2plus.dxf");
                }
                if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2plus_Mini.dxf");
                }
                if(mini == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2plus.dxf");
                }
                if(cs4_oled == true) {
                    translate([33.5,wallthick,-wallthick-adjust]) cube([32.75,5,4]);
                }
                if(mini == "Cloudshell2") {
                    translate([0,43,wallthick-adjust]) cube([2.25,92,3.5]);
                    translate([5.25,43,wallthick-adjust]) cube([2,92,3.5]);
                    translate([0,43,6.5-adjust]) cube([7.25,92,1.5]);
                    translate([7.375,43,-2.125+wallthick-adjust]) rotate([0,-45,0]) cube([2.8,92,3]);
                    
                    translate([93.5,43,wallthick-adjust]) cube([2.25,92,3.5]);
                    translate([98.75,43,wallthick-adjust]) cube([2.25,92,3.5]);
                    translate([93.5,43,6.5-adjust]) cube([7.5,92,1.5]);
                    translate([93.125,43,-2.5+wallthick-adjust]) rotate([0,-45,0]) cube([3.575,92,3]);
                }
                else {
                    translate([0,18,wallthick-adjust]) cube([2.25,92,3.5]);
                    translate([5.25,18,wallthick-adjust]) cube([2,92,3.5]);
                    translate([0,18,6.5-adjust]) cube([7.25,92,1.5]);
                    translate([7.375,18,-2.125+wallthick-adjust]) rotate([0,-45,0]) cube([2.8,92,3]);
                    
                    translate([93.5,18,wallthick-adjust]) cube([2.25,92,3.5]);
                    translate([98.75,18,wallthick-adjust]) cube([2.25,92,3.5]);
                    translate([93.5,18,6.5-adjust]) cube([7.5,92,1.5]);
                    translate([93.125,18,-2.5+wallthick-adjust]) rotate([0,-45,0]) cube([3.575,92,3]);
                }
            }
            if(mini == "Cloudshell2") {
                translate([30,43,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));
            }
            else {
                translate([30,21.5,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));
            }
            if(cs4_vu5front == 1) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }
    }        
    if(model == "n2") {        
        difference() {
            union() {
                if(mini == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_n2.dxf");
                }
                if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2_Mini.dxf");
                }
                if(mini == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2.dxf");
                }
                if(mini == "Cloudshell2") {
                    translate([0,43,wallthick-adjust]) cube([2.25,92,9.5]);
                    translate([5.25,43,wallthick-adjust]) cube([2,92,9.5]);
                    translate([0,43,12-adjust]) cube([7.25,92,1.5]);
                    translate([7.375,43,-2.125+wallthick-adjust]) rotate([0,-45,0]) cube([2.8,92,3]);
                    
                    translate([93.5,43,wallthick-adjust]) cube([2.25,92,9.5]);
                    translate([98.75,43,wallthick-adjust]) cube([2.25,92,9.5]);
                    translate([93.5,43,12-adjust]) cube([7.5,92,1.5]);
                    translate([93.125,43,-2.5+wallthick-adjust]) rotate([0,-45,0]) cube([3.575,92,3]);
                }
                else {
                    translate([0,18,wallthick-adjust]) cube([2.25,92,9.5]);
                    translate([5.25,18,wallthick-adjust]) cube([2,92,9.5]);
                    translate([0,18,12-adjust]) cube([7.25,92,1.5]);
                    translate([7.375,18,-2.125+wallthick-adjust]) rotate([0,-45,0]) cube([2.8,92,3]);
                    
                    translate([93.5,18,wallthick-adjust]) cube([2.25,92,9.5]);
                    translate([98.75,18,wallthick-adjust]) cube([2.25,92,9.5]);
                    translate([93.5,18,12-adjust]) cube([7.5,92,1.5]);
                    translate([93.125,18,-2.5+wallthick-adjust]) rotate([0,-45,0]) cube([3.575,92,3]);
                }
            }
            if(mini == "Cloudshell2") {
                translate([30,43,-adjust]) cylinder(d=3, h=wallthick+(adjust*2));
            }
            else {
                translate([30,21.5,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));
            }
            if(cs4_vu5front == 1) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }
    }
    if(model == "n1") {
        difference() {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_n1.dxf");
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n1_Mini.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n1.dxf");
            }
            if(cs4_vu5front == 1) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }            
    }
    if(model == "xu4") {
        difference() {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_xu4.dxf");    
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_xu4_Mini.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_xu4.dxf");
            }
            if(cs4_vu5front == 1) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }      
    }
}


module cs4_io(model,mini) {
        if(model == "hc4") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_hc4.dxf");    
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_hc4_Mini.dxf");    
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_hc4.dxf");    
            }
        }    
        if(cs4_model == "m1") {
              linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_m1.dxf");    
        }
        if(cs4_model == "n2+" || cs4_model == "n2") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_n2plus.dxf");    
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n2plus_Mini.dxf");    
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n2plus.dxf");    
            }
        }
        if(model == "n1") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_n1.dxf");   
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n1_Mini.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n1.dxf");
            }
        }    
        if(model == "xu4") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_xu4.dxf");    
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_xu4_Mini.dxf");    
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_xu4.dxf");    
            }
        }    
    }


module cs4_deck(model,mini) {
        if(model == "hc4") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_hc4.dxf");    
            }
            if(mini == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_hc4_Mini.dxf");    
             }
            if(mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_hc4_MiniXL.dxf");    
             }
            if(mini == "Cloudshell4") {
               linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_hc4.dxf");    
            }
        }            
        if(cs4_model == "m1") {
            if(mini == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_Mini.dxf");    
            }
            if(mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_MiniXL.dxf");    
            }
            if(mini == "Cloudshell4-MiniXS") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_Mini.dxf");    
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1.dxf");    
            }
            if(mini == "Cloudshell4-XL" || mini == "Cloudshell4-XXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_XL.dxf");    
            }
        }
        if(cs4_model == "n2+") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_n2plus.dxf");    
            }
            if(mini == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_Mini.dxf");
            }
            if(mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_MiniXL.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus.dxf");    
            }
        }
        if(cs4_model == "n2") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_n2plus.dxf");    
            }
            if(mini == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_Mini.dxf");
            }
            if(mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_MiniXL.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus.dxf");    
            }
        }
        if(model == "n1") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_n1.dxf");   
            }
            if(mini == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n1_Mini.dxf");
            }
            if(mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n1_MiniXL.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n1.dxf");
            }
        }            
        if(model == "xu4") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_xu4.dxf");
            }
            if(mini == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_xu4_Mini.dxf");
            }
            if(mini == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_xu4_MiniXL.dxf");
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_xu4.dxf");
            }
        }   
    }

module cs4_front(model,mini) {
        if(model == "hc4") {
            difference() {
                if(mini == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");    
                }
                if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");
                }
                if(mini == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");
                }
                // front oled opening
                if(cs4_oled == true) {
                    if(mini == "Cloudshell2" || mini == "Cloudshell4") {
                        translate([(100.95/2-(27.5/2)),104,-.1]) cube([27.5,15,wallthick+.2]);
                    }
                    else {
                        translate([(100.95/2-(27.5/2)),64,-.1]) cube([27.5,15,wallthick+.2]);
                    }
                }
                if(cs4_irwindow == 1) {
                    if(mini == "Cloudshell2" || mini == "Cloudshell4") {
                        translate([84-(cs4_irxsize/2),111-(cs4_irysize/2),-adjust]) 
                            cube([cs4_irxsize,cs4_irysize,wallthick+(adjust*2)]);
                        translate([84-((cs4_irxsize+4)/2),111-((cs4_irysize+4)/2),-wallthick/2]) 
                            cube([cs4_irxsize+4,cs4_irysize+4,wallthick]);
                    }
                    else {
                        translate([84-(cs4_irxsize/2),71-(cs4_irysize/2),-adjust]) 
                            cube([cs4_irxsize,cs4_irysize,wallthick+(adjust*2)]);
                        translate([84-((cs4_irxsize+4)/2),71-((cs4_irysize+4)/2),-wallthick/2]) 
                            cube([cs4_irxsize+4,cs4_irysize+4,wallthick]);
                    }                 
                }
                if(cs4_irwindow == 2) {
                    if(mini == "Cloudshell2" || mini == "Cloudshell4") {
                        sub("art",83-(cs4_irxsize/2),108-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"hk_25mm.dxf",0);
                    }
                    else {
                        sub("art",83-(cs4_irxsize/2),68-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"hk_25mm.dxf",0);
                    }                 
                }
                if(cs4_irwindow == 3) {
                    if(mini == "Cloudshell2" || mini == "Cloudshell4") {
                        sub("art",84-(cs4_irxsize/2),110-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"customart.dxf",0);
                    }
                    else {
                        sub("art",84-(cs4_irxsize/2),70-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"customart.dxf",0);
                    }                 
                }
            }
        }            
        if(cs4_model == "m1") {
            difference() {
                if(mini == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1.dxf");    
                }
                if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_Mini.dxf");  
                }
                if(mini == "Cloudshell4-MiniXS") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_MiniXS.dxf");  
                }
                if(mini == "Cloudshell4-XL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_XL.dxf");  
                }
                if(mini == "Cloudshell4-XXL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_XXL.dxf");  
                }
                if(cs4_irwindow == 0) {
                    if(mini == "Cloudshell4") {
                        translate([37.375-(cs4_irxsize/2),117.75-(cs4_irysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                    }
                    if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                        translate([37.375-(cs4_irxsize/2),77.75-(cs4_irysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                    if(mini == "Cloudshell4-MiniXS") {
                        translate([37.375-(cs4_irxsize/2),31.75-(cs4_irysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                    if(mini == "Cloudshell4-XL") {
                        translate([37.375-(cs4_irxsize/2),172.5-(cs4_irysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                    if(mini == "Cloudshell4-XXL") {
                        translate([37.375-(cs4_irxsize/2),227.875-(cs4_irysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                }
                if(cs4_irwindow == 1) {
                    if(mini == "Cloudshell4") {
                        translate([31.5-(cs4_irxsize/2),112-(cs4_irysize/2),-adjust]) 
                            cube([cs4_irxsize,cs4_irysize,wallthick+(adjust*2)]);
                        translate([31.5-((cs4_irxsize+4)/2),112-((cs4_irysize+4)/2),-wallthick/2]) 
                            cube([cs4_irxsize+4,cs4_irysize+4,wallthick]);
                    }
                    if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                        translate([31.5-(cs4_irxsize/2),72-(cs4_irysize/2),-adjust]) 
                            cube([cs4_irxsize,cs4_irysize,wallthick+(adjust*2)]);
                        translate([31.5-((cs4_irxsize+4)/2),72-((cs4_irysize+4)/2),-wallthick/2]) 
                            cube([cs4_irxsize+4,cs4_irysize+4,wallthick]);
                    }                 
                    if(mini == "Cloudshell4-MiniXS") {
                        translate([31.5-(cs4_irxsize/2),25.75-(cs4_irysize/2),-adjust]) 
                            cube([cs4_irxsize,cs4_irysize,wallthick+(adjust*2)]);
                        translate([31.5-((cs4_irxsize+4)/2),25.75-((cs4_irysize+4)/2),-wallthick/2]) 
                            cube([cs4_irxsize+4,cs4_irysize+4,wallthick]);
                     }                 
                    if(mini == "Cloudshell4-XL") {
                        translate([31.5-(cs4_irxsize/2),166.75-(cs4_irysize/2),-adjust]) 
                            cube([cs4_irxsize,cs4_irysize,wallthick+(adjust*2)]);
                        translate([31.5-((cs4_irxsize+4)/2),166.75-((cs4_irysize+4)/2),-wallthick/2]) 
                            cube([cs4_irxsize+4,cs4_irysize+4,wallthick]);
                     }                 
                }
                if(cs4_irwindow == 2) {
                    if(mini == "Cloudshell4") {
                        sub("art",39.5-(cs4_irxsize/2),108-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"hk_25mm.dxf",0);
                    }
                    if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                        sub("art",39.5-(cs4_irxsize/2),68-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"hk_25mm.dxf",0);
                    }                 
                    if(mini == "Cloudshell4-MiniXS") {
                        sub("art",30.5-(cs4_irxsize/2),24-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"hk_25mm.dxf",0);
                     }                 
                    if(mini == "Cloudshell4-XL") {
                        sub("art",30.5-(cs4_irxsize/2),165-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"hk_25mm.dxf",0);
                     }                 
                }
                if(cs4_irwindow == 3) {
                    if(mini == "Cloudshell4") {
                        sub("art",32-(cs4_irxsize/2),112-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"customart.dxf",0);
                    }
                    if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                        sub("art",32-(cs4_irxsize/2),72-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"customart.dxf",0);
                    }                 
                    if(mini == "Cloudshell4-MiniXS") {
                        sub("art",21-(cs4_irxsize/2),28-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"customart.dxf",0);
                     }                 
                    if(mini == "Cloudshell4-XL") {
                        sub("art",21-(cs4_irxsize/2),170-(cs4_irysize/2),-adjust,"top",[0,0,0],
                            cs4_irxsize,cs4_irysize,0,cs4_irscale,wallthick+2,"customart.dxf",0);
                     }                 
                }
                if(mini == "Cloudshell4") {
                    // audio jack
                    translate([82.625,117.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,115.75,-1]) cube([14,2.5,5]);
                    translate([18.5,117.25,5]) sphere(d=10);
                }
                if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                    // audio jack
                    translate([82.625,77.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,75.625,-1]) cube([14,2.5,5]);
                    translate([18.5,77.125,5]) sphere(d=10);
                }
                if(mini == "Cloudshell4-MiniXS") {
                    // audio jack
                    translate([82.625,31.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,29.625,-1]) cube([14,2.5,5]);
                    translate([18.5,31.125,5]) sphere(d=10);
                }
                if(mini == "Cloudshell4-XL") {
                    // audio jack
                    translate([82.625,172,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,170.5,-1]) cube([14,2.5,5]);
                    translate([18.5,171.5,5]) sphere(d=10);
                }
                if(mini == "Cloudshell4-XXL") {
                    // audio jack
                    translate([82.625,227.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,225.75,-1]) cube([14,2.5,5]);
                    translate([18.5,227.25,5]) sphere(d=10);
                }
            }
        }
        if(cs4_model == "n2+") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");    
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
               linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");  
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");    
            }
        }
        if(cs4_model == "n2") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");    
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
               linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");  
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");    
            }
        }
        if(model == "n1") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");   
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
               linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");  
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");
            }
        }            
        if(model == "xu4") {
            if(mini == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");
            }
            if(mini == "Cloudshell4-Mini" || mini == "Cloudshell4-MiniXL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");  
            }
            if(mini == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");
            }
        }   
    }