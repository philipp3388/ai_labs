from pymongo import MongoClient
import datetime
client = MongoClient("mongodb://localhost")
db = client['test']

# exe4
cursor = db.restaurants.find({"address.street":"Rogers Avenue"})
for e in cursor:
    hasC= False
    for a in e['grades']:
        if a['grade']=='C':
            hasC=True
    if hasC:
        db.restaurants.delete_one({"restaurant_id": e['restaurant_id']})
    else:
        e['grades'].append({'date': datetime.datetime(2022, 4, 25), "score": '11', "grade": 'C'})
