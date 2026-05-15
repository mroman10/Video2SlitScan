# Video2SlitScan
*Update May 14th, 2026*

I made a new version of the script that runs in Matlab, which seems to run a bit faster than the Processing script. This script similarly lets you select a video from the source folder, save the image in a folder, and define the following variables:
- image length
- slice column (center or choose after a preview from the first frame)
- direction in which the image is plotted
- time delay to start making image later in the video
- 90 degree rotation of the video (for some reason Matlab was reading in videos rotated even when they played right side up)

Here's an example of a slit scan image processed with the Matlab script:
![slitscan image with cars](https://github.com/mroman10/Video2SlitScan/blob/master/matlab_script/images/slitscan_2025.10.20_15.08.41.PNG)

*July 27th, 2024*

A script to create slit scan images from a video in [Processing] 4.3. Requires the [Processing video library].

This script builds on the [slit scan example] in the video library, with the following improvements:
- Uses a saved video as the source rather than the webcam
- Adds the ability to easily define the following:
    -  sample rate
    -  size of the image
    -  direction in which the image is plotted
    -  position of the slit along the width of the video
-  Includes the ability to save the image

Example of a slit scan image created with this script:
![slitscan image with cars](https://github.com/mroman10/Video2SlitScan/blob/master/cars_example_long.png)

Note, for best results shoot video at a high frame rate (120+ FPS, used in slow motion mode) with the camera remaining still (not handheld). The video that was used to create the image above was too large to upload, so only a small clip is included.

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [Processing]: <https://processing.org/>
   [Processing video library]: <https://github.com/processing/processing-video>
   [slit scan example]: <https://github.com/processing/processing-video/blob/main/examples/Capture/SlitScan/SlitScan.pde>
