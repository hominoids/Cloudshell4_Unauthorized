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
    20201201 Version 1.2.0  added Cloudshell4, MiniXL and style3d printable cases
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
    202302xx Version 2.0.0  added customizer gui, added h series cases, added individual part selection
                            added top fan selection, power button and h3 port extender for h3 cloudshell4,
                            added vu7 front mount for h3 cloudshell4, added hex vent for front, deck and top
                            
*/

use <./SBC_Model_Framework/sbc_models.scad>;
use <./lib/sbc_case_builder_library.scad>;

/* [Cloudshell4 Series] */
// viewing mode "model", "platter", "part"
view = "model"; // [model, platter, part]
individual_part = "bottom"; // [top, bottom, right, left, front, rear, deck, io_panel, accessories]
// base case design
case_style = "Cloudshell4"; // ["Cloudshell2", "Cloudshell4", "Cloudshell4-XL", "Cloudshell4-XXL", "Cloudshell4-Mini", "Cloudshell4-MiniXL",  "Cloudshell4-MiniXS"]
sbc_model = "hc4"; // ["xu4", "xu4q","n1", "n2", "n2+", "m1", "hc4", "h2", "h3"]
/* [Accessories] */
// top fan mount
top_fan =  "40mm"; // ["none","40mm","60mm","80mm","92mm","hex vent"]
// rear 40mm, dual 40mm, 92mm fan or rear dual 80mm fans for Cloudshell4-XL
back_fan = "92mm"; // ["40mm","dual 40mm","dual 80mm","92mm"]
// none, rectangle(typical 10mmx8mm), hk logo(irscale=.6, size 12mmx12mm), custom(irscale=.5, size 28mmx6.2mm)
front_vent = "none"; // ["none","hex vent"]
deck_vent = "none"; // ["none","hex vent"]

ir_window_style = "hk logo"; // ["none","rectangle","hk logo","custom"]
ir_scale = .6; // [.1:.1:4]
ir_xsize = 12; // [1:.25:50]
ir_ysize = 12; // [1:.25:50]
ir_custom_file = "customart.dxf";
// hc4 oled mount and cutout
oled_hc4 = true;
// h3 printed top standoffs 
h3_standoffs = false;
// h3 port extender
h3_port_extender = "none"; // ["none","header","remote"]
// h3 hk power button
h3_power_button = false;
// top mount point for front vu5 bracket
vu5_front = false;
// top mount point for h3 front vu7 bracket
vu7_front = false;


/* [Hidden] */
adjust = .01;
$fn=90;
spacer=[6.25,43,3.4,8.5,3,0,0,1,0,4.2,4];
// case wall thickness
wallthick = 3; // [3,5]
// case floor thickness
sidethick = 3; // [3,5]

