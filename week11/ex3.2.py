from pymongo import MongoClient
import datetime
client = MongoClient("mongodb://localhost")
db = client['test']
# ex3 delete all thai restaurants
result = db.restaurants.delete_many({"cuisine":"Thai"})
print('No problem occur with delete operation')
