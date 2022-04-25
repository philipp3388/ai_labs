from pymongo import MongoClient
client = MongoClient("mongodb://localhost")
db = client['test']

print ("ex1.3 print restaurant with the specified address")
cursor = db.restaurants.find({"address.zipcode" : "11226","address.street":"Rogers Avenue","address.building":"1115"})
for e in cursor:
    print(e)
