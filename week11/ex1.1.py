from pymongo import MongoClient
client = MongoClient("mongodb://localhost")
db = client['test']

# ex1.1 print all restaurants with Indian cuisine
cursor = db.restaurants.find({"cuisine":"Indian"})
print('ex1.1 print all restaurants with Indian cuisine')
for e in cursor:
    print(e)
