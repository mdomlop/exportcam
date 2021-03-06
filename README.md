ExportCam
---------

Export photos and videos from digital cameras (such Android camera) to a local
storage.
 
This means that all that program does is moving something like 
IMG_20180424_065600.jpg to something as /data/photos/2018/04/20180424 065600.jpg
 
Actually only Android Camera format is 
supported: `IMG/VID_YYYYMMDD_HHMMSS.jpg/mp4`

Usage
-----

You may have a directory destinated to store your photos and vídeos. For 
example: `/data/album`

Open a terminal where you have your media (you can copy DCIM/Camera to 
your desktop)

        $ cd ~/Desktop/Camera
    
Then run the program:

        $ exportcam /data/album

And all photos and videos in `~/Desktop/Camera` will be exported to
`/data/album`

You can set the export directory by command line or by configuration file in
`~/.config/exportcam`:

        $ echo /data/album > ~/.config/exportcam
    
        $ cd ~/Desktop/Camera
        $ exportcam 
    
Installation
------------

You can choose between different installation methods:

### Classic method ###

- Build and install:

        $ make
        # make install

- Uninstall:

        # make uninstall

### Debian package ###

- Build and install:

        $ make debian_pkg
        # dpkg -i exportcam_1_all_.deb

- Uninstall:

        # apt purge exportcam

