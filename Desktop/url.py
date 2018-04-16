from bs4 import BeautifulSoup
import requests
import datetime
from dateutil.relativedelta import *
import Singleton
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

WEEKS_TO_CHECK = 1
DAYS_IN_WEEK = 7
listOfRecipients = ['gbeness@umich.edu']
''' 
Things to do:
*create a singleton library 
	-email server shall be a singleton object
	-all htmlobject will have a handle on the same object but 
	-not duplicate
*better email message
* maybe make libraries so that it is not as confusing to have all in one file
*should be a parse method
* should be way to parse entire campground even if there are multiple pages for it
* if there are ltos of hits for a given campground, dont want spam so condense email
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

class httpRequestObj(object):
    def __init__(self, url, payload, siteInfo):
        self.urlStr = url
        self.payload = payload
        self.infoStr = siteInfo
        
        self.availableDates = []
        self.availableSite = []

	self.emailClient = emailClient.instance()

    def sendNotificationEmail(self, listOfRecipients, date):
        for recipient in listOfRecipients:

            # add in the actual person name to the message template
            message =  """\
                    Good news! There is a new availablitity at %s in %s<br \> \
                    Grab it quick while it is still available \
                    <a href="%s">link</a>
                    """ % (self.infoStr, self.parkName, self.urlStr)

            subject = '[Notification] New Opening In %s' % self.parkName

            # send the message via the server set up earlier.
	    self.emailClient.sendEmail(recipient, subject, message)

    def query(self):
        r = requests.get(self.urlStr.rstrip(), params=self.payload)
        r.encoding = r.apparent_encoding
        #print(r.status_code)
        return r

    def parseHtmlResp(self):
        pass


    def checkDates(self, dayToPoll):
        listOfDates = self.getNextValidDates(dayToPoll)
        for date in listOfDates:
            self.updatePayload(date)
            resp = self.query()

            soup = BeautifulSoup(resp.text, 'html.parser')
            #print(soup.prettify())
            t = soup.find_all('div', 'loopName')
            self.sendNotificationEmail(listOfRecipients, date)

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
        jTreeBaseUrl = 'https://www.recreation.gov/campsiteCalendar.do'
        payload = {'page': 'calendar', 'contractCode': 'NRSO', 'parkId':parkId, 'sitepage':'true', 'startidx':'0'}
        super(joshuaTree, self).__init__(jTreeBaseUrl, payload, siteInfo)

    def updatePayload(self, date):
        self.payload.update({'calarvdate': date})


def main():
####### main #######
# should have a poller?
    cottonWood = joshuaTree('159140', 'CottonWood Campsite')
    cottonWood.checkDates(4)
    #jumboRock = joshuaTree('158792', 'Jumbo Rock Campsite')
    #jumboRock.checkDates(4)

if __name__ == "__main__":
    main()
