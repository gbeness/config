from bs4 import BeautifulSoup
from dateutil.relativedelta import *
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import requests
import datetime
import Singleton
import smtplib
import polling

WEEKS_TO_CHECK = 1
DAYS_IN_WEEK = 7
listOfRecipients = ['gbeness@umich.edu']
''' 
Things to do:
* should be way to parse entire campground even if there are multiple pages for it
* maybe have an emailserver that can build buffered emilas
* and send buffered emails 
* Here are the availabilities for 05/xx/2018:
    Joshua Tree National Park: CottonWood Campground A01
    Joshau Tree National Park: Black Rock Campground B04
    ...

* Here are the availabilities for 05/xx/2018:
    Joshua Tree National Park: CottonWood Campground A01
    Joshau Tree National Park: Black Rock Campground B04
    ...
'''
@Singleton.Singleton
class emailClient():
    def __init__(self):
        self.senderAddr = 'camping.notification@gmail.com'
        self.password = 'WildAndFree!' 
        self.smtp = smtplib.SMTP(host='smtp.gmail.com', port=587)
        self.smtp.starttls()
        self.smtp.login(self.senderAddr, self.password)

    def sendEmail(self, recipient, subject, message):
        msg = MIMEMultipart('alternative')
	msg['From'] = self.senderAddr
	msg['To'] = recipient
	msg['Subject'] = subject 
	msg.attach(MIMEText(message, 'html'))
	self.smtp.sendmail(self.senderAddr, recipient, msg.as_string())

    
    def buildEmail(self):
        pass
    def updateEmail(self):
        pass





class httpRequestObj(object):
    def __init__(self, baseUrl, queryUrl, payload, siteInfo):
        self.baseUrl = baseUrl
        self.queryUrl = queryUrl
        self.payload = payload
        self.infoStr = siteInfo
        
        self.availableDates = []
        self.availableSites = []

	self.emailClient = emailClient.instance()
        self.htmlSession = requests.Session()

    def sendNotificationEmail(self, listOfRecipients, date):
        for recipient in listOfRecipients:

            # add in the actual person name to the message template
            message =  """\
                    Good news! There is/are new availablitity at %s in %s<br \> \
                    Grab it quick while it is still available \
                    <a href="%s">link</a>
                    """ % (self.infoStr, self.parkName, self.queryUrl)

            subject = '[Notification] New Opening In %s' % self.parkName

            # send the message via the server set up earlier.
	    self.emailClient.sendEmail(recipient, subject, message)

    def query(self, url, payload=None, cookies=None, headers = None):
        r = self.htmlSession.get(url, params=payload, cookies=cookies, headers=headers)
        r.encoding = r.apparent_encoding
        #print(r.status_code)
        return r

    def parseHtmlResp(self):
        pass


    def checkDates(self, dayToPoll):
        listOfDates = self.getNextValidDates(dayToPoll)
        availabilityInfo = {} 
        for date in listOfDates:
            self.updatePayload('calarvdate', date)
            resp = self.query(self.queryUrl, self.payload)
            self.parseHtmlResp(resp)
            #print(soup.prettify())
            #self.sendNotificationEmail(listOfRecipients, date)
    '''
    dict = {}
    dict.update({'andrew': [('hello','world')]})
    dict['andrew'].append(('must', 'be'))
    print dict
    dict.update({'andrew': [('h','world')]})
    dict['andrew'].append(('must', 'be'))
    '''

    # Returns a list of the next 4 *day
    def getNextValidDates(self, day):
        list = []
        currentDate = datetime.datetime.now()
        #weekday = 0-6
        nextDate= currentDate + relativedelta(weekday=day)
        for x in range(0, WEEKS_TO_CHECK):
            next = nextDate+ datetime.timedelta(days=x*DAYS_IN_WEEK)
            formattedTime = next.strftime("%m/%d/%Y")
            list.append(formattedTime)
        return list



class joshuaTree(httpRequestObj) :
    def __init__(self, parkId, siteInfo):
	self.parkName = 'Joshua Tree National Park'
        self.lengthOfStay = 3
        #https://www.recreation.gov/camping/cottonwood-campground-ca/r/campsiteDetails.do?siteId=472279&contractCode=NRSO&parkId=159140&offset=0&arvdate=4/19/2018&lengthOfStay=1
        queryUrl = 'https://www.recreation.gov/campsiteCalendar.do'
        baseUrl = 'https://www.recreation.gov'
        payload = {'page': 'calendar', 'contractCode': 'NRSO', 'parkId':parkId, 'sitepage':'true', 'startIdx':'0'}
        super(joshuaTree, self).__init__(baseUrl, queryUrl, payload, siteInfo)

    def updatePayload(self, key, value):
        self.payload.update({key: value})

    def parseHtmlResp(self, queryResp):
        idxFlag = True
        while idxFlag:
            htmlBody = BeautifulSoup(queryResp.text, 'html.parser')
            tbodys= htmlBody.find_all('tbody')
            # this has only the campground info
            tbody = tbodys[1] 
            # Container of all <tr>, contains campsites, calendar, availability
            trTags = tbody.find_all('tr')
             
            for trTag in trTags:
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
                    for i in range(self.lengthOfStay):
                        if tds[i].text == 'A':
                            ahref = tds[i].find('a', {'class': 'avail'})
                            availabilityUrl = ahref['href']
                            self.availableSites.append((campsiteName, availabilityUrl))

            # next url with more info about campsites
            tfoots= htmlBody.find('tfoot')
            aHrefs = tfoots.findAll('a', href=True) 
            for elt in aHrefs:
                if 'Next' in elt.text:
                    queryResp = self.query(self.baseUrl + elt['href'])
                else:
                    idxFlag = False


    def extractCampsiteAvailability(self, trTags):
        for trTag in trTags:
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
                for i in range(self.lengthOfStay):
                    if tds[i].text == 'A':
                        ahref = tds[i].find('a', {'class': 'avail'})
                        availabilityUrl = ahref['href']
                        self.availableSites.append((campsiteName, availabilityUrl))


def pollerListInit():
    pollerObjects = []

    cottonWood = joshuaTree('159140', 'CottonWood Campsite')
    jumboRock = joshuaTree('158792', 'Jumbo Rock Campsite')
    pollerObjects.append(cottonWood)
    #pollerObjects.append(jumboRock)
    return pollerObjects
    
def pollContainer(container):
    for object in container:
        object.checkDates(3)

def roundRobin(container):
    polling.poll(lambda: pollContainer(container), step=600, poll_forever=True)
    
if __name__ == "__main__":
    
    roundRobin(pollerListInit())
