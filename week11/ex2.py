from pymongo import MongoClient
import datetime
client = MongoClient("mongodb://localhost")
db = client['test']
result = db.restaurants.insert_one({"Borough": " Manhattan", "cuisine":"Italian",
                                    "Name":"Vella","restaurant_id":"41704620",
                                    "grades":[{'date': datetime.datetime(2014, 10, 1),"score":'11',"grade":'A'}],
                                    "address":{"zipcode":"10075","street":"2 Avenue","building":"1480","coord":[-73.9557413,40.7720266]}})
print('Inserted id:', result.inserted_id)


