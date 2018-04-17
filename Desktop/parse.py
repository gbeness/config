from bs4 import BeautifulSoup
import re

file = open('ex.html', 'r')
'''
soup = BeautifulSoup(file, 'html.parser')




#----------------------------------------------------------------------#
#print(soup.prettify())
tbodyMain = soup.find_all('tbody')

# this has onyl the campground info
tbody = tbodyMain[1] 

trs = tbody.find_all('tr')
# This will find the first separator
print (len(tr[0]))
if 'first' in tr[0]["class"]:
    print "YESSS"

for trTag in trs:
    # This is the horizontal separator between campsite info
    if trTag.has_attr('class'):
        print 'separator'
    else:
        # extract the campsite name
        campsite = trTag.find('td', {'class': 'sn'})
        aHrefs = campsite.find('a', href=True) 
        link =  aHrefs['href']
        campsiteName =  aHrefs.text.strip()
        #print "site %s and url %s" % (name, site)

       #THIS IS THE STATUS OF THE DAYS OF THE CAMPSITE 
        tds = trTag.findAll('td', {'class': 'status'})
        for td in tds: 
            if td.text == 'A':
                availLink = td.find('a', {'class': 'avail'})
                print availLink['href']
            
            #print td.findChild() == None
            else:
                print "nothing"
            print '-----------------------'

'''
availableSites = []
htmlBody = BeautifulSoup(file, 'html.parser')
tbodys= htmlBody.find_all('tbody')
# this has only the campground info
tbody = tbodys[1] 
# Container of all <tr>, contains campsites, calendar, availability
trs = tbody.find_all('tr')

for trTag in trs:
    # This is the horizontal separator between campsite info
    if trTag.has_attr('class'):
        pass  
    else:
        # extract the campsite name
        campsite = trTag.find('td', {'class': 'sn'})
        ahref = campsite.find('a', href=True) 
        campsiteName =  ahref.text.strip()

       # THIS IS THE STATUS OF THE DAYS OF THE CAMPSITE 
        tds = trTag.findAll('td', {'class': 'status'})
        for i in range(3):
            if tds[i].text == 'A':
                ahref = tds[i].find('a', {'class': 'avail'})
                availabilityUrl = ahref['href']
                availableSites.append((campsiteName, availabilityUrl))

tfoots= htmlBody.find('tfoot')

aHrefs = tfoots.findAll('a', href=True) 
print aHrefs
for elt in aHrefs:
    if 'Next' in elt.text:
        print elt['href']
'''
#this can be the dates, and assocaited campground that are open
dict = {}
dict.update({'andrew': [('hello','world')]})
dict['andrew'].append(('must', 'be'))
print dict
dict.update({'andrew': [('h','world')]})
dict['andrew'].append(('must', 'be'))
print dict
'''
