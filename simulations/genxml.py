from xml.dom.minidom import Document
import random
random.seed(0)
for j in range(5):
    doc = Document()
    DOCUMENT = doc.createElement('DOCUMENT')
    DOCUMENT.setAttribute('content_method', "full")
    doc.appendChild(DOCUMENT)
    idilst = list(range(1, 101))
    random.shuffle(idilst)
    for i in range(100):
        vehicle = doc.createElement("vehicle")
        vehicle.setAttribute('id', str(i + 1))
        vehicle.setAttribute('id', str(idilst[i]))
        vehicle.setAttribute("route", "route" + str(random.randint(1, 30)))
        vehicle.setAttribute("depart", str(0))
        vehicle.setAttribute("departSpeed", "speedLimit")
        vehicle.setAttribute("color", "1,0,0")
        vehicle.setAttribute("speedFactor", "1.0")
        vehicle.setAttribute("type", "vtype0")
        DOCUMENT.appendChild(vehicle)
    f = open('route-'+str(j+1)+'.xml', 'w')
    doc.writexml(f, indent='\t', newl='\n', addindent='\t', encoding='utf-8')
    f.close()