// platter view
if (view == "platter") {
    if(case_style == "Cloudshell2") {
        if(sbc_model == "n2+"  || sbc_model == "n2") {
            translate([0,0,0]) cs4_top(sbc_model,case_style);
        }
        else {      
            translate([0,110,wallthick]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
        }
        translate([120,0,0]) cs4_io(sbc_model,case_style);
        translate([120,55,0]) cs4_deck(sbc_model,case_style);
        translate([100.95,150,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);
    }
    if(case_style == "Cloudshell4-MiniXS" && sbc_model == "m1") {
        translate([0,0,0]) cs4_top(sbc_model,case_style);
        translate([120,0,0]) cs4_io(sbc_model,case_style);
        translate([120,55,0]) cs4_deck(sbc_model,case_style);
        translate([0,145,0]) rotate([0,0,0]) cs4_front(sbc_model,case_style);    
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
    if(case_style == "Cloudshell4-Mini") {
        if(sbc_model == "n2+"  || sbc_model == "n2" || sbc_model == "m1") {
            translate([0,0,0]) cs4_top(sbc_model,case_style);
            translate([0,140,0]) cs4_front(sbc_model,case_style);    
        }
        else {         
            translate([0,110,0]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
            translate([100.95,130,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);    
        }
        translate([120,-5,0]) cs4_io(sbc_model,case_style);
        translate([120,55,0]) cs4_deck(sbc_model,case_style);
        if(sbc_model != "h3"  && sbc_model != "h2") {
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
        if(sbc_model == "h3"  || sbc_model == "h2") {
            translate([240,100,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_Mini.dxf");
            translate([240,110,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3_Mini.dxf");
            
            if(back_fan == "dual 40mm") { 
                translate([120,110,0])
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan40x2_h3_MiniXL.dxf");
            }
            else {
                translate([120,110,0])
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3_MiniXL.dxf");
            }     
            translate([130,180,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
            translate([150,240,0]) hdd35_25holder(100,111);
            translate([0,240,0]) hdd35_25holder(128,111);
            if(h3_port_extender == "remote") {
                translate([190,180,30]) rotate([0,180,90]) h3_port_extender_holder("top",wallthick);
                translate([190,200,-2.5]) rotate([0,0,90]) h3_port_extender_holder("bottom",wallthick);
            }
        }
    }
    if(case_style == "Cloudshell4-MiniXL") {
        if(sbc_model == "n2+"  || sbc_model == "n2" || sbc_model == "m1") {
            translate([0,0,0]) cs4_top(sbc_model,case_style);
            translate([0,145,0]) cs4_front(sbc_model,case_style);
        }
        else {           
            translate([0,110,3]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
            translate([100.95,130,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);
        }
        translate([120,-5,0]) cs4_io(sbc_model,case_style);
        translate([120,55,0]) cs4_deck(sbc_model,case_style);
        if(sbc_model != "h3"  && sbc_model != "h2") {
            translate([240,100,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_MiniXL.dxf");
            translate([240,110,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_MiniXL.dxf");   
            translate([120,160,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            translate([190,250,0]) hdd35_25holder(100);
            translate([0,250,0]) hdd35_25holder(173);
        }
        if(sbc_model == "h3"  || sbc_model == "h2") {
            translate([240,100,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_MiniXL.dxf");
            translate([240,110,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3_MiniXL.dxf");
            if(back_fan == "dual 40mm") { 
                translate([120,160,0])
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan40x2_h3_MiniXL.dxf");
            }
            else {
                translate([120,160,0])
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3_MiniXL.dxf");
            }
            translate([0,250,0]) hdd35_25holder(188,111);
        }
        translate([130,225,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([150,225,0]) rotate([-90,0,0]) cableholder_spacer();
        translate([165,225,0]) rotate([-90,0,0]) cableholder_spacer();
        translate([180,225,0]) rotate([-90,0,0]) cableholder_spacer();
        if(h3_port_extender == "remote") {
            translate([90,240,30]) rotate([0,180,90]) h3_port_extender_holder("top",wallthick);
            translate([40,240,-2.5]) rotate([0,0,90]) h3_port_extender_holder("bottom",wallthick);
        }
    }
    if(case_style == "Cloudshell4") {
        if(sbc_model == "n2+"  || sbc_model == "n2" || sbc_model == "m1") {
            translate([0,0,0]) cs4_top(sbc_model,case_style);
            translate([0,135,0]) cs4_front(sbc_model,case_style);
        }
        if(sbc_model != "n2+" && sbc_model != "n2" && sbc_model != "m1") {
            translate([0,110,0]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
            translate([100.95,125,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);
        }
        translate([120,0,-5]) cs4_io(sbc_model,case_style);
        translate([120,55,0]) cs4_deck(sbc_model,case_style);
        if(sbc_model == "h3" || sbc_model == "h2") {
            translate([240,140,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3.dxf");
            translate([240,160,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3.dxf");  
            translate([120,150,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3.dxf");
            translate([0,275,0]) hdd35_25holder(188,111);
        }
        if(sbc_model != "h3" && sbc_model != "h2") {        
            translate([240,140,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide.dxf");
            translate([240,160,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide.dxf");  
            translate([120,150,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan.dxf");
            translate([0,275,0]) hdd35_25holder(173);
        }
        translate([210,255,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([195,280,0]) rotate([-90,0,0]) cableholder_spacer();
        translate([210,280,0]) rotate([-90,0,0]) cableholder_spacer();
        translate([225,280,0]) rotate([-90,0,0]) cableholder_spacer();
        if(h3_port_extender == "remote") {
            translate([150,255,30]) rotate([0,180,90]) h3_port_extender_holder("top",wallthick);
            translate([185,255,-2.5]) rotate([0,0,90]) h3_port_extender_holder("bottom",wallthick);
        }
    }
    if((case_style == "Cloudshell4-XL" ||case_style== "Cloudshell4-XXL") && sbc_model == "m1") {
        if(case_style == "Cloudshell4-XL") {
            translate([240,195,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XL.dxf");
            translate([240,205,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XL.dxf");  
            translate([120,150,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XL.dxf");       
        }
        if(case_style == "Cloudshell4-XXL") {
            translate([240,250,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XXL.dxf");
            translate([240,260,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XXL.dxf");  
            translate([120,150,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XXL.dxf");
        }
        translate([0,0,0]) cs4_top(sbc_model,case_style);
        translate([0,140,0]) cs4_front(sbc_model,case_style);
        translate([120,0,0]) cs4_io(sbc_model,case_style);
        translate([120,50,0]) cs4_deck(sbc_model,case_style);
        translate([-25,130,0])
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        translate([-190,0,0]) hdd35_25holder(173);
        }
    }
    
// model view
if (view == "model") {
    // cloudshell2
    if(case_style == "Cloudshell2") {
        translate([sidethick+5,139,124]) rotate([180,0,0]) sbc(sbc_model);   
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell2_RightSide.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell2_LeftSide.dxf");   
        color("white",.6) translate([sidethick-.5,208.5,10]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearFan.dxf");
        color("white",.6) translate([sidethick-.5,130,104]) cs4_deck(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,5,132]) cs4_top(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
        color("white",.6) translate([100+(sidethick+.5),140,98]) rotate([90,0,180]) 
            cs4_io(sbc_model,case_style);
        // upper 3.5 hdd
        translate([sidethick+100,33,65.5]) rotate([0,0,90]) hd35();
        // lower 3.5 hdd
        translate([sidethick+100,33,29]) rotate([0,0,90]) hd35();
        if(oled_hc4 == true) {
            translate([67.225,10,83]) rotate([0,0,180]) hc4_oled();
        }            
    }
    // cloudshell4-miniXS
    if(case_style == "Cloudshell4-MiniXS" && sbc_model == "m1") {
        translate([sidethick+5,130.5,40]) rotate([180,0,0]) sbc(sbc_model);       
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_MiniXS.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXS.dxf");
        color("white",.6) translate([sidethick-.5,143.5,7]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_m1_MiniXS.dxf");
        color("white",.6) translate([sidethick-.5,126,17.5]) cs4_deck(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,4.5,45]) cs4_top(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
        color("white",.6) translate([100+(sidethick+.5),131,12]) rotate([90,0,180]) 
            cs4_io(sbc_model,case_style);
        // lower 2.5 hdd
        color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
        translate([sidethick+84,12,5]) rotate([0,0,90]) hd25(15);
        }
    // cloudshell4-mini
    if(case_style == "Cloudshell4-Mini") {
        if(sbc_model == "m1") {
            translate([sidethick+5,131,86]) rotate([180,0,0]) sbc(sbc_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_Mini.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_Mini.dxf");
            color("white",.6) translate([sidethick-.5,143.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,126,63.5]) cs4_deck(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,4.5,92]) cs4_top(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
            color("white",.6) translate([100+(sidethick+.5),131,58]) rotate([90,0,180]) 
                cs4_io(sbc_model,case_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,21.5]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
        }
        if(sbc_model != "h3"  && sbc_model != "h2" && sbc_model != "m1") {
            translate([sidethick+4.5,114,84]) rotate([180,0,0]) sbc(sbc_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_Mini.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_Mini.dxf");
            color("white",.6) translate([sidethick-.5,143.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,110,63]) cs4_deck(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,5,92]) cs4_top(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
            color("white",.6) translate([100+(sidethick+.5),115,58]) rotate([90,0,180]) 
                cs4_io(sbc_model,case_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,21.5]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(128);
            // oled
            if(oled_hc4 == true) {
                translate([67.225,10,43]) rotate([0,0,180]) hc4_oled();
            }
        }     
        if(sbc_model == "h3"  || sbc_model == "h2") {
            translate([sidethick+110,139,60]) rotate([0,0,180]) sbc(sbc_model);
            color("grey",.8) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_Mini.dxf");
            color("grey",.8) translate([110.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3_Mini.dxf");
            color("grey",.6) translate([110+(sidethick+.5),140,51]) rotate([90,0,180]) 
                cs4_io(sbc_model, case_style);
            color("lightgrey",.6) translate([sidethick-.5,135.25,56.25]) cs4_deck(sbc_model, case_style);
            if(back_fan == "dual 40mm") { 
                color("lightgrey",.6) translate([sidethick,153.5,10.75]) rotate([90,0,0]) 
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan40x2_h3_MiniXL.dxf");
            }
            else {
                color("lightgrey",.6) translate([sidethick,153.5,10.75]) rotate([90,0,0]) 
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3_MiniXL.dxf");
            }
            color("lightgrey",.6) translate([sidethick-.5,5,102]) cs4_top(sbc_model, case_style);
            color("lightgrey",.7) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model, case_style);
            // bottom
//            color("lightgrey",1) translate([sidethick+110,10,0]) rotate([0,0,90]) hdd35_25holder(188,111);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+110,10,21.5]) rotate([0,0,90]) hdd35_25holder(100,111);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+110,10,0]) rotate([0,0,90]) hdd35_25holder(128,111);

            if(h3_port_extender == "remote") {
                translate([77.5,15,63]) rotate([0,0,90]) h3_port_extender("remote");
                translate([77.5,15,63]) rotate([0,0,90]) h3_port_extender_holder("both",3);
                }
            if(h3_power_button == true) {
                translate([23,19.5,105]) hk_pwr_button();
            }
        }     
    }
    // cloudshell4-minixl
    if(case_style == "Cloudshell4-MiniXL") {
        if(sbc_model == "m1") {
            translate([sidethick+5,131,86]) rotate([180,0,0]) sbc(sbc_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) 
                    import(file = "./dxf/CloudShell4_RightSide_m1_MiniXL.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXL.dxf");
            color("white",.6) translate([sidethick-.5,188.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,127,63.25]) cs4_deck(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,5,92]) cs4_top(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
            color("white",.6) translate([100+(sidethick+.5),132,58]) rotate([90,0,180]) 
                cs4_io(sbc_model,case_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,32]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,3]) rotate([0,0,90]) hdd35_25holder(173);
        }
        if(sbc_model == "h3"  || sbc_model == "h2") {
            translate([sidethick+110+.5,139,60]) rotate([0,0,180]) sbc(sbc_model);
            color("grey",.8) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_MiniXL.dxf");
            color("grey",.8) translate([111+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3_MiniXL.dxf");
            color("grey",.6) translate([110+(sidethick+.5),140,51]) rotate([90,0,180]) 
                cs4_io(sbc_model, case_style);
            color("lightgrey",.6) translate([sidethick-.5,135.25,56.25]) cs4_deck(sbc_model, case_style);
            if(back_fan == "dual 40mm") { 
                color("lightgrey",.6) translate([sidethick,203.5,10.75]) rotate([90,0,0]) 
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan40x2_h3_MiniXL.dxf");
            }
            else {
                color("lightgrey",.6) translate([sidethick,203.5,10.75]) rotate([90,0,0]) 
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3_MiniXL.dxf");
            }
            color("lightgrey",.6) translate([sidethick-.5,5,102]) cs4_top(sbc_model, case_style);
            color("lightgrey",.7) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model, case_style);
            // bottom
            color("lightgrey",1) translate([sidethick+110,10,0]) rotate([0,0,90]) hdd35_25holder(188,111);
            color("darkgrey",1) translate([wallthick+9.4,26.5,24]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,86.5,24]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,128.5,24]) rotate([0,0,180]) cableholder_spacer();
            if(h3_port_extender == "remote") {
                translate([77.5,15,63]) rotate([0,0,90]) h3_port_extender("remote");
                translate([77.5,15,63]) rotate([0,0,90]) h3_port_extender_holder("both",3);
                }
            if(h3_power_button == true) {
                translate([23,19.5,105]) hk_pwr_button();
            }
            // lower 3.5 hdd
            translate([sidethick+111,10,17.5]) rotate([0,0,90]) hd35();
        }
        if(sbc_model != "h3"  && sbc_model != "h2" && sbc_model != "m1") {
            translate([sidethick+4.5,114,84]) rotate([180,0,0]) sbc(sbc_model);       
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_MiniXL.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_MiniXL.dxf");
            color("white",.6) translate([sidethick-.5,188.5,10]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            color("white",.6) translate([sidethick-.5,111,63.25]) cs4_deck(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,5,92]) cs4_top(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
            color("white",.6) translate([100+(sidethick+.5),115,58]) rotate([90,0,180]) 
                cs4_io(sbc_model,case_style);
            // upper 2.5 hdd
            color("white",1) translate([sidethick+100,10,21.5]) rotate([0,0,90]) hdd35_25holder(100);
            // lower 2.5 hdd
            color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(173);
            // oled
            if(oled_hc4 == true) {
                translate([67.225,10,43]) rotate([0,0,180]) hc4_oled();
            }
        }
    }
    // cloudshell4    
    if(case_style == "Cloudshell4") {
        if(sbc_model == "m1") {
            translate([sidethick+5,131,126]) rotate([180,0,0]) sbc(sbc_model);
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1.dxf");
            color("white",.6) translate([100+(sidethick+.5),132,98]) rotate([90,0,180]) 
                cs4_io(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,127,103.25]) cs4_deck(sbc_model,case_style);
            color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan.dxf");
            color("white",.6) translate([sidethick-.5,5,132]) cs4_top(sbc_model, case_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model, case_style);
            // bottom
            color("white",1) translate([sidethick+100,10,3]) rotate([0,0,90]) hdd35_25holder(173);
        }   
        if(sbc_model == "h3"  || sbc_model == "h2") {
            translate([sidethick+110,139,107]) rotate([0,0,180]) sbc(sbc_model);
            color("grey",.8) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3.dxf");
            color("grey",.8) translate([110.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3.dxf");
            color("grey",.6) translate([110+(sidethick+.5),140,98]) rotate([90,0,180]) 
                cs4_io(sbc_model, case_style);
            color("lightgrey",.6) translate([sidethick-.5,125.25,103.25]) cs4_deck(sbc_model, case_style);
            color("lightgrey",.6) translate([sidethick,203.5,10.75]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3.dxf");
            color("lightgrey",.6) translate([sidethick-.5,5,149]) cs4_top(sbc_model, case_style);
            color("lightgrey",.7) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model, case_style);
            // bottom
            color("lightgrey",1) translate([sidethick+110,10,0]) rotate([0,0,90]) hdd35_25holder(188,111);
            color("darkgrey",1) translate([wallthick+9.4,26.5,24]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,86.5,24]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,128.5,24]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,26.5,67]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,86.5,67]) rotate([0,0,180]) cableholder_spacer();
            color("darkgrey",1) translate([wallthick+9.4,128.5,67]) rotate([0,0,180]) cableholder_spacer();
            if(h3_port_extender == "remote") {
                translate([77.5,15,110]) rotate([0,0,90]) h3_port_extender("remote");
                translate([77.5,15,110]) rotate([0,0,90]) h3_port_extender_holder("both",3);
                }
            if(h3_power_button == true) {
                translate([23,19.5,152]) hk_pwr_button();
            }
            // upper 3.5 hdd
            translate([sidethick+111,10,60.5]) rotate([0,0,90]) hd35();
            // lower 3.5 hdd
            translate([sidethick+111,10,17.5]) rotate([0,0,90]) hd35();
        } 
        if(sbc_model != "m1" && sbc_model != "h2" && sbc_model != "h3") {
            translate([sidethick+4.5,114,124]) rotate([180,0,0]) sbc(sbc_model);
            color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide.dxf");
            color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide.dxf");
            color("white",.6) translate([100+(sidethick+.5),115,98]) rotate([90,0,180]) 
                cs4_io(sbc_model, case_style);
            color("white",.6) translate([sidethick-.5,111,103.25]) cs4_deck(sbc_model, case_style);
            color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan.dxf");
            color("white",.6) translate([sidethick-.5,5,132]) cs4_top(sbc_model, case_style);
            color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model, case_style);
            // bottom
            color("white",1) translate([sidethick+100,10,3]) rotate([0,0,90]) hdd35_25holder(173);
        }
        if(sbc_model != "h3" && sbc_model != "h2") {
            // upper 3.5 hdd
            translate([sidethick+100,10,60.5]) rotate([0,0,90]) hd35();
            // lower 3.5 hdd
            translate([sidethick+100,10,17.5]) rotate([0,0,90]) hd35();
        }
        // oled
        if(oled_hc4 == true) {
            translate([67.225,10,83]) rotate([0,0,180]) hc4_oled();
        }            
    }
    // Cloudshell4-XL
    if(case_style == "Cloudshell4-XL" && sbc_model == "m1") {
        translate([sidethick+5,131,180.75]) rotate([180,0,0]) sbc(sbc_model);
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XL.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XL.dxf");
        color("white",.6) translate([100+(sidethick+.5),131.5,153]) rotate([90,0,180]) 
            cs4_io(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,127,158.25]) cs4_deck(sbc_model,case_style);   
        if(back_fan == "92mm") {
        color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XL.dxf");
        }
        if(back_fan == "dual 80mm") {
            color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            difference() {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan80_m1_XL.dxf");
            translate([10,-9,0]) fan_mask(80,3,2);
            translate([10,70,0]) fan_mask(80,3,2);
            }
        }            
        color("white",.6) translate([sidethick-.5,5,187]) cs4_top(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
        // bottom
        color("white",1) translate([sidethick+100,10,0]) rotate([0,0,90]) hdd35_25holder(173);
        // 3.5 hdd
        translate([sidethick+100,9,114]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,81.75]) rotate([0,0,90]) hd35();
        translate([sidethick+100,9,49.75]) rotate([0,0,90]) hd35();
            translate([sidethick+100,9,17.75]) rotate([0,0,90]) hd35();
    }
    // Cloudshell4-XXL  
    if(case_style == "Cloudshell4-XXL" && sbc_model == "m1") {
        translate([sidethick+5,131,236]) rotate([180,0,0]) sbc(sbc_model);
        color("white",.6) translate([sidethick-.5,5,242]) cs4_top(sbc_model,case_style);
        color("white",.1) translate([-.5,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XXL.dxf");
        color("white",.1) translate([100.5+sidethick,0,0]) rotate([90,0,90]) 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XXL.dxf");
        color("white",.6) translate([100+(sidethick+.5),131.5,208]) rotate([90,0,180]) 
            cs4_io(sbc_model,case_style);
        color("white",.6) translate([sidethick-.5,127,213.25]) cs4_deck(sbc_model,case_style);   
        if(back_fan == "92mm") {
        color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XXL.dxf");
        }
        if(back_fan == "dual 80mm") {
            color("white",.6) translate([sidethick-.5,188.5,10.75]) rotate([90,0,0]) 
            difference() {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan80_m1_XXL.dxf");
            translate([10,-9,0]) fan_mask(80,3,2);
            translate([10,70,0]) fan_mask(80,3,2);
            }
        }            
        color("white",.6) translate([sidethick-.5,8,5]) rotate([90,0,0]) cs4_front(sbc_model,case_style);
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

 
// part
if (view == "part") {
    if(case_style == "Cloudshell2") {
        if(sbc_model == "n2+"  || sbc_model == "n2" && individual_part == "top") {
            translate([0,0,0]) cs4_top(sbc_model,case_style);
        }
        if(sbc_model != "n2+"  && sbc_model != "n2" && individual_part == "top") {
            translate([0,110,wallthick]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
        }
        if(individual_part == "io_panel") {
            cs4_io(sbc_model,case_style);
        }
        if(individual_part == "deck") {
            cs4_deck(sbc_model,case_style);
        }
        if(individual_part == "front") {
            translate([100.95,0,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);
        }
    }
    if(case_style == "Cloudshell4-MiniXS" && sbc_model == "m1") {
        if(individual_part == "top") {
            translate([0,0,0]) cs4_top(sbc_model,case_style);
        }
        if(individual_part == "io_panel") {
            translate([120,0,0]) cs4_io(sbc_model,case_style);
        }
        if(individual_part == "deck") {
            translate([120,55,0]) cs4_deck(sbc_model,case_style);
        }
        if(individual_part == "front") {
            translate([0,145,0]) rotate([0,0,0]) cs4_front(sbc_model,case_style);
        }
        if(individual_part == "right") {        
            translate([240,100,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_MiniXS.dxf");
        }
        if(individual_part == "left") {
            translate([240,110,0]) 
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_MiniXS.dxf");
        }
        if(individual_part == "rear") {
            translate([120,110,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
        }
        if(individual_part == "accessories") {
            translate([130,180,0])
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        }
        if(individual_part == "bottom") {
            translate([0,240,0]) hdd35_25holder(128);
        }
    }
    if(case_style == "Cloudshell4-Mini") {
        if(sbc_model == "n2+"  || sbc_model == "n2" || sbc_model == "m1") {
            if(individual_part == "top") {
                translate([0,0,0]) cs4_top(sbc_model,case_style);
            }
            if(individual_part == "front") {
                cs4_front(sbc_model,case_style);
            }
        }
        if(sbc_model != "n2+"  && sbc_model != "n2" && sbc_model != "m1") {
            if(individual_part == "top") {
                translate([0,110,0]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
            }
            if(individual_part == "front") {
                translate([100.95,0,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);    
            }
        }
        if(individual_part == "io_panel") {
            cs4_io(sbc_model,case_style);
        }
        if(individual_part == "deck") {
            cs4_deck(sbc_model,case_style);
        }
        if(sbc_model == "h3" || sbc_model == "h2") {
            if(individual_part == "right") {
                translate([0,100,sidethick]) rotate([180,0,0])
                    linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_Mini.dxf");
            }
            if(individual_part == "left") {
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3_Mini.dxf");
            }
            if(individual_part == "rear") {
               if(back_fan =="dual 40mm") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan40x2_h3_MiniXL.dxf");
                }
                else {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3_MiniXL.dxf");
                }
            }
        }
        else {
            if(individual_part == "right") {
                translate([0,100,sidethick]) rotate([180,0,0])
                    linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_Mini.dxf");
            }
            if(individual_part == "left") {
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_Mini.dxf");
            }
            if(individual_part == "rear") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_Mini.dxf");
            }            
        }
        if(individual_part == "accessories") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
            if(h3_port_extender == "remote") {
                translate([60,25,35]) rotate([0,180,90]) h3_port_extender_holder("top",wallthick);
                translate([60,5,-2]) rotate([0,0,90]) h3_port_extender_holder("bottom",wallthick);
            }
        }
        if(individual_part == "bottom") {
            translate([150,0,0]) hdd35_25holder(100);
            translate([0,0,0]) hdd35_25holder(128);
        }
    }
    if(case_style == "Cloudshell4-MiniXL") {
        if(sbc_model == "n2+" || sbc_model == "n2" || sbc_model == "m1") {
            if(individual_part == "top") {
                translate([0,0,0]) cs4_top(sbc_model,case_style);
            }
            if(individual_part == "front") {
                cs4_front(sbc_model,case_style);
            }
        }
        if(sbc_model != "n2+"  && sbc_model != "n2" && sbc_model != "m1") {
            if(individual_part == "top") {
                translate([0,110,0]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
            }
            if(individual_part == "front") {
                cs4_front(sbc_model,case_style);    
            }
        }
        if(individual_part == "io_panel") {
            cs4_io(sbc_model,case_style);
        }
        if(individual_part == "deck") {
            cs4_deck(sbc_model,case_style);
        }
        if(individual_part == "right" && sbc_model == "h3" || sbc_model == "h2") {        
            translate([0,100,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_MiniXL.dxf");
        }
        if(individual_part == "right" && sbc_model != "h3" && sbc_model != "h2") {        
            translate([0,100,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3_MiniXL.dxf");
        }
        if(individual_part == "left" && sbc_model == "h3" || sbc_model == "h2") { 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3_MiniXL.dxf");
        }
        if(individual_part == "left" && sbc_model != "h3" && sbc_model != "h2") { 
            linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_MiniXL.dxf");
        }
        if(individual_part == "rear" && back_fan == "dual 40mm" && sbc_model == "h3" || sbc_model == "h2") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan40x2_h3_MiniXL.dxf");
        }
        if(individual_part == "rear" && back_fan == "40mm" && sbc_model == "h3" || sbc_model == "h2") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3_MiniXL.dxf");
        }
        if(individual_part == "rear" && sbc_model != "h3" && sbc_model != "h2") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_MiniXL.dxf");
        }
        if(individual_part == "accessories") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
            if(h3_port_extender == "remote") {
                translate([60,25,35]) rotate([0,180,90]) h3_port_extender_holder("top",wallthick);
                translate([60,5,-2]) rotate([0,0,90]) h3_port_extender_holder("bottom",wallthick);
                translate([0,50,0]) rotate([-90,0,0]) cableholder_spacer();
                translate([15,50,0]) rotate([-90,0,0]) cableholder_spacer();
                translate([30,50,0]) rotate([-90,0,0]) cableholder_spacer();
            }
        }
        if(individual_part == "bottom" && sbc_model == "h3" || sbc_model == "h2") {
            translate([0,0,0]) hdd35_25holder(188,111);
        }
        if(individual_part == "bottom" && sbc_model != "h3" && sbc_model != "h2") {
            translate([180,0,0]) hdd35_25holder(100);
            translate([0,0,0]) hdd35_25holder(173);
        }
    }
    if(case_style == "Cloudshell4") {
        if(individual_part == "top") {
            if(sbc_model == "n2+"  || sbc_model == "n2" || sbc_model == "m1") {
                cs4_top(sbc_model,case_style);
            }
            else {          
                translate([0,110,0]) rotate([180,0,0]) cs4_top(sbc_model,case_style);
            }
        }
        if(individual_part == "front") {
            if(sbc_model == "n2+"  || sbc_model == "n2" || sbc_model == "m1") {
                cs4_front(sbc_model,case_style);
            }
            else {          
                translate([100.95,0,0]) rotate([0,180,0]) cs4_front(sbc_model,case_style);
            }
        }
        if(individual_part == "io_panel") {
            cs4_io(sbc_model,case_style);
        }
        if(individual_part == "deck") {
            cs4_deck(sbc_model,case_style);
        } 
        if(individual_part == "right" && sbc_model == "h3" || sbc_model == "h2") {
            translate([0,0,sidethick]) rotate([0,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_h3.dxf");
        }
        if(individual_part == "right" && sbc_model != "h3" && sbc_model != "h2") {
            translate([0,0,sidethick]) rotate([0,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide.dxf");
        }
        if(individual_part == "left" && sbc_model == "h3" || sbc_model == "h2") {
            translate([0,155,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_h3.dxf");
        }
        if(individual_part == "left" && sbc_model != "h3" && sbc_model != "h2") {
            translate([0,140,sidethick]) rotate([180,0,0])
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide.dxf");
        }
        if(individual_part == "rear" && sbc_model == "h3" || sbc_model == "h2") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan_h3.dxf");
        }
        if(individual_part == "rear" && sbc_model != "h3" && sbc_model != "h2") {
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan.dxf");
        }
        if(individual_part == "accessories") {        
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
            if(h3_port_extender == "remote") {
                translate([60,25,35]) rotate([0,180,90]) h3_port_extender_holder("top",wallthick);
                translate([60,5,-2]) rotate([0,0,90]) h3_port_extender_holder("bottom",wallthick);
            }
            translate([0,50,0]) rotate([-90,0,0]) cableholder_spacer();
            translate([15,50,0]) rotate([-90,0,0]) cableholder_spacer();
            translate([30,50,0]) rotate([-90,0,0]) cableholder_spacer();
        }
        if(individual_part == "bottom" && sbc_model == "h3" || sbc_model == "h2") {        
                hdd35_25holder(188,111);
        }
        if(individual_part == "bottom" && sbc_model != "h3" && sbc_model != "h2") {        
                hdd35_25holder(173);
        }
    }
    if((case_style == "Cloudshell4-XL" || case_style == "Cloudshell4-XXL") && sbc_model == "m1") {
        if(case_style == "Cloudshell4-XL") {
            if(individual_part == "right") {
                translate([0,195,sidethick]) rotate([180,0,0])
                    linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XL.dxf");
            }
            if(individual_part == "left") {
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XL.dxf");  
            }
            if(individual_part == "rear") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XL.dxf");       
            }
        }
        if(case_style == "Cloudshell4-XXL") {
            if(individual_part == "right") {
                translate([0,250,sidethick]) rotate([180,0,0])
                    linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_RightSide_m1_XXL.dxf");
            }
            if(individual_part == "left") {
                linear_extrude(height = sidethick) import(file = "./dxf/CloudShell4_LeftSide_m1_XXL.dxf");  
            }
            if(individual_part == "rear") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearFan92_m1_XXL.dxf");
            }

        }
        if(individual_part == "top") {
            cs4_top(sbc_model,case_style);
        }
        if(individual_part == "front") {
            cs4_front(sbc_model,case_style);
        } 
        if(individual_part == "io_panel") {
            cs4_io(sbc_model,case_style);
        }
        if(individual_part == "deck") {
            cs4_deck(sbc_model,case_style);
        } 
        if(individual_part == "accessories") {        
            linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Key_Mini.dxf");
        }
        if(individual_part == "bottom") {        
                hdd35_25holder(173);
        }
    }
}


module cs4_top(sbc_model, style) {
    if(sbc_model == "hc4") {
        difference() {
            union() {
                if(case_style == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_hc4.dxf");
                }
                if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_hc4_Mini.dxf");
                }
                if(case_style == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_hc4.dxf");
                }
                if(oled_hc4 == true) {
                    translate([(100.95/2-(32.75/2)),wallthick,-wallthick-adjust]) cube([32.75,5,4]);
                    translate([(100.95/2-(32.75/2)),wallthick+3.5,0]) 
                        rotate([-45,0,0]) cube([32.75,2,2]);
                    translate([(100.95/2-(32.75/2))-1.5,wallthick,0]) rotate([0,45,0]) cube([2,5,2]);
                    translate([(100.95/2+(32.75/2))-1.5,wallthick,0]) rotate([0,45,0]) cube([2,5,2]);
                }
            }
            if(oled_hc4 == true) {
                translate([(100.95/2-(32.75/2))+1.35,wallthick+1.75,wallthick-8]) cube([30,1.6,5]);
                translate([(100.95/2-(15/2)),wallthick-adjust,-wallthick-(adjust*2)]) 
                    cube([15,6+(adjust*2),2]);
            }
             if(top_fan == "hex vent") {
                translate([9.5,15,adjust]) vent_hex(17, 10, 4, 7.5, 2, "landscape");
            }
            if(top_fan == "40mm") {
                translate([47.5,34,0]) rotate([0,0,45]) {
                    translate([0,0,-adjust]) cylinder(d=2.7, h=wallthick+(adjust*2));
                    translate([32,32,-adjust]) cylinder(d=2.7, h=wallthick+(adjust*2));
                    }
            // wire access
            translate([35,40,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));                        
            }
            if(vu5_front == true) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }
    }
    if(sbc_model == "m1") {        
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
        if(vu5_front == true) {
            translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
        }
    }        
    if(sbc_model == "n2+") {        
        difference() {
            union() {
                if(case_style == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_n2plus.dxf");
                }
                if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2plus_Mini.dxf");
                }
                if(case_style == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2plus.dxf");
                }
                if(oled_hc4 == true) {
                    translate([33.5,wallthick,-wallthick-adjust]) cube([32.75,5,4]);
                }
                if(case_style == "Cloudshell2") {
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
            if(case_style == "Cloudshell2") {
                translate([30,43,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));
            }
            else {
                translate([30,21.5,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));
            }
            if(vu5_front == true) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }
    }        
    if(sbc_model == "n2") {        
        difference() {
            union() {
                if(case_style == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_n2.dxf");
                }
                if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2_Mini.dxf");
                }
                if(case_style == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n2.dxf");
                }
                if(case_style == "Cloudshell2") {
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
            if(case_style == "Cloudshell2") {
                translate([30,43,-adjust]) cylinder(d=3, h=wallthick+(adjust*2));
            }
            else {
                translate([30,21.5,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));
            }
            if(vu5_front == true) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }
    }
    if(sbc_model == "n1") {
        difference() {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_n1.dxf");
            }
            if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n1_Mini.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_n1.dxf");
            }
            if(vu5_front == true) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }            
    }
    if(sbc_model == "xu4") {
        difference() {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Top_xu4.dxf");    
            }
            if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_xu4_Mini.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_xu4.dxf");
            }
            if(vu5_front == true) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
        }      
    }
    if(sbc_model == "h3"  || sbc_model == "h2") {
        difference() {
            union() {
                if(case_style == "Cloudshell4" || case_style == "Cloudshell4-MiniXL" || case_style == "Cloudshell4-Mini") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Top_h3.dxf");
                }
            }
            if(h3_standoffs == true && case_style == "Cloudshell4" || case_style == "Cloudshell4-MiniXL" 
                    || case_style == "Cloudshell4-Mini") {
                translate([107.25,27.75,wallthick-(wallthick+adjust)+adjust]) cylinder(d=6.25, h=wallthick+2*adjust);
                translate([5,27.75,wallthick-(wallthick+adjust)+adjust]) cylinder(d=6.25, h=wallthick+2*adjust);
                translate([107.25,116.25,wallthick-(wallthick+adjust)+adjust]) cylinder(d=6.25, h=wallthick+2*adjust);
                translate([5,109.25,wallthick-(wallthick+adjust)+adjust]) cylinder(d=6.25, h=wallthick+2*adjust);
            }
            if(top_fan == "40mm") {
                translate([35.5,55,0]) fan_mask(40, wallthick, 2);
                // wire access
//                translate([110,90,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));                        
//                translate([60,85,-adjust]) cylinder(d=5, h=wallthick+(adjust*2));                        
            }
            if(top_fan == "60mm") {
                translate([26,45,0]) fan_mask(60, wallthick, 2);
                // wire access
                translate([110,100,-adjust]) cylinder(d=5, h=wallthick+(adjust*2));                        
//                translate([60,9,-adjust]) cylinder(d=4, h=wallthick+(adjust*2));                        
            }
            if(top_fan == "80mm") {
                translate([20.5,30,0]) fan_mask(80, wallthick, 2);
                // wire access
                translate([110,122,-adjust]) cylinder(d=5, h=wallthick+(adjust*2));                        
            }
             if(top_fan == "92mm") {
                translate([9.5,30,0]) fan_mask(92, wallthick, 2);
                // wire access
                translate([110,122,-adjust]) cylinder(d=5, h=wallthick+(adjust*2));                        
            }
             if(top_fan == "hex vent") {
                translate([9,30,adjust]) vent_hex(19, 9, 4, 7.5, 2, "landscape");
            }
            if(vu5_front == true) {
                translate([8,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([86.5,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
            if(vu7_front == true) {
                translate([1,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
                translate([104,wallthick,-adjust]) cube([6,8,wallthick+(adjust*2)]);
            }
            if(h3_power_button == true) {
                translate([20.5,14.5,10]) hk_pwr_button(true);
            }
        }
        if(h3_standoffs == true && case_style == "Cloudshell4" || case_style == "Cloudshell4-MiniXL" 
                    || case_style == "Cloudshell4-Mini") {
            if(h3_port_extender == "remote") {
                difference() {
                    translate([107.25,27.75,wallthick-adjust]) rotate([0,0,30]) standoff(spacer);
                    translate([102,29.25,wallthick-2*adjust-43]) cube([12,3,25]);
                }
            }
            else {
                translate([107.25,27.75,wallthick-adjust]) rotate([0,0,30]) standoff(spacer);
            }
            translate([5,27.75,wallthick-adjust]) rotate([0,0,30]) standoff(spacer);
            translate([107.25,116.25,wallthick-adjust]) rotate([0,0,30]) standoff(spacer);
            translate([5,109.25,wallthick-adjust]) rotate([0,0,30]) standoff(spacer);
        }
    }
}


module cs4_io(sbc_model,style) {
        if(sbc_model == "hc4") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_hc4.dxf");    
            }
            if(case_style == "Cloudshell4-Mini" || case_style == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_hc4_Mini.dxf");    
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_hc4.dxf");    
            }
        }    
        if(sbc_model == "m1") {
              linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_m1.dxf");    
        }
        if(sbc_model == "n2+" || sbc_model == "n2") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_n2plus.dxf");    
            }
            if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n2plus_Mini.dxf");    
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n2plus.dxf");    
            }
        }
        if(sbc_model == "n1") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_n1.dxf");   
            }
            if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n1_Mini.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_n1.dxf");
            }
        }    
        if(sbc_model == "xu4") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_ioPlate_xu4.dxf");    
            }
            if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_xu4_Mini.dxf");    
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_xu4.dxf");    
            }
        }    
        if(sbc_model == "h3" || sbc_model == "h2") {
              linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_ioPlate_h3.dxf");    
        }
    }


module cs4_deck(sbc_model,style) {
        if(sbc_model == "hc4") {
            difference() {
                if(case_style == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_hc4.dxf");    
                }
                if(case_style == "Cloudshell4-Mini") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_hc4_Mini.dxf");    
                 }
                if(case_style == "Cloudshell4-MiniXL") {
                        linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_hc4_MiniXL.dxf");   
                 }
                if(case_style == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_hc4.dxf");
                }
                if(deck_vent == "hex vent" && case_style != "Cloudshell4-Mini") {
                    translate([9.5,17,adjust]) vent_hex(17, 6, 4, 7.5, 2, "portrait");
                }
            }
        }            
        if(sbc_model == "m1") {
            if(case_style == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_Mini.dxf");    
            }
            if(case_style == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_MiniXL.dxf");    
            }
            if(case_style == "Cloudshell4-MiniXS") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_Mini.dxf");    
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1.dxf");    
            }
            if(case_style == "Cloudshell4-XL" || case_style== "Cloudshell4-XXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_m1_XL.dxf");    
            }
        }
        if(sbc_model == "n2+") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_n2plus.dxf");    
            }
            if(case_style == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_Mini.dxf");
            }
            if(case_style == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_MiniXL.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus.dxf");    
            }
        }
        if(sbc_model == "n2") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_n2plus.dxf");    
            }
            if(case_style == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_Mini.dxf");
            }
            if(case_style == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus_MiniXL.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n2plus.dxf");    
            }
        }
        if(sbc_model == "n1") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_n1.dxf");   
            }
            if(case_style == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n1_Mini.dxf");
            }
            if(case_style == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n1_MiniXL.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_n1.dxf");
            }
        }            
        if(sbc_model == "xu4") {
            if(case_style == "Cloudshell2") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_RearDeck_xu4.dxf");
            }
            if(case_style == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_xu4_Mini.dxf");
            }
            if(case_style == "Cloudshell4-MiniXL") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_xu4_MiniXL.dxf");
            }
            if(case_style == "Cloudshell4") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_xu4.dxf");
            }
        }   
        if(sbc_model == "h3"  || sbc_model == "h2") {
            if(case_style == "Cloudshell4" || case_style == "Cloudshell4-MiniXL") {
                difference() {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_h3.dxf");
                    if(deck_vent == "hex vent") {
                        translate([9,25,adjust]) vent_hex(19, 5, 4, 7.5, 2, "portrait");
                    }
                }  
            }
            if(case_style == "Cloudshell4-Mini") {
                linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_RearDeck_h3_Mini.dxf");
            }
        }
    }

module cs4_front(sbc_model,style) {
        if(sbc_model == "hc4") {
            difference() {
                if(case_style == "Cloudshell2") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");    
                }
                if(case_style == "Cloudshell4-Mini" || case_style == "Cloudshell4-MiniXL") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");
                }
                if(case_style == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");
                }
                if(front_vent == "hex vent" && case_style == "Cloudshell4" || case_style == "Cloudshell2") {
                    translate([9.5,10,adjust]) vent_hex(17, 9, 4, 7.5, 2, "portrait");
                }
                if(front_vent == "hex vent" && case_style == "Cloudshell4-Mini" || case_style == "Cloudshell4-MiniXL") {
                    translate([9.5,10,adjust]) vent_hex(17, 5, 4, 7.5, 2, "portrait");
                }
                // front oled opening
                if(oled_hc4 == true) {
                    if(case_style == "Cloudshell2" || case_style == "Cloudshell4") {
                        translate([(100.95/2-(27.5/2)),104,-.1]) cube([27.5,15,wallthick+.2]);
                    }
                    else {
                        translate([(100.95/2-(27.5/2)),64,-.1]) cube([27.5,15,wallthick+.2]);
                    }
                }
                if(ir_window_style == "rectangle") {
                    if(case_style == "Cloudshell2" || case_style== "Cloudshell4") {
                        translate([84-(ir_xsize/2),111-(ir_ysize/2),-adjust]) 
                            cube([ir_xsize,ir_ysize,wallthick+(adjust*2)]);
                        translate([84-((ir_xsize+4)/2),111-((ir_ysize+4)/2),-wallthick/2]) 
                            cube([ir_xsize+4,ir_ysize+4,wallthick]);
                    }
                    else {
                        translate([84-(ir_xsize/2),71-(ir_ysize/2),-adjust]) 
                            cube([ir_xsize,ir_ysize,wallthick+(adjust*2)]);
                        translate([84-((ir_xsize+4)/2),71-((ir_ysize+4)/2),-wallthick/2]) 
                            cube([ir_xsize+4,ir_ysize+4,wallthick]);
                    }                 
                }
                if(ir_window_style == "hk logo") {
                    if(case_style == "Cloudshell2" || case_style == "Cloudshell4") {
                        sub("art",83-(ir_xsize/2),108-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,"hk_25mm.dxf",0);
                    }
                    else {
                        sub("art",83-(ir_xsize/2),68-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,"hk_25mm.dxf",0);
                    }                 
                }
                if(ir_window_style == "custom") {
                    if(case_style == "Cloudshell2" || case_style== "Cloudshell4") {
                        sub("art",84-(ir_xsize/2),110-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,ir_custom_file ,0);
                    }
                    else {
                        sub("art",84-(ir_xsize/2),70-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,ir_custom_file ,0);
                    }                 
                }
            }
        }            
        if(sbc_model == "m1") {
            difference() {
                if(case_style == "Cloudshell4") {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1.dxf");    
                }
                if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_Mini.dxf");  
                }
                if(case_style == "Cloudshell4-MiniXS") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_MiniXS.dxf");  
                }
                if(case_style == "Cloudshell4-XL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_XL.dxf");  
                }
                if(case_style == "Cloudshell4-XXL") {
                   linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_m1_XXL.dxf");  
                }
                if(ir_window_style == "none") {
                    if(case_style == "Cloudshell4") {
                        translate([37.375-(ir_xsize/2),117.75-(ir_ysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                    }
                    if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                        translate([37.375-(ir_xsize/2),77.75-(ir_ysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                    if(case_style == "Cloudshell4-MiniXS") {
                        translate([37.375-(ir_xsize/2),31.75-(ir_ysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                    if(case_style == "Cloudshell4-XL") {
                        translate([37.375-(ir_xsize/2),172.5-(ir_ysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                    if(case_style == "Cloudshell4-XXL") {
                        translate([37.375-(ir_xsize/2),227.875-(ir_ysize/2),-adjust]) 
                            cylinder(d=6, h=wallthick+2);
                     }                 
                }
                if(ir_window_style == "rectangle") {
                    if(case_style == "Cloudshell4") {
                        translate([31.5-(ir_xsize/2),112-(ir_ysize/2),-adjust]) 
                            cube([ir_xsize,ir_ysize,wallthick+(adjust*2)]);
                        translate([31.5-((ir_xsize+4)/2),112-((ir_ysize+4)/2),-wallthick/2]) 
                            cube([ir_xsize+4,ir_ysize+4,wallthick]);
                    }
                    if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                        translate([31.5-(ir_xsize/2),72-(ir_ysize/2),-adjust]) 
                            cube([ir_xsize,ir_ysize,wallthick+(adjust*2)]);
                        translate([31.5-((ir_xsize+4)/2),72-((ir_ysize+4)/2),-wallthick/2]) 
                            cube([ir_xsize+4,ir_ysize+4,wallthick]);
                    }                 
                    if(case_style == "Cloudshell4-MiniXS") {
                        translate([31.5-(ir_xsize/2),25.75-(ir_ysize/2),-adjust]) 
                            cube([ir_xsize,ir_ysize,wallthick+(adjust*2)]);
                        translate([31.5-((ir_xsize+4)/2),25.75-((ir_ysize+4)/2),-wallthick/2]) 
                            cube([ir_xsize+4,ir_ysize+4,wallthick]);
                     }                 
                    if(case_style == "Cloudshell4-XL") {
                        translate([31.5-(ir_xsize/2),166.75-(ir_ysize/2),-adjust]) 
                            cube([ir_xsize,ir_ysize,wallthick+(adjust*2)]);
                        translate([31.5-((ir_xsize+4)/2),166.75-((ir_ysize+4)/2),-wallthick/2]) 
                            cube([ir_xsize+4,ir_ysize+4,wallthick]);
                     }                 
                }
                if(ir_window_style == "hk logo") {
                    if(case_style == "Cloudshell4") {
                        sub("art",39.5-(ir_xsize/2),108-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,"hk_25mm.dxf",0);
                    }
                    if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                        sub("art",39.5-(ir_xsize/2),68-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,"hk_25mm.dxf",0);
                    }                 
                    if(case_style == "Cloudshell4-MiniXS") {
                        sub("art",30.5-(ir_xsize/2),24-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,"hk_25mm.dxf",0);
                     }                 
                    if(case_style == "Cloudshell4-XL") {
                        sub("art",30.5-(ir_xsize/2),165-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,"hk_25mm.dxf",0);
                     }                 
                }
                if(ir_window_style == "custom") {
                    if(case_style == "Cloudshell4") {
                        sub("art",32-(ir_xsize/2),112-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,ir_custom_file ,0);
                    }
                    if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                        sub("art",32-(ir_xsize/2),72-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,ir_custom_file ,0);
                    }                 
                    if(case_style == "Cloudshell4-MiniXS") {
                        sub("art",21-(ir_xsize/2),28-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,ir_custom_file ,0);
                     }                 
                    if(case_style == "Cloudshell4-XL") {
                        sub("art",21-(ir_xsize/2),170-(ir_ysize/2),-adjust,"top",[0,0,0],
                            ir_xsize,ir_ysize,0,ir_scale,wallthick+2,ir_custom_file ,0);
                     }                 
                }
                if(case_style == "Cloudshell4") {
                    // audio jack
                    translate([82.625,117.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,115.75,-1]) cube([14,2.5,5]);
                    translate([18.5,117.25,5]) sphere(d=10);
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 9, 4, 7.5, 2, "portrait");
                    }
                }
                if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                    // audio jack
                    translate([82.625,77.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,75.625,-1]) cube([14,2.5,5]);
                    translate([18.5,77.125,5]) sphere(d=10);
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 5, 4, 7.5, 2, "portrait");
                    }
                }
                if(case_style == "Cloudshell4-MiniXS") {
                    // audio jack
                    translate([82.625,31.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,29.625,-1]) cube([14,2.5,5]);
                    translate([18.5,31.125,5]) sphere(d=10);
                    if(front_vent == "hex vent") {
                        translate([9,3,adjust]) vent_hex(17, 1, 4, 7.5, 2, "portrait");
                    }
                }
                if(case_style == "Cloudshell4-XL") {
                    // audio jack
                    translate([82.625,172,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,170.5,-1]) cube([14,2.5,5]);
                    translate([18.5,171.5,5]) sphere(d=10);
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 17, 4, 7.5, 2, "portrait");
                    }
                }
                if(case_style == "Cloudshell4-XXL") {
                    // audio jack
                    translate([82.625,227.375,-1]) cylinder(d=6, h=5);
                    // sdcard
                    translate([10.5,225.75,-1]) cube([14,2.5,5]);
                    translate([18.5,227.25,5]) sphere(d=10);
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 23, 4, 7.5, 2, "portrait");
                    }
                }
            }
        }
        if(sbc_model == "n1" || sbc_model == "n2" || sbc_model == "n2+" || sbc_model == "xu4") {
            if(case_style == "Cloudshell2") {
                difference() {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell2_Front.dxf");
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 9, 4, 7.5, 2, "portrait");
                    }                    
                }
            }
            if(case_style == "Cloudshell4-Mini" || case_style== "Cloudshell4-MiniXL") {
                difference() {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_Mini.dxf");
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 5, 4, 7.5, 2, "portrait");
                    }
                }
            }
            if(case_style == "Cloudshell4") {
                difference() {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front.dxf");
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(17, 9, 4, 7.5, 2, "portrait");
                    }                    
                }
            }
        }
        if(sbc_model == "h3" || sbc_model == "h2") {
            if(case_style == "Cloudshell4") {
                difference() {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_h3.dxf");
                    // front port extender opening
                    if(h3_port_extender == "remote") {
                        translate([75,105,-9]) rotate([0,90,90]) h3_port_extender("remote",true);
                    }
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(19, 11, 4, 7.5, 2, "portrait");
                    }
                }
            }
            if(case_style == "Cloudshell4-Mini" || case_style == "Cloudshell4-MiniXL") {
                difference() {
                    linear_extrude(height = wallthick) import(file = "./dxf/CloudShell4_Front_h3_MiniXL.dxf");
                    // front port extender opening
                    if(h3_port_extender == "remote") {
                        translate([75,58,-9]) rotate([0,90,90]) h3_port_extender("remote",true);
                    }
                    if(front_vent == "hex vent") {
                        translate([9,10,adjust]) vent_hex(19, 5, 4, 7.5, 2, "portrait");
                    }
                }
            }
        }            
    }