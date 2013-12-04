from psd_tools import PSDImage
import Image
import os, sys, json

if len(sys.argv) < 3:
    raise Exception("Parameters requiered: filename and page name")

file = sys.argv[1]
pageName = sys.argv[2]

if  not os.path.exists(file):
    raise Exception("The file " + file + " does not exist")

def saveImage(imgData, foundName, x, y, w, h):
    layerName = foundName[:foundName.find("_")]
    name = foundName[foundName.find("_") + 1:]

    dataType = name[name.rfind('_') + 1:];

    try:
        os.makedirs(dir + "/" + layerName)
    except:
        pass
    
    img = name + ".png"
    imgData.save(dir + "/" + layerName + "/" + img)

    saveTargetSize(imgData, img, layerName, w, h, 800, 480)
    saveTargetSize(imgData, img, layerName, w, h, 1024, 600)
    saveTargetSize(imgData, img, layerName, w, h, 1024, 768)
    saveTargetSize(imgData, img, layerName, w, h, 1280, 800)

    t = {}

    # TODO: Detectar el type button

    if dataType == 'animation':
        t = getCreateAnimationTemplate(pageName, name, layerName, img, x, y)
    else:
        t = getCreateImageTemplate(pageName, name, layerName, img, x, y)

    dataOut.insert(0, t)

def saveInfo(name, data):
    f = open(dir_root + "/" + name, "w")
    f.write(data)
    f.close()

def getCreateAnimationTemplate(pageName, name, layerName, img, x, y):
    # Animation name: door_open_animation
    anim = name[:name.find('_animation')]
    clip = anim[anim.rfind('_') + 1:]
    anim = anim[:anim.rfind('_')]

    t = {"create_animation": { "id": "", "layer": "", "visible": False, "position": { "x":0, "y":0}, "type": "spritesheet", 
	"data": {"root":"", "clips": [], "fps": 10} } }
    t["create_animation"]["id"] = name
    t["create_animation"]["layer"] = layerName
    t["create_animation"]["position"]["x"] = x
    t["create_animation"]["position"]["y"] = y
    t["create_animation"]["data"]["root"] = "img/animations/{}".format(anim)
    t["create_animation"]["data"]["clips"] = [clip]

    return t

def getCreateImageTemplate(pageName, name, layerName, img, x, y):
    t = {"create_image" : { "id": "", "layer": "", "position": { "x":0, "y":0 }, "root": "" }}
    t["create_image"]["id"] = name
    t["create_image"]["layer"] = layerName
    t["create_image"]["position"]["x"] = x
    t["create_image"]["position"]["y"] = y
    t["create_image"]["root"] = "img/{}/{}/{}".format(pageName, layerName, img)

    return t

def saveTargetSize(imgData, img, layerName, w, h, tw, th):
    ratio = float(max_height) / float(th)

    targetDir = dir_template.format(str(tw) + "x" + str(th), pageName) + "/" + layerName

    try:
        os.makedirs(targetDir)
    except:
        pass

    imgData.resize((int(w / ratio), int(h / ratio)), Image.ANTIALIAS).save(targetDir + "/" + img)


psd = PSDImage.load(file)

max_width = 2764 # 16:9 width to 1536 height, instead of 2048, or maybe 1382
max_height = 1536

layers = psd.layers
psd_width = psd.header.width
psd_height = psd.header.height

dir_root = "export"
dir_template = dir_root + "/{}/{}"

dir = dir_template.format("2048x1536", pageName)

dataOut = []

for i in range(0, len(psd.layers)):
    layer = layers[i]
    print "Processing: ", layer.name
    image = layer.as_PIL()
    w,h = image.size

    if w > max_width:
        cx1 = (w / 2) - (max_width / 2)
        cx2 = ((w / 2) - (max_width / 2)) + max_width
       
        left_box = ( 0, 0, w / 2, h)
        right_box = (w / 2, 0, w, h)

        cropped = image.crop(left_box)
        w,h = cropped.size
        saveImage(cropped, layer.name + "_left", left_box[0], left_box[1], w, h)

        cropped = image.crop(right_box)
        w,h = cropped.size
        saveImage(cropped, layer.name + "_right", right_box[0], right_box[1], w, h)
    else:
        saveImage(image, layer.name, layer.bbox.x1, layer.bbox.y1, w, h)


print "Saving json file..."
saveInfo("out.json", json.dumps(dataOut, indent=4, separators=(',', ': ')))
