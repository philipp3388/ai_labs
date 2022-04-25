from pymongo import MongoClient
import datetime
client = MongoClient("mongodb://localhost")
db = client['test']
# ex3 delete one Manhattan restaurant
result = db.restaurants.delete_one({"Borough":"Manhattan"})
print('No problem occur with delete operation')


