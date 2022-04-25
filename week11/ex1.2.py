from pymongo import MongoClient
client = MongoClient("mongodb://localhost")
db = client['test']

cursor = db.restaurants.find({"cuisine" : { "$in" :["Indian","Thai"]}})
print('ex1.2 print restaurant with Indian or Thai cuisine')
for e in cursor:
    print(e)
