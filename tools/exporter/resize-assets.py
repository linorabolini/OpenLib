import json, os, sys, Image, fnmatch, shutil, math, time, datetime
from os.path import normpath, basename

if len(sys.argv) < 2:
    raise Exception("Parameters requiered: original animations folder")

dir = sys.argv[1]


force = len(sys.argv) == 2

#if len(sys.argv) == 2:
#    force = True 
#else:
#    force = sys.argv[2]

max_width = 2048
max_height = 1536

def resizeAnim(path, anim, clip, tw, th):
    ratio = float(max_height) / float(th)

    targetDir = "{}x{}/{}".format(tw, th, path)

    try:
        os.makedirs(targetDir)
    except:
        pass


    targetIMGFile = targetDir + "/" + clip + ".png";
    sourceIMGFile = dir + "/" + path +"/" + clip + ".png";

    # Check if the file is newer
    targetTime = 0

    if os.path.exists(targetIMGFile):
        targetTime = os.path.getmtime(targetIMGFile)
    
    sourceTime = os.path.getmtime(sourceIMGFile)
    
    # return if the target file is older than the source one
    if (targetTime < sourceTime):
        print "Newer version of an image has been found: {}".format(targetIMGFile);
        # Resize the image
        img = Image.open(sourceIMGFile)
        w, h = img.size
        img.resize((int(math.ceil(w / ratio)), int(math.ceil(h / ratio))), Image.ANTIALIAS).save(targetIMGFile)

    sourceJSONFile = dir + "/" + path + "/" + clip + ".json";
    targetJSONFile = targetDir + "/" + clip + ".json";

    if not os.path.exists(sourceJSONFile):
        return;

    targetTime = os.path.getmtime(targetJSONFile)
    sourceTime = os.path.getmtime(sourceJSONFile)

    if (targetTime < sourceTime):
        print "Newer version of a JSON file has been found: {}".format(targetJSONFile);
        # Resize the data
        data = json.load(open(sourceJSONFile))

        hasFrames = True
        try:
        	data["frames"]
        except:
        	hasFrames = False;
        	pass

        if hasFrames:
        	for tile in data["frames"]:
	            x, y, h, w = (tile["spriteSourceSize"]["x"], tile["spriteSourceSize"]["y"], tile["spriteSourceSize"]["h"], tile["spriteSourceSize"]["w"])
	            tile["spriteSourceSize"]["x"] = x / ratio
	            tile["spriteSourceSize"]["y"] = y / ratio
	            tile["spriteSourceSize"]["w"] = w / ratio
	            tile["spriteSourceSize"]["h"] = h / ratio
	            h, w = (tile["sourceSize"]["h"], tile["sourceSize"]["w"])
	            tile["sourceSize"]["w"] = w / ratio
	            tile["sourceSize"]["h"] = h / ratio
	            x, y, h, w = (tile["frame"]["x"], tile["frame"]["y"], tile["frame"]["h"], tile["frame"]["w"])
	            tile["frame"]["x"] = x / ratio
	            tile["frame"]["y"] = y / ratio
	            tile["frame"]["w"] = w / ratio
	            tile["frame"]["h"] = h / ratio


        print "CULOOO";
        dataOut = json.dumps(data, indent=4, separators=(',', ': '))
        f = open(targetJSONFile, "w")
        f.write(dataOut)
        f.close()

def processAnimation(basePath, anim, clip):
    resizeAnim(basePath, anim, clip, 512, 384)
    resizeAnim(basePath, anim, clip, 800, 480)
    resizeAnim(basePath, anim, clip, 1024, 600)
    resizeAnim(basePath, anim, clip, 1024, 768)
    resizeAnim(basePath ,anim, clip, 1280, 800)


def copyJson(path, anim, clip, tw, th):
    targetDir = "{}x{}/{}".format(tw, th, path)

    try:
        os.makedirs(targetDir)
    except:
        pass


    targetIMGFile = targetDir + "/" + clip + ".png";

    # return if force is false and file already exists
    if (os.path.exists(targetIMGFile)):
        return

    sourceJSONFile = dir + "/" + path + "/" + clip + ".json";

    if os.path.exists(sourceJSONFile):
        # Resize the data
        data = json.load(open(sourceJSONFile))

        dataOut = json.dumps(data, indent=4, separators=(',', ': '))
        f = open(targetDir + "/" + clip + ".json", "w")
        f.write(dataOut)
        f.close()


def processJson(basePath, anim, clip):
    copyJson(basePath, anim, clip, 512, 384)
    copyJson(basePath, anim, clip, 800, 480)
    copyJson(basePath, anim, clip, 1024, 600)
    copyJson(basePath, anim, clip, 1024, 768)
    copyJson(basePath ,anim, clip, 1280, 800)

def processDir(path):
    for root, dirs, files in os.walk(path):
        print "Checking directory {}".format(root);
        for f in files:
            if fnmatch.fnmatch(f, '*.png'):
                clipName = f[:f.rfind('.png')]
                anim = basename(normpath(root))
                start = len(path) + 1
                end = len(root)
                basepath = root[start:end]
                processAnimation(basepath ,anim, clipName)
            else:
            	if fnmatch.fnmatch(f, '*.json') and f != "info.json":
	            	clipName = f[:f.rfind('.json')]
	                anim = basename(normpath(root))
	                start = len(path) + 1
	                end = len(root)
	                basepath = root[start:end]
	                processJson(basepath ,anim, clipName)


processDir(dir)

