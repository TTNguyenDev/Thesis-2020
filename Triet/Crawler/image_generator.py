from trdg.generators import (
    GeneratorFromDict,
    GeneratorFromRandom,
    GeneratorFromStrings,
    GeneratorFromWikipedia,
)

from PIL import Image

def getTextData(url):
    store = []
    f=open(url, "r")
    lines = f.readlines()

    for i in range(0, 1000):
        store.append(lines[i])
        print(lines[i])
    
    return store

drugName = getTextData('drugbank_formatted.txt')

# The generators use the same arguments as the CLI, only as parameters
generator = GeneratorFromStrings(
    getTextData('drugbank_formatted.txt'),
    # blur=2,
    word_split=True,
    background_type=1, 
    count=2000,
    distorsion_orientation = 2,
    distorsion_type=2,
    alignment = 2
)

for img, lbl in generator:
    temp = img.copy()  # <-- Instead of copy.copy(image)
    # temp.thumbnail((size, height), Image.ANTIALIAS)
    temp.save('%s.%s' % (lbl, 'png'), quality=95)
    # img.save(r'img' + lbl + '.png')


