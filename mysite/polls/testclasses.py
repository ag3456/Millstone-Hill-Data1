from madData import madData
from madrigalWeb import madrigalWeb

user_fullname = 'Ashaki Gumbs'
user_email = 'agumbs@bu.edu'
user_affiliation = 'Boston University'

madrigalUrl = 'http://isr.sri.com/madrigal'

testData = madrigalWeb.MadrigalData(madrigalUrl)

expList = testData.getExperiments(61, 2017,1,20,0,0,0,2017,8,22,0,0,0, local=0)

madData(expList)

for i in range(len(expList)):
    q = Question(question_text = expList[i].name, pub_date = timezone.now() , madrigalUrl = expList[i].madrigalUrl,
             name = expList[i].name, realUrl = expList[i].realUrl, 
             url = expList[i].url)
    q.save()
    
    