# A. Requiremnt Description
## Camera Details
Before launching this rating platform, you need to collect cycling videos with GPS traces. The following document and related codes are based on videos collected with a GARMIN virb action camera. We have not tested the codes with videos collected by other cameras. The codes will probably fail if one or more of the following statments is true:
1. The file structure of the your camera is different than what we describe in the section "1. File structure of the camera", such as names of folders or videos are being different.
2. The GPX files (the files containing the GPS traces of videos) of your camera has a different structure, such as a different way of matching GPX files with videos.
3. This is not meant to be a complete list. There might be other issues related to your operating system or other that might cause the code to fail.

## YouTube API
This platform isn't designed to host videos. All short video clips are uploaded to YouTube through API automatically. Therefore, the effectiveness of the auto-uploading script is subject to the update of [YouTube's API](https://developers.google.com/youtube/documentation/). We also used a python wrapper of the API, namely [google-api-python-client](https://github.com/google/google-api-python-client)

## Mapbox API
The GPS traces are snapped to OSM roadnet work using [mapbox](https://www.mapbox.com/api-documentation/?language=Python)'s MapMatcher API.

Please set your access token of mapbox API in the `mapbox_access` variable in `constants.py`

# Packages/Software required
- [ffmpeg](https://www.ffmpeg.org/): used for videos processing, such as cutting videos.
- python: 2.7x, currently not compatible with python 3.x.
    - Required python packages: [xmltodict](https://github.com/martinblech/xmltodict), [rtree](http://toblerity.org/rtree/), [geopandas](http://geopandas.org/), [google-api-python-client](https://github.com/google/google-api-python-client), [mapbox](https://www.mapbox.com/api-documentation/?language=Python)


## B. Workflow
The workflow of the project is as follows:
1. Collect cycling videos
2. Preprocess the videos as described in **Section 2**
3. Store the processed videos on a local machine following the file structure descrbied in **Section 3**
4. Bootstrap the database of the platfrom with the processed videos following steps described in **Section 4~7** and the following command lines:
```
# $R is the root directory where the videos and gps traces are as described in Section 3
# $seg is the file path of the desired segment network file, such as segments.geojson
$ python split_video_gpx.py -r $R -l 30
$ python trace2segs.py -r $R --segs $segs
$ python upload_video_in_dir.py -r $R
$ python file2DB.py -r $R --segs $segs
```
5. Collect ratings from users.

In other words, we didn't collect and insert new videos into the database. If you collect new videos after the platform is launched, make sure you don't insert duplicate video clips into the database. Otherwise, you might have multiple rows of data in the table with the same YouTube link.

Next, We describe each step in detail.

# 1. File structure of the camera
> This section is applicable only to GARMIN VIRB action camera.

After videos are collected, the file structure will be like this:
- Camera/
    - DCIM/
        - ???_VIRB/: ??? will be 100, 101, 102 and so on. 
        > ??? keeps increasing even if previous folder is deleted.

            - VIRB????.MP4:  ???? will be 0001, 0002, 0003 and so on.
    - Garmin/GPX/Track_yyyy-mm-dd HHMMSS.gpx

# 2. Manually preprocess the videos
The videos are usually in high quality (720p or 1080p), recording the surroundings clearly, including pedestrians and car plates. We should blur this information before publishing the videos. You can choose whatever software you like to blur the face of pedestrians and car plates. Here we describe how you can do it with YouTube.

1. To reduce the amount of blurring-work in step 3, we choose to degrade the quality of the videos to 480p. After you do step 3, you can do the conversion by this:
`ffmpeg -i filename.MP4 -s 854X480 new_dir/filename.MP4`.
2. Manually upload the videos to YouTube, apply face blurring as described [here](https://www.wikihow.com/Blur-Faces-in-a-YouTube-Video). It takes about 1 day for a 20-minute long 1080p video. But blurring is parallel, i.e., you can blur all your videos at the same time.
3. Manually blur car plates ([like this](https://youtube-creators.googleblog.com/2016/02/blur-moving-objects-in-your-video-with.html)). This step could be very time-consuming if there are lots of cars on the streets.
4. Download the processed videos from YouTube and save each video with the same name prior to preprocessing. This is important because the video name is required to match the correct GPS trace.


# 3. File structure on the local machine
After manually preprocessing videos, make sure the files (videos, GPX files and others) on the local machine are organized as follows:
- root_directory (denoted as **$R**):
  - DCIM/???_VIRB/VIRB????.MP4
  > videos after preprocessing as described in Section 2
  - GPX/Track_yyyy-mm-dd HHMMSS.gpx
  - client_secrets.json
  > youtube client secrets for uploading. This can be created on [google's developer console](https://console.developers.google.com/apis/credentials)
  - segments.geojson:
  > segments network file, used to map videos to segments
  > For Washington D.C., we obtained the segments files from [this link](http://opendata.dc.gov/datasets/street-segments)
  > Segments are also available from [OpenStreetMap](openstreetmap.org).

# 4. Split videos and gps traces
This step is processed using this python script: **split_video_gpx.py**.

**Example usage of this script:**
```
$ python split_video_gpx.py -r $R -l 30
```
This means that the root directory containing the videos and GPX files as well as the directory that will contain the output of this script is **$R** (defined by `-r`). The maximum length of the video clips is 30 seconds (defined by `-l`)

**Parameters**
- -r or --root-dir (required): root directory containing videos and gpx files, i.e., $R in Section 3
- -l (optional): maximum duration for video clips (seconds)
- -s or --split-dir (optional): directory to store video_clips and snapped traces (default **$R**/split, denoted as **$SPLIT**)
- For information of different parameters: `$ python split_video_gpx.py --help`

**Input/Process/Output of the script**
- Input: videos and gpx in **$R**
- Process: Cut videos and corresponding GPX files.
    - A video clip is cut if (a) the length of that clip equals to the maximum duration, or (b) there is a long stop (e.g., stop at a long red traffic light). Therefore, a video clip doesn't always  last the maximum duration.
    - The GPS traces are snapped to OSM roadnet work using [mapbox](https://www.mapbox.com/api-documentation/?language=Python)'s MapMatcher API.
- Output:

  - $R/gpx_video_match.csv
    > mapping between GPX/Track_yyyy-mm-dd HHMMSS.gpx and DCIM/???_VIRB/VIRB????.MP4, and information of gpx quality

  - $SPLIT/DCIM/???_VIRB/
    - VIRB????_[cnt].MP4: clips of original [video_name].MP4
    
    - VIRB????.json: snapped result of gpx
        > list of dictionaries with the following keys:
        - clip_name: file name of the corresponding clip;
        - duration_clip: duration (in seconds) of this clip;
        - raw: list of dict {"batch": No.X batch of the clip traces; "raw_len": number of points; "raw": list of (lon lat) points}
        - snapped: list of dict {"batch": No.X batch of the clip traces; "sub_batch": one snap request can return multiple snapped traces; "snapped_len": number of snapped points; "confidence": confidence of this snapped traces; "snapped": list of (lon lat) points}
        - v_max: maximum velocity computed by raw_traces of this clip;
        - v_avg: average velocity of this clip;
        - v_median: median velocity of this clip;

# 5. Map video clips to desired segment network
After Section 4, we have a set of short video clips and their corresponding snapped gps traces. In this section, we find the relationship between video clips and the desired segment network.
This step is processed using this python script: **trace2segs.py**.


**Example usage of this script:**
```
$ python trace2segs.py -r $R --segs $segs
```
This means that the root directory containing the videos and GPX files and the directory that will contain the output of this script is **$R** (defined by `-r`). The path of the file with the segments is **$R**/$segs (defined by `--segs`)

**Parameters**
- --segs (required): the path to the segment file
- -r (required): the root directory the same as split_video_gpx.py
- For information of different paramaters: `$ python trace2segs.py --help`

**Input/Process/Output of the script**
- Input:
    - The segments file in **$R**
    - **$R**/gpx_video_match.csv from Section 4
    - $SPLIT/DCIM/???_VIRB/VIRB????.json from Section 4
- Process:
    - Find segment candidates for each snapped GPS coordinates
    - Find the most likely segments corresponding to each cycling video clip.
- Output:
    - **$R**/segs_for_clips.csv: matched segments for each clip. A clip could cover multiple segments partially, e.g., a clip could cover 80% of one segment and 70% of another.
    - **$R**/clips_quality.csv: Not each clip produced by Section 4 should be uploaded. For example, a video clip covers less than 10% of just 1 segments; some clips have no snapped GPS coordinates (e.g. due to weak GPS signal) and cannot be matched with any segments

# 6. Upload video clips to YouTube
Upload video clips automatically via YouTube's API with the script `upload_video_in_dir.py`

**Example usage of this script:**
```
$ python upload_video_in_dir.py -r $R
```
This means that the root directory containing the videos and GPX files and the one that will contain the output of this script is **$R** (defined by `-r`).

**Parameters**
- -r or --root-dir (required): root directory containing videos and gpx files, i.e., $R in Section 3
- For information of different parameters: `$ python upload_video_in_dir.py --help`

**Input/Process/Output of the script**
- Input:
    - **$R**/client_secrets.json
    - **$R**/clips_quality.csv
- Process:
    - Upload clips one by one with 20-second pause, excluding the clips with bad quality. If an uploadLimitExceeded error is received, pause for 3600 seconds.
    - Clips with bad quality are defined as the ones without matched segments
- Output:
  - **$R**/upload_result.log: each line in the log file is formated as follows:
  > The datetime of uploading this clip \t {'uploaded': statues of upload, 'videoId': url id for a uploaded clip, 'response': if videoId can't find in response; 'error': http error during upload}


# 7. Get CSV files to bootstrap the database of the plarform
Get CSV files based on files from previous steps using this script `files2DB.py`

**Example usage of this script:**

```
$ python file2DB.py -r $R --segs $segs
```
This means the root directory containing the videos and GPX files as well as the directory that will contain the output of this script is **$R** (defined by `-r`). The path of the file of segments is **$R**/$segs (defined by `--segs`)


**Parameters**
- --segs (required): the path to the segment file
- -r or --root-dir (required): the root directory the same as split_video_gpx.py
- For information of different paramters: `$ python files2DB.py --help`

**Input/Process/Output of the script**
- Input
    - The segments file in **$R**
    - **$R**/segs_for_clips.csv from Section 5
    - **$R**/upload_video.log from Section 6
- Process
    - Extract information from files produced by previous steps and convert the information as DB-table-like csv files
- Output
    - **$R**/2DB_RoadSegment.csv: with columns: sid, STREETSEGID, index_seg, totalScore, how_many, wkt
    - **$R**/2DB_video.csv: with columns: vid, clip_name, title, videoId
    - **$R**/2DB_video2seg_temp.csv: with columns: svid, clip_name, index_seg, ratio