import json, os, sys, Image, fnmatch

if len(sys.argv) < 2:
    raise Exception("Parameters requiered: original animations folder")

dir = sys.argv[1]

max_width = 2048
max_height = 1536

def resizeAnim(anim, clip, tw, th):
    ratio = float(max_height) / float(th)

    targetDir = "img/{}x{}/animations/{}".format(tw, th, anim)

    try:
        os.makedirs(targetDir)
    except:
        pass

    # Resize the image
    img = Image.open(dir + "/" + anim + "/" + clip + ".png")
    w, h = img.size
    img.resize((int(w / ratio), int(h / ratio)), Image.ANTIALIAS).save(targetDir + "/" + clip + ".png")

    # Resize the data
    data = json.load(open(dir + "/" + anim + "/" + clip + ".json"))

    for tile in data["frames"]:
        x, y, h, w = (tile["frame"]["x"], tile["frame"]["y"], tile["frame"]["h"], tile["frame"]["w"])
        tile["frame"]["x"] = x / ratio
        tile["frame"]["y"] = y / ratio
        tile["frame"]["w"] = w / ratio
        tile["frame"]["h"] = h / ratio

    dataOut = json.dumps(data, indent=4, separators=(',', ': '))
    f = open(targetDir + "/" + clip + ".json", "w")
    f.write(dataOut)
    f.close()

def processAnimation(anim, clip):
    print "Processing {} of {}...".format(clip, anim)
    resizeAnim(anim, clip, 800, 480)
    resizeAnim(anim, clip, 1024, 600)
    resizeAnim(anim, clip, 1024, 768)
    resizeAnim(anim, clip, 1280, 800)

for anims in os.walk(dir).next()[1]:
    for clip in os.listdir(dir + "/" + anims):
        if fnmatch.fnmatch(clip, '*.png'):
            clipName = clip[:clip.rfind('.png')]
            processAnimation(anims, clipName)
