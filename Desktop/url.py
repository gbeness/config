from bs4 import BeautifulSoup
import requests
import datetime
from dateutil.relativedelta import *

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

WEEKS_TO_CHECK = 1
DAYS_IN_WEEK = 7
listOfRecipients = ['gbeness@umich.edu']

class httpPollerObj(object):
    def __init__(self, url, payload, siteInfo):
        self.urlStr = url
        self.payload = payload
        self.infoStr = siteInfo
        self.senderAddr = 'camping.notification@gmail.com'
        self.password = 'WildAndFree!' 
        self.smtp = smtplib.SMTP(host='smtp.gmail.com', port=587)
        self.smtp.starttls()
        self.smtp.login(self.senderAddr, self.password)
        
        self.availableDates = []
        self.availableSite = []

    def sendNotificationEmail(self, listOfRecipients):
        for recipient in listOfRecipients:
            msg = MIMEMultipart('alternative')

            # add in the actual person name to the message template
            message =  """\
                    Good news! There is a new availablitity %s<br \> \
                    Grab it quick while it is still available'\
                    <a href="%s">abc</a>
                    """ % (self.infoStr, self.urlStr)

            # setup the parameters of the message
            msg['From'] = self.senderAddr
            msg['To'] = recipient
            msg['Subject'] = '[Notification] New Opening Now Available'

            # add in the message body
            #msg.attach(MIMEText(message, 'plain'))
            msg.attach(MIMEText(message, 'html'))

            # send the message via the server set up earlier.
            self.smtp.sendmail(self.senderAddr, recipient, msg.as_string())

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
            self.sendNotificationEmail(listOfRecipients)

    # Returns a list of the next 4 fridays
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



class joshuaTree(httpPollerObj) :
    def __init__(self, parkId, siteInfo):
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
