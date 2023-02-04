# Cloudshell4 Unauthorized


## Introduction

Cloudshell4 case design for the Hard Kernel Odroid-hc4, m1, n1, n2, n2+, xu4, h2, h2+, h3, h3+

License: GPLv3.

### Install
```
  git clone https://github.com/hominoids/Cloudshell4_Unauthorized
  cd Cloudshell4_Unauthorized
  git submodule init
  git submodule update

```

### Cloudshell4 Unauthorized Benefits:
-  Multi SBC Support
-  Easy 3D Printing
-  Dual 3.5" HD

Odroid-hc4 Series

![Image](Cloudshell4_Series.gif)

Odroid-m1 Series
![Image](Cloudshell4_M_Series.gif)

### Notes

  More information can be found at this [Hard Kernel forum thread](https://forum.odroid.com/viewtopic.php?f=206&t=40769)

# SBC Case Builder


## Introduction

This project is about autonomous SBC case creation. It utilizes the SBC Model Framework project to automatically generate cases based on the data for any of the 53 current SBC contained within the framework. This allows legacy, current and future SBC to have multiple cases available on day one of their inclusion in the framework. There are multiple base case designs(shell, panel, stacked, tray, tray-sides, round, hex, snap, fitted) available and each allows for different styles within the design.

All case openings are created automatically based on SBC data and the dimensions of any case design can be expanded in any axis allowing for the creation of larger cases. If you reposition the SBC in a case, you will see i/o openings created or removed appropriately based on it’s proximity to the case geometry. These cases might be useful for prototypes or other in house uses to quickly and easily create standard, specialized and custom SBC cases thru different case designs, styles and accessories.

License: GPLv3.

![Image](SBC_Case_Builder_Cases.gif)

### Install
```
  git clone https://github.com/hominoids/SBC_Case_Builder.git
  cd SBC_Case_Builder
  git submodule init
  git submodule update

```

### SBC Case Builder Features:
-  Autonomous Multi-SBC, Multi-Case Parametric Generation
-  Autonomous Case Standoffs with Variable Height
-  Extended Standoff SBC collision detection
-  Accessory Customization Framework
-  Accessory Multi-Associative Parametric Positioning
   - Absolute Location
   - Case Associations
   - SBC Associations
   - SBC_X,Y - Case_Z Association
-  SBC Model Framework Validation Tool
