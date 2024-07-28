# Video2SlitScan
*Last updated July 27th, 2024*

A script to create slit scan images from a video in [Processing] 4.3. Requires the [processing video library].

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

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [Processing]: <https://processing.org/>
   [processing video library]: <https://github.com/processing/processing-video>
   [slit scan example]: <https://github.com/processing/processing-video/blob/main/examples/Capture/SlitScan/SlitScan.pde>
