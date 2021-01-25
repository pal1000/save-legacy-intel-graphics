## About Save Legacy Intel OpenGL
This repository is intended to be a catalog of fixes to get OpenGL working on Windows 10 for programs coded to advertise Window 10 compatibility on old Intel graphics controllers. The following graphics controllers generations are affected by this issue:
- 3rd generation Graphics Media Accelerators except GMA 910 and 915 series; [1]
- 4th generation Graphics Media Accelerators;
- PowerVR edition Graphics Media Accelerators;
- 1st and 2nd generations Intel HD Graphics.

Note [1]: Intel GMA 910 and 915 series released in 2004 and 2005 respectively didn't get WDDM driver which means they only work with Windows XP, Vista and 7 according to [Wikipedia](https://en.wikipedia.org/wiki/List_of_Intel_graphics_processing_units#Third_generation).

## End-user guide
- download the whole code as ZIP and extract it;
- double-click the .cmd file intended for the program you want to fix OpenGL for [2].

[2] Some program fixes included are for software runtimes like Java. If your program is using such runtime make sure you apply the fix for the runtime first and see if the issue goes away. You don't want to waste both mine and your time with an invalid contribution like the individual from [here](https://communities.intel.com/thread/123618) did.

If a program has both 32-bit and 64-bit versions and you have only one of them installed, the one you don't have gets fixed in advance in case you install it at a later date see [#1](https://github.com/pal1000/save-legacy-intel-opengl/issues/1).

You don't need Application Compatibility Toolkit to install fixes. You only need the affected program and a copy of this repository codebase.

## Why we have this issue
In order to fix any problem we must understand its root cause. In the early days of Windows 10 development Microsoft decided to change the Windows major version from 6 to 10. However Microsoft thought it is enough to provide software developers APIs to advertise Windows 10 compatibility. Programs that advertise compatibility get current OS version when they ask for it, others get the old 6.3 format. When implementing this Microsoft forgot about dynamic link libraries or maybe was unable to do anything about them. There is no similar mechanism(s) for DLLs as far as I know, they always inherit Windows version received by the programs that loads them. As a result of this, things go south when a program advertising Windows 10 compatibility loads a DLL that is not ready for current Windows 10 major version. Anything can happen but most likely the DLL just unloads right away. Intel OpenGL driver for iGPU generations listed above is the perfect example and as a result it unloads immediately.

## Determine if a program is affected without running it (for advanced users)
It is possible to determine if a program is affected by inspecting its manifest if exists as shown in this video
[![Play](https://pal1000.github.io/shared/tutorials/video.png)](https://pal1000.github.io/shared/tutorials/detect-win10-compat-advertising.mov)

## Ways to fix this problem
### Patch Intel OpenGL driver to recognize Windows 10 major version

Done by [Marcinosoft](https://github.com/Marcinosoft) for various Intel GPU generations. DLLs are scattered throughout [this issue thread](https://github.com/LWJGL/lwjgl/issues/119).

Pros:
- it fixes all affected programs at once if enough effort is put into overcoming the cons.

Cons:
- breaks digital signature of the OpenGL driver which needs fixing by removing it and replacing it with new code signature to retain compatibility with protected processes like Virtualbox;
- if you are downloading a pre-patched copy from Internet (not recommended) it must be for your Intel GPU generation;
- this is the riskiest method.

### Alter or remove the manifest of programs lacking OpenGL support (remove the tag that contains `{8` unique identifier from the manifest)

Pros:
- less risky than OpenGL driver patching.

Cons:
- can only fix affected programs individually;
- basic usage of binary editing tools is needed for embedded manifests [3];
- it is still a manual process that is not mass deployment friendly;
- basic HTML and XML knowledge is needed [3];
- cannot fix protected processes like Virtualbox.

[3]: [WTFI tool](https://raw.githubusercontent.com/alexey-lysiuk/tools/master/wtfi/Release/wtfi.exe) eliminates these complexity relared cons.

### Use [Mesa3D](https://github.com/pal1000/mesa-dist-win) as an alternative to Windows inbox OpenGL 1.1 software renderer. Install Mesa3D desktop OpenGL drivers using system-wide deployment tool.

Pros:
- supports OpenGL 4.5 in core profile while OpenGL supported by affected drivers even when fixed barely get to OpenGL 3.1;
- it fixes all affected programs at once;
- included software rasterizers work through RDP, GPU OpenGL only works through RDP on currently supported hardware;
- can be installed even if GPU OpenGL is working correctly, e.g. just to get RDP OpenGL support.

Cons:
- not digitally signed but you can sign it with an Ascertia Free Try code signing certificate if you want;
- far slower than the GPU since it is still a software renderer.

### Create a compatibility shim with Win81RTMVersionLie fix for Intel OpenGL driver applied to affected programs individually (this is the method used by this project)

Pros:
- cleanest method (it doesn't touch the program directly);
- it is mass deployment friendly (we can create a repository of fixes with people picking the ones they need);
- using its internal version of Compatibility Administrator Microsoft can create a master fix that works for all affected programs, it might even work in kernel mode and for programs using protected process APIs like Virtualbox. Feedback suggesting this enhancement is filed [here](https://aka.ms/Sn9jtj).

Cons:
- public version of Compatibility Administrator cannot fix kernel mode and protected processes like Virtualbox;
- public version of Compatibility Administrator can only fix affected programs individually;
- creation of fixes requires decent knowledge in using Compatibility Administrator tool.

Video tutorial on creating a compatibility shim with Win81RTMVersionLie fix is below
[![Play](https://pal1000.github.io/shared/tutorials/video.png)](https://pal1000.github.io/shared/tutorials/legacy-igpu-ogl-fix-win10.mov)
